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
fi

# Remove default Ubuntu Neovim
echo "Y\n" | sudo apt-get --purge remove neovim

sleep 1

# Install Homebrew packages
brew install fzf \
  zsh \
  powerlevel10k \
  zsh-syntax-highlighting \
  fd \
  ripgrep \
  tmux \
  neovim-remote \
  neovim \
  delta \
  zoxide \
  joshmedeski/sesh/sesh \
  gnu-sed \
  luarocks \
  imagemagick \
  bottom \
  lazygit \
  nvm

sleep 1

# Change default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Changing default shell to zsh..."
  source /etc/zsh/zshenv
  sudo chsh -s "$(which zsh)" ubuntu
  zsh
fi

sleep 1

# Install Oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

sleep 1

# Install LazyVim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

sleep 1

# Add symlinks
ln -svf ~/dotfiles/.zshrc ~/.zshrc
ln -svf ~/dotfiles/.config/lazygit ~/.config/lazygit
ln -svf ~/dotfiles/.config/nvim/lazyvim.json ~/.config/nvim/lazyvim.json
ln -svf ~/dotfiles/.config/scripts ~/.config/scripts
ln -svf ~/dotfiles/.config/nvim/lua/config ~/.config/nvim/lua/config
ln -svf ~/dotfiles/.config/nvim/lua/plugins ~/.config/nvim/lua/plugins
ln -svf ~/dotfiles/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -svf ~/dotfiles/.p10k.zsh ~/.p10k.zsh

sleep 1

# Source Zshrc
source ~/.zshrc

sleep 1

# Install LazyVim packages
nvim --headless "+Lazy! sync" +qa

sleep 1

# Install Tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux start-server
tmux new-session -d
sleep 1
eval "$(~/.tmux/plugins/tpm/scripts/install_plugins.sh)"
tmux kill-server
