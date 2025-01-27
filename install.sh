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
    curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
fi

if [ ! -f  /etc/apt/sources.list.d/signal-xenial.list ] ; then
    wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
    cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
fi

if [ ! -f  /etc/apt/sources.list.d/azlux.list ] ; then
    # gping
    echo "deb http://packages.azlux.fr/debian/ stable main" | sudo tee /etc/apt/sources.list.d/azlux.list
    curl -sS https://azlux.fr/repo.gpg.key | sudo apt-key add -
fi

sudo apt update
sudo apt install kitty openbox openbox-gnome-session obconf neovim feh compton tig cbatticon spotify-client stalonetray global universal-ctags blueman scrot most graphicsmagick silversearcher-ag gnome-screensaver gimp jq wmctrl dunst libbluetooth-dev build-essential lm-sensors tmux bwm-ng gping acpi bat xclip signal-desktop suckless-tools xsel htop unzip obsession flameshot libbluetooth-dev make build-essential

echo ''
echo '# Installing Inconsolata Nerd Font'

if [ ! -d ~/.local/share/fonts ] ; then
    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts
    wget 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Inconsolata.zip' -O /tmp/Inconsolata.zip
    unzip /tmp/Inconsolata.zip
    cd -
fi

echo ''
echo '# Installing oh my bash'

[ ! -d ~/.oh-my-bash ] && bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

echo ''
echo '# Configuring bash, keyboard, …'
echo "(existing configurations, if any, are renamed with suffix .$$)"

CONFIG_DIR=`dirname $BASH_SOURCE[0]`
[ ! -L ~/.bashrc ] && ln -b -r --suffix=".$$" -s $CONFIG_DIR/.bashrc ~
[ ! -L ~/.gitconfig ] && ln -b -r --suffix=".$$" -s $CONFIG_DIR/.gitconfig ~
[ ! -L ~/.Xmodmap ] && ln -b -r --suffix=".$$" -s $CONFIG_DIR/.Xmodmap ~
[ ! -L ~/.gtkrc-2.0 ] && ln -b -r --suffix=".$$" -s $CONFIG_DIR/.gtkrc-2.0 ~
[ ! -L ~/.gtkrc-2.0.mine ] && ln -b -r --suffix=".$$" -s $CONFIG_DIR/.gtkrc-2.0.mine ~

[ ! -d ~/.themes ] && mkdir ~/.themes
[ ! -L ~/.themes/DpNightmare ] && mv ~/.themes/DpNightmare ~/.themes/DpNightmare.$$ 2> /dev/null ; ln -r -s $CONFIG_DIR/.themes/DpNightmare ~/.themes/

[ ! -d ~/.config ] && mkdir ~/.config

[ ! -L ~/.config/kitty ] && mv ~/.config/kitty ~/.config/kitty.$$ 2> /dev/null ; ln -r -s $CONFIG_DIR/.config/kitty ~/.config/
[ ! -L ~/.config/dunst ] && mv ~/.config/dunst ~/.config/dunst.$$ 2> /dev/null ; ln -r -s $CONFIG_DIR/.config/dunst ~/.config/
[ ! -L ~/.config/openbox ] && mv ~/.config/openbox ~/.config/openbox.$$ 2> /dev/null ; ln -r -s $CONFIG_DIR/.config/openbox ~/.config/
[ ! -L ~/.config/gtk-3.0 ] && mv ~/.config/gtk-3.0 ~/.config/gtk-3.0.$$ 2> /dev/null ; ln -r -s $CONFIG_DIR/.config/gtk-3.0 ~/.config/
[ ! -L ~/.config/gtk-4.0 ] && mv ~/.config/gtk-4.0 ~/.config/gtk-4.0.$$ 2> /dev/null ; ln -r -s $CONFIG_DIR/.config/gtk-4.0 ~/.config/

[ ! -L ~/.config/gitignore_global ] && ln -b -r --suffix=".$$" -s $CONFIG_DIR/.config/gitignore_global ~/.config/gitignore_global
git config --global core.excludesfile '~/.config/gitignore_global'

