RUN tmux start-server &&
  tmux new-session -d &&
  sleep 1 &&
  ~/.tmux/plugins/tpm/scripts/install_plugins.sh &&
  tmux kill-server
