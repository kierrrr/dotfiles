#!/bin/bash

cd ~/dotfiles && git reset --hard && git clean -fd && cd -

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
brew_install() { if brew ls --versions "$1"; then true; else brew install "$1"; fi; }

echo "Installing Homebrew packages"
brew_install zsh
brew_install powerlevel10k
brew_install zsh-syntax-highlighting
brew_install tmux
brew_install neovim
brew_install fzf
brew_install fd
brew_install ripgrep
brew_install delta
brew_install sesh
brew_install gnu-sed
brew_install luarocks
brew_install imagemagick
brew_install btop
brew_install lazygit
brew_install nvm
brew_install zoxide
brew_install neovim-remote
brew_install tree-sitter-cli
brew_install television
brew_install bat
brew tap oven-sh/bun && brew_install bun
echo "Finished installing Homebrew packages"

sleep 1

if [[ "$(uname)" == "Linux" ]]; then
  echo "Reinstalling curl"
  brew uninstall --ignore-dependencies curl
  sleep 1
  sudo apt-get install curl
  sleep 1
fi

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

# Install JMUX
bun install -g @jx0/jmux

echo "Copying config files..."
# Copy zshrc config
cp -fL ~/dotfiles/.zshrc ~/.zshrc
# Copy Lazygit config
rm -rf ~/.config/lazygit && mkdir -p ~/.config && cp -RL ~/dotfiles/.config/lazygit ~/.config/lazygit
# Copy custom scripts
rm -rf ~/.config/scripts && mkdir -p ~/.config && cp -RL ~/dotfiles/.config/scripts ~/.config/scripts
# Copy NVIM config
mkdir -p ~/.config/nvim
rm -rf ~/.config/nvim/lua/config && mkdir -p ~/.config/nvim/lua && cp -RL ~/dotfiles/.config/nvim/lua/config ~/.config/nvim/lua/config
rm -rf ~/.config/nvim/lua/plugins && mkdir -p ~/.config/nvim/lua && cp -RL ~/dotfiles/.config/nvim/lua/plugins ~/.config/nvim/lua/plugins
# Copy Television config
rm -rf ~/.config/television/cable && mkdir -p ~/.config/television/cable && cp -RL ~/dotfiles/.config/television/cable ~/.config/television/cable
cp -fL ~/dotfiles/.config/television/config.toml ~/.config/television/config.toml
# Copy TMUX Config
cp -fL ~/dotfiles/.tmux.conf ~/.tmux.conf
# Copy powerlevel10k config
cp -fL ~/dotfiles/.p10k.zsh ~/.p10k.zsh
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

# Set nvim as the default editor for git
git config --global core.editor "nvim"

# Update rovodev config to add on_complete event hook
ROVODEV_CONFIG="$HOME/.rovodev/config.yml"
if [ -f "$ROVODEV_CONFIG" ]; then
  echo "Updating rovodev event hooks config..."
  if grep -q "^eventHooks:" "$ROVODEV_CONFIG" && grep -q "  events: \[\]" "$ROVODEV_CONFIG"; then
    sed -i.bak '/^eventHooks:/,/^[^ ]/ s/  events: \[\]/  events:\n  - name: on_complete\n    commands:\n    - command: tmux set-option @jmux-attention 1 2>\/dev\/null || true/' "$ROVODEV_CONFIG"
    rm -f "${ROVODEV_CONFIG}.bak"
    echo "rovodev config updated successfully."
  else
    echo "rovodev config already updated or does not match expected format. Skipping."
  fi
fi

cd ~/dotfiles && git reset --hard && git clean -fd && cd -