echo ''
echo '# Installing icons'

[ ! -d ~/.local ] && mkdir ~/.local
[ ! -L ~/.local/icons ] && mv ~/.local/icons ~/.local/icons.$$ 2> /dev/null ; ln -r -s $CONFIG_DIR/.local/icons ~/.local/

echo ''
echo '# Configuring Kitty as the default terminal emulator'

sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty

echo ''
echo '# Configuring neovim'
if [ ! -d ~/.config/nvim/autoload ] ; then
    mkdir -p ~/.config/nvim/autoload
    [ ! -L ~/.config/nvim/init.vim ] && ln -b -r --suffix=".$$" -s $CONFIG_DIR/.config/nvim/init.vim ~/.config/nvim/
    [ ! -L ~/.config/nvim/after ] && mv ~/.config/nvim/after ~/.config/nvim/after.$$ ; ln -r -s $CONFIG_DIR/.config/nvim/after ~/.config/nvim/
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
[ ! -d ~/.nvm ] && wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash


echo ''
echo '# Installing based-connect'
[ ! -d ~/dev/tools/based-connect ] && git clone git@github.com:Denton-L/based-connect.git ~/dev/tools/based-connect
cd ~/dev/tools/based-connect
make
cd -

echo ''
echo '# Installing xseticon'
[ ! -d ~/dev/tools/xseticon ] && git clone git@github.com:xeyownt/xseticon.git ~/dev/tools/xseticon
cd ~/dev/tools/xseticon
sudo apt install libxmu-headers libgd-dev libxmu-dev libglib2.0-dev
make
cd -

echo ''
echo '# Installing custom scripts in ~/bin'
[ ! -L ~/bin/based-connect ] && ln -r -s --suffix=".$$" ~/dev/tools/based-connect/based-connect ~/bin/based-connect
[ ! -L ~/bin/xseticon ] && ln -r -s --suffix=".$$" ~/dev/tools/xseticon/xseticon ~/bin/xseticon
[ ! -L ~/bin/xprofile ] && ln -r -s --suffix=".$$" -s $CONFIG_DIR/bin/xprofile ~/bin/xprofile
[ ! -L ~/bin/compositor ] && ln -r -s --suffix=".$$" -s $CONFIG_DIR/bin/compositor ~/bin/compositor
[ ! -L ~/bin/brightness ] && ln -r -s --suffix=".$$" -s $CONFIG_DIR/bin/brightness ~/bin/brightness
[ ! -L ~/bin/one-monitoring ] && ln -r -s --suffix=".$$" -s $CONFIG_DIR/bin/one-monitoring ~/bin/one-monitoring
[ ! -L ~/bin/one-slack ] && ln -r -s --suffix=".$$" -s $CONFIG_DIR/bin/one-slack ~/bin/one-slack
[ ! -L ~/bin/one-signal ] && ln -r -s --suffix=".$$" -s $CONFIG_DIR/bin/one-signal ~/bin/one-signal
[ ! -L ~/bin/notify-info ] && ln -r -s --suffix=".$$" $CONFIG_DIR/bin/notify-info ~/bin/notify-info
[ ! -L ~/bin/one-spotify ] && ln -r -s --suffix=".$$" -s $CONFIG_DIR/bin/one-spotify ~/bin/one-spotify
[ ! -L ~/bin/_receive-spotify-notification ] && ln -r -s --suffix=".$$" -s $CONFIG_DIR/bin/_receive-spotify-notification ~/bin/_receive-spotify-notification
[ ! -L ~/bin/_run-zoom ] && ln -r -s --suffix=".$$" -s $CONFIG_DIR/bin/_run-zoom ~/bin/_run-zoom
[ ! -L ~/bin/_open-notification-url ] && ln -r -s --suffix=".$$" -s $CONFIG_DIR/bin/_open-notification-url ~/bin/_open-notification-url

exit 0
