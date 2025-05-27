1. Ubuntu only - Set permissions as Homebrew needs access to it
`mkdir /home/linuxbrew`
`sudo chown -R $USER /home`
`sudo chown -R $USER /home/linuxbrew`
`sudo chown -R $USER /usr/local`

2. Ubuntu only - Remove built in Neovim version on Ubuntu
`sudo apt-get --purge remove neovim`

3. Install Homebrew and follow next steps on the cmd output
`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

4. Install Homebrew packages on `brew.sh`

5. Install oh-my-zsh
`sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

6. Install LazyVim
`git clone https://github.com/LazyVim/starter ~/.config/nvim`
`rm -rf ~/.config/nvim/.git`

7. Add symlinks from `symlinks.sh`

8. Source zsh config
`source .zshrc`

9. Install Tmux Plugin Manager
`git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
  a. Install Tmux Plugins with `cmd+space+shift+i`
