#!/bin/bash
set -Eeo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

git -C "$DOTFILES_DIR" reset --hard
git -C "$DOTFILES_DIR" clean -fd

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

  echo "Finished installing Homebrew"
fi

# Remove distro-provided Neovim on Debian-based systems
if command -v apt-get &>/dev/null; then
  sudo apt-get --purge remove -y neovim
fi

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
brew_install gnu-sed
brew_install luarocks
brew_install imagemagick
brew_install btop
brew_install lazygit
brew_install nvm
brew_install zoxide
brew_install neovim-remote
brew_install television
brew_install jarredkenny/tap/jmux
brew_install hunk

echo "Finished installing Homebrew packages"

sleep 1

# Install terminal-browser
curl -fsSl https://terminal-browser.sh/install | bash

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

echo "Copying config files..."
# Copy zshrc config
cp -fL "$DOTFILES_DIR/.zshrc" ~/.zshrc
# Copy Lazygit config
rm -rf ~/.config/lazygit && mkdir -p ~/.config && cp -RL "$DOTFILES_DIR/.config/lazygit" ~/.config/lazygit
# Copy custom scripts
rm -rf ~/.config/scripts && mkdir -p ~/.config && cp -RL "$DOTFILES_DIR/.config/scripts" ~/.config/scripts
# Copy NVIM config
mkdir -p ~/.config/nvim
rm -rf ~/.config/nvim/lua/config && mkdir -p ~/.config/nvim/lua && cp -RL "$DOTFILES_DIR/.config/nvim/lua/config" ~/.config/nvim/lua/config
rm -rf ~/.config/nvim/lua/plugins && mkdir -p ~/.config/nvim/lua && cp -RL "$DOTFILES_DIR/.config/nvim/lua/plugins" ~/.config/nvim/lua/plugins
# Copy Television config
rm -rf ~/.config/television/cable && mkdir -p ~/.config/television/cable && cp -RL "$DOTFILES_DIR/.config/television/cable" ~/.config/television/cable
cp -fL "$DOTFILES_DIR/.config/television/config.toml" ~/.config/television/config.toml
# Copy TMUX Config
cp -fL "$DOTFILES_DIR/.tmux.conf" ~/.tmux.conf
# Copy p10k config
cp -fL "$DOTFILES_DIR/.p10k.zsh" ~/.p10k.zsh
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
fi

echo "Installing Tmux plugins..."
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

# Set nvim as the default editor for git
git config --global core.editor "nvim"

# Change default shell to zsh. This should be last step.
if [ "$SHELL" != "$(command -v zsh)" ]; then
  echo "Changing default shell to zsh..."
  chsh -s "$(command -v zsh)"
fi

git -C "$DOTFILES_DIR" reset --hard
git -C "$DOTFILES_DIR" clean -fd
