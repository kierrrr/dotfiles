#!/bin/bash

# Install Homebrew
if ! command -v brew &>/dev/null; then
  echo "Homebrew not found. Installing..."

  if [ ! -d "$HOME/homebrew" ]; then
    echo "Cloning Homebrew..."
    git clone https://github.com/Homebrew/brew ~/homebrew
  fi

  eval "$(~/homebrew/bin/brew shellenv)"
  brew update --force --quiet
  chmod -R go-w "$(brew --prefix)/share/zsh"

  sleep 1

  # Add eval "$(~/homebrew/bin/brew shellenv)" to .zprofile if it doesn't exist in the file
  grep -qxF 'eval "$(~/homebrew/bin/brew shellenv)"' ~/.zprofile || echo 'eval "$(~/homebrew/bin/brew shellenv)"' >>~/.zprofile

  # Add eval "export PATH="$PATH:/homebrew/bin"" to .zprofile if it doesn't exist in the file
  grep -qxF 'export PATH="$PATH:/homebrew/bin"' ~/.zprofile || echo 'export PATH="$PATH:/homebrew/bin"' >>~/.zprofile

  echo "Finished installing Homebrew"
fi

# Remove default Ubuntu Neovim
echo "Y\n" | sudo apt-get --purge remove neovim

sleep 1

# Install Homebrew packages if they are not yet installed
brew_install() { if brew ls --versions "$1" >/dev/null; then :; else brew install --ignore-dependencies "$1"; fi; }

pkgs=(
  zsh
  powerlevel10k
  zsh-syntax-highlighting
  tmux
  neovim
  fzf
  fd
  ripgrep
  delta
  joshmedeski/sesh/sesh
  gnu-sed
  luarocks
  imagemagick
  btop
  lazygit
  nvm
  zoxide
  neovim-remote
  rust
  rustup
)

mapfile -t deps < <(brew deps --union "${pkgs[@]}" | grep -vx curl || true)

declare -A seen=()
all=()
for p in "${pkgs[@]}" "${deps[@]}"; do
  [[ -n "${p}" && -z "${seen[$p]:-}" ]] && all+=("$p") && seen["$p"]=1
done

echo "Will install:"
printf '  %s\n' "${all[@]}"

for p in "${all[@]}"; do
  brew_install "$p"
done

sleep 1

# Install Rust nightly
rustup toolchain install nightly

sleep 1

# Install Oh my zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  sleep 1
fi

# Install LazyVim
if [ ! -d "$HOME/.config/nvim" ]; then
  echo "Installing LazyVim..."
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git
  sleep 1
fi

# Add symlinks
echo "Copying config files..."
ln -svf ~/dotfiles/.zshrc ~/.zshrc
ln -svf ~/dotfiles/.config/lazygit ~/.config/lazygit
ln -svf ~/dotfiles/.config/nvim/lazyvim.json ~/.config/nvim/lazyvim.json
ln -svf ~/dotfiles/.config/scripts ~/.config/scripts
rm -rf ~/.config/nvim/lua/config
ln -svf ~/dotfiles/.config/nvim/lua/config ~/.config/nvim/lua/config
rm -rf ~/.config/nvim/lua/plugins
ln -svf ~/dotfiles/.config/nvim/lua/plugins ~/.config/nvim/lua/plugins
mkdir ~/.config/tmux/
ln -svf ~/dotfiles/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -svf ~/dotfiles/.p10k.zsh ~/.p10k.zsh
echo "Finished copying files..."

sleep 1

# Install LazyVim packages
if [ ! -d ~/.local/share/nvim/lazy ]; then
  echo "Installing LazyVim packages..."
  nvim --headless "+Lazy! sync" +qa
  sleep 1
fi

# Install Tmux plugin manager
if [ ! -d ~/.tmux/plugins/tpm ]; then
  echo "Installing Tmux Plugin Manager..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  sleep 1
fi

if [ ! -d ~/.config/tmux/plugins/tpm ]; then
  echo "Installing TPM Plugins"
  tmux start-server
  tmux new-session -d
  sleep 1
  eval "$(~/.tmux/plugins/tpm/scripts/install_plugins.sh)"
  tmux kill-server
  sleep 1
fi

# Change default shell to zsh. This should be last step.
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Changing default shell to zsh..."
  source /etc/zsh/zshenv
  sudo chsh -s "$(which zsh)" ubuntu
  zsh
fi
