#!/usr/bin/env bash
shopt -s globstar

get_tmux_option() {
	local option="$1"
	local default_value="$2"
	local option_value=$(tmux show-option -gqv "$option")
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

OPEN_STRATEGY="$(get_tmux_option "$open_strategy" ":e")"
MENU_STYLE="$(get_tmux_option "$menu_style")"
MENU_SELECTED_STYLE="$(get_tmux_option "$menu_selected_style")"
PRIORITIZE_WINDOW=true

if [ -n "$MENU_STYLE" ]; then
	tmux_menu_s="-s $MENU_STYLE"
fi
if [ -n "$MENU_SELECTED_STYLE" ]; then
	tmux_menu_H="-H $MENU_SELECTED_STYLE"
fi

# Check pipe from stdin or parameter
FPATH=${STDIN:-$1}
if [ "$1" ]; then
	FPATH=$1
elif read -r -t 2 STDIN; then
	FPATH=$STDIN
else
	echo "No file provided for opening" && exit 1
fi
FPATH=$(echo "$FPATH" | awk '{$1=$1};1') # trimming whitespace

# Parse line:col
readarray -td: a < <(printf %s "$FPATH")
[ "${a[0]}" ] || { echo "You must supply a filename. Found ${a[0]}" && exit 1; }
FILE=$(realpath "${a[0]}")
[ "$FILE" ] || { echo "Couldn't open file ${a[0]}" && exit 1; }
LINE=${a[1]:-0}
COLUMN=${a[2]:-0}

# Get all nvim listening sockets (default location)
# TODO: don't use `ls` here. Maybe `find` instead
readarray -t LISTEN_SOCKS < <(ls "${XDG_RUNTIME_DIR:-${TMPDIR}nvim.${USER}}"/**/nvim.*.0 2>/dev/null)

CURRENT_WINDOW_INDEX=$(tmux display-message -p '#{window_index}')
CURRENT_SESSION_NAME=$(tmux display-message -p '#{session_name}')

MENU_ARGS=()
SOCK_COUNT=${#LISTEN_SOCKS[@]}
SOCK_INDEX=1
for sock in "${LISTEN_SOCKS[@]}"; do
	# extract pid from socket path
	server_pid=$(echo "$sock" | awk -F'.' '{print $(NF-1)}')
	[ -n "$server_pid" ] || continue

	# process id of server's parent, which is the nvim client
	client_pid=$(ps -o ppid= -p "$server_pid" | tr -d ' ')
	[ -n "$client_pid" ] || continue

	# process id of tmux pane that contains the nvim client
	pane_pid=$(ps -o ppid= -p "$client_pid" | tr -d ' ')
	[ -n "$pane_pid" ] || continue

	# tmux ids for the nvim client pane
	readarray -d ' ' -t ids < <(tmux list-panes -a -f "#{==:#{pane_pid},$pane_pid}" -F "#{window_index} #{window_name} #{pane_index} #{session_name}")
	window_index=${ids[0]}
	window_name=${ids[1]}
	pane_index=${ids[2]}
	session_name=${ids[3]}

	if [ $CURRENT_SESSION_NAME != $session_name ]; then
		continue
	else
		c1="nvim --server $sock --remote-send \"<esc>$OPEN_STRATEGY $FILE<cr>\""
		c2="nvim --server $sock --remote-send \"<esc>:call cursor($LINE, $COLUMN)<cr>\""
		c3="tmux selectw -t $window_index && tmux selectp -t $pane_index"
		remote_open="$c1 && $c2 && $c3"
		if [[ $SOCK_COUNT == 1 || ($window_index == "$CURRENT_WINDOW_INDEX" && $PRIORITIZE_WINDOW == true) ]]; then
			# we found the only nvim, or found the first one in our window when prioritizing current window
			eval "$remote_open"
			exit 0
		else
			# store this nvim instance for selection
			MENU_ARGS+=("[$session_name $window_index $window_name]: pane $pane_index" "$SOCK_INDEX" "run '$remote_open'")
		fi
		SOCK_INDEX=$((SOCK_INDEX + 1))
	fi
done

if [[ ${MENU_ARGS[0]} ]]; then
	# open menu for selection
	echo "$tmux_menu_s $tmux_menu_H"
	# shellcheck disable=SC2086
	tmux display-menu $tmux_menu_s $tmux_menu_H -T "tmux-open-nvim: $FILE" "${MENU_ARGS[@]}"
else
	# No remote nvim, so just open in current pane
	tmux send-keys "nvim -c \"call cursor($LINE, $COLUMN)\" $FILE"
	tmux send-keys "C-m"
fi
