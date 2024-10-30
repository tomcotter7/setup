#!/bin/bash

HOME=/home/$1
echo "Setting up user $HOME"

# -- should be run as root --

# -- install neovim --
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
mv squashfs-root /
ln -s /squashfs-root/AppRun /usr/local/bin/nvim
rm nvim.appimage

# -- install ripgrep --
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
dpkg -i ripgrep_14.1.0-1_amd64.deb
rm ripgrep_14.1.0-1_amd64.deb

# -- install luarocks --
wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
tar zxpf luarocks-3.11.1.tar.gz
cd luarocks-3.11.1 && ./configure && make && make install
luarocks install luasocket
rm -rf luarocks-3.11.1.tar.gz luarocks-3.11.1

sudo -u $1 bash << 'EOF'

# -- install nerdfont --
mkdir -p $HOME/.local/share/fonts
wget -P $HOME/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Agave.zip
unzip $HOME/.local/share/fonts/Agave.zip -d $HOME/.local/share/fonts
rm $HOME/.local/share/fonts/Agave.zip
fc-cache -f -v

# -- install neovim plugins --
mkdir -p $HOME/.config/
git clone https://github.com/tomcotter7/nvim-config.git
mv nvim-config $HOME/.config/nvim

# -- setup dotfiles --
git clone https://github.com/tomcotter7/dotfiles.git
mv dotfiles $HOME/dotfiles
ln -s $HOME/dotfiles/.bash_aliases $HOME/.bash_aliases
ln -s $HOME/dotfiles/.tmux.conf $HOME/.tmux.conf
ln -s $HOME/dotfiles/.bashrc $HOME/.bashrc
touch $HOME/.secrets
touch $HOME/.bashrc.local

EOF
