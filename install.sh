#! /bin/bash

echo '# Creating directories'

[ ! -d ~/bin ] && mkdir ~/bin
[ ! -d ~/tmp ] && mkdir ~/tmp
[ ! -d ~/dev/tools ] && mkdir -p ~/dev/tools
[ ! -d ~/Images ] && mkdir Images

echo ''
echo '# Installing packages'

sudo apt install curl
if [ ! -f  /etc/apt/sources.list.d/spotify.list ] ; then
    curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
fi

sudo apt update
sudo apt install rxvt-unicode openbox openbox-gnome-session openbox-menu obconf neovim feh xcompmgr tig tdc cbatticon spotify-client stalonetray global universal-ctags blueman scrot most graphicsmagick silversearcher-ag xbacklight gnome-screensaver gimp jq wmctrl dunst

echo ''
echo '# Installing Inconsolata Nerd Font'

if [ ! -d ~/.fonts ] ; then
    mkdir ~/.fonts
    cd ~/.fonts
    wget 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Inconsolata/complete/Inconsolata%20Regular%20Nerd%20Font%20Complete%20Mono.ttf'
    wget 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Inconsolata/complete/Inconsolata%20Bold%20Nerd%20Font%20Complete%20Mono.ttf'
    cd -
fi

echo ''
echo '# Installing URxvt plugins'

[ ! -d ~/dev/tools/urxvt-tabbedex ] && git clone git@github.com:mina86/urxvt-tabbedex.git ~/dev/tools/urxvt-tabbedex
[ ! -d ~/dev/tools/urxvt-resize-font ] && git clone git@github.com:simmel/urxvt-resize-font.git ~/dev/tools/urxvt-resize-font

if [ ! -d ~/.urxvt ] ; then
    mkdir ~/.urxvt
    cd ~/.urxvt
    ln -s ~/dev/tools/urxvt-tabbedex/tabbedex
    ln -s ~/dev/tools/urxvt-resize-font/resize-font
    cd -
fi

echo ''
echo '# Installing oh my bash'

[ ! -d ~/.oh-my-bash ] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

echo ''
echo '# Configuring bash, URxvt, ...'
echo "(existing configurations, if any, are renamed with suffix .$$)"

CONFIG_DIR=`dirname $BASH_SOURCE[0]`
[ ! -L ~/.bashrc ] && ln -b -r --suffix=".$$" -s $CONFIG_DIR/.bashrc ~
[ ! -L ~/.Xdefaults ] && ln -b -r --suffix=".$$" -s $CONFIG_DIR/.Xdefaults ~
[ ! -L ~/.Xmodmap ] && ln -b -r --suffix=".$$" -s $CONFIG_DIR/.Xmodmap ~
[ ! -L ~/.gtkrc-2.0 ] && ln -b -r --suffix=".$$" -s $CONFIG_DIR/.gtkrc-2.0 ~
[ ! -L ~/.gtkrc-2.0.mine ] && ln -b -r --suffix=".$$" -s $CONFIG_DIR/.gtkrc-2.0.mine ~

[ ! -d ~/.themes ] && mkdir ~/.themes
[ -d ~/.themes/DpNightmare ] && mv ~/.themes/DpNightmare ~/.themes/DpNightmare.$$
[ ! -L ~/.themes/DpNightmare ] && ln -r -s $CONFIG_DIR/.themes/DpNightmare ~/.themes/


[ ! -d ~/.config ] && mkdir ~/.config

[ -d ~/.config/dunst ] && mv ~/.config/dunst ~/.config/dunst.$$
[ ! -L ~/.config/dunst ] && ln -r -s $CONFIG_DIR/.config/dunst ~/.config/

[ -d ~/.config/openbox ] && mv ~/.config/openbox ~/.config/openbox.$$
[ ! -L ~/.config/openbox ] && ln -r -s $CONFIG_DIR/.config/openbox ~/.config/

[ -d ~/.config/gtk-3.0 ] && mv ~/.config/gtk-3.0 ~/.config/gtk-3.0.$$
[ ! -L ~/.config/gtk-3.0 ] && ln -r -s $CONFIG_DIR/.config/gtk-3.0 ~/.config/

[ -d ~/.config/gtk-4.0 ] && mv ~/.config/gtk-4.0 ~/.config/gtk-4.0.$$
[ ! -L ~/.config/gtk-4.0 ] && ln -r -s $CONFIG_DIR/.config/gtk-4.0 ~/.config/

git config --global core.excludesfile "$CONFIG_DIR/.config/gitignore_global"

echo ''
echo '# Configuring URxvt as the default terminal emulator'

sudo update-alternatives --set x-terminal-emulator /usr/bin/urxvt

echo ''
echo '# Configuring neovim'
if [ ! -d ~/.config/nvim/autoload ] ; then
    mkdir -p ~/.config/nvim/autoload
    [ ! -L ~/.config/nvim/init.vim ] && ln -b -r --suffix=".$$" -s $CONFIG_DIR/.config/nvim/init.vim ~/.config/nvim/
    [ -d ~/.config/nvim/after ] && mv ~/.config/nvim/after ~/.config/nvim/after.$$
    [ ! -L ~/.config/nvim/after ] && ln -r -s $CONFIG_DIR/.config/nvim/after ~/.config/nvim/
    [ -d ~/.config/nvim/pdv_templates ] && mv ~/.config/nvim/pdv_templates ~/.config/nvim/pdv_templates.$$
    [ ! -L ~/.config/nvim/pdv_templates ] && ln -r -s $CONFIG_DIR/.config/nvim/pdv_templates ~/.config/nvim/
    wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -O ~/.config/nvim/autoload/plug.vim
    nvim -c 'PlugInstall' -c 'qa!' --headless
fi

echo ''
echo '# Configuring background'
if [ ! -f ~/Images/background.jpg ] ; then
    wget https://unsplash.com/photos/jFCViYFYcus/download?force=true -O ~/Images/background.jpg
    feh --bg-fill ~/Images/background.jpg
fi

echo ''
echo '# Installing nvm'
[ ! -d ~/.nvm ] && wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

echo ''
echo '# Installing custom scripts in ~/bin'
[ ! -L ~/bin/xprofile ] && ln -r -s --suffix=".$$" -s $CONFIG_DIR/bin/xprofile ~/bin/xprofile
[ ! -L ~/bin/one-spotify ] && ln -r -s --suffix=".$$" -s $CONFIG_DIR/bin/one-spotify ~/bin/one-spotify

exit 0
