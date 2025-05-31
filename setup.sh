#!/bin/bash

# Install Homebrew
if ! command -v brew &>/dev/null; then
  echo "Homebrew not found. Installing..."

  git clone https://github.com/Homebrew/brew ~/homebrew

  eval "$(~/homebrew/bin/brew shellenv)"
  brew update --force --quiet
  chmod -R go-w "$(brew --prefix)/share/zsh"

  sleep 1

  echo 'eval "$(~/homebrew/bin/brew shellenv)"' >>~/.zprofile
  echo 'export PATH="$PATH:/homebrew/bin"' >>~/.zprofile

  # echo 'export HOMEBREW_PREFIX=~/usr/local' >>~/.zprofile
  # echo “export PATH=$PATH:~/homebrew/bin:HOMEBREW_PREFIX/bin” >>~/.zprofile
  echo "Finished Installing Homebrew"
fi

# Remove default Ubuntu Neovim
echo "Y\n" | sudo apt-get --purge remove neovim

sleep 10

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
brew_install joshmedeski/sesh/sesh
brew_install gnu-sed
brew_install luarocks
brew_install imagemagick
brew_install bottom
brew_install lazygit
brew_install nvm
brew_install zoxide
brew_install neovim-remote

echo "Finished installing Homebrew packages"

sleep 10

# Change default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Changing default shell to zsh..."
  source /etc/zsh/zshenv
  sudo chsh -s "$(which zsh)" ubuntu
  zsh
fi

sleep 10

# Install Oh my zsh
echo "Installing Oh my zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

sleep 10

# Install LazyVim
echo "Installing LazyVim..."
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

sleep 10

# Add symlinks
echo "Copying config files..."
cp -rf ~/dotfiles/.zshrc ~/.zshrc
cp -rf ~/dotfiles/.config/lazygit ~/.config/lazygit
cp -rf ~/dotfiles/.config/nvim/lazyvim.json ~/.config/nvim/lazyvim.json
cp -rf ~/dotfiles/.config/scripts ~/.config/scripts
cp -rf ~/dotfiles/.config/nvim/lua/config ~/.config/nvim/lua/config
cp -rf ~/dotfiles/.config/nvim/lua/plugins ~/.config/nvim/lua/plugins
mkdir -p ~/.config/tmux && cp -rf ~/dotfiles/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf
cp -rf ~/dotfiles/.p10k.zsh ~/.p10k.zsh

sleep 10

# Source Zshrc
source ~/.zshrc

sleep 10

# Install LazyVim packages
nvim --headless "+Lazy! sync" +qa

sleep 10

# Install Tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux start-server
tmux new-session -d
sleep 10
eval "$(~/.tmux/plugins/tpm/scripts/install_plugins.sh)"
tmux kill-server
