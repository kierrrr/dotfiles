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

sleep 1

# Install Oh my zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

sleep 1

# Install LazyVim
if [ ! -d "$HOME/.config/nvim" ]; then
  echo "Installing LazyVim..."
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git
fi

sleep 1

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
ln -svf ~/dotfiles/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -svf ~/dotfiles/.p10k.zsh ~/.p10k.zsh
echo "Finished copying files..."

sleep 1

# Install LazyVim packages
nvim --headless "+Lazy! sync" +qa

sleep 1

# Install Tmux plugin manager
if [ ! -d ~/.tmux/plugins/tpm ]; then
  echo "$DIRECTORY does not exist."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
tmux start-server
tmux new-session -d
sleep 1
eval "$(~/.tmux/plugins/tpm/scripts/install_plugins.sh)"
tmux kill-server

sleep 1

# Change default shell to zsh. This should be last step.
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Changing default shell to zsh..."
  source /etc/zsh/zshenv
  sudo chsh -s "$(which zsh)" ubuntu
  zsh
fi
