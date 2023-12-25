# Latest update + upgrade
sudo apt update -y
sudo apt upgrade -y
sudo apt install git curl wget -y

# ===========================
# Install zsh
sudo apt install zsh -y
chsh -s $(which zsh)

# ===========================
# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
echo "plugins+=(zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)" >> ~/.zshrc
# Fix
# > compaudit
# > sudo chown -R  username:root target_directory
# > sudo chmod -R 755 target_directory

# ===========================
# Install fonts
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
font_urls=(
  "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DejaVuSansMono/Regular/DejaVuSansMNerdFont-Regular.ttf"
  "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DejaVuSansMono/Regular/DejaVuSansMNerdFontMono-Regular.ttf"
  "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DejaVuSansMono/Regular/DejaVuSansMNerdFontPropo-Regular.ttf"
)
for url in "${font_urls[@]}"; do
  curl -fLO "$url"
done
cd

# ===========================
# Install powerlever10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i '/ZSH_THEME="/d' ~/.zshrc
echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
source ~/.zshrc

# ===========================
# Install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
echo '. "$HOME/.asdf/asdf.sh"' >> ~/.zshrc
source ~/.zshrc

# ===========================
# Install neovim
sudo apt install neovim -y
sudo apt install lua5.4 -y
asdf plugin add nodejs
asdf install nodejs latest
asdf global nodejs latest

# ===========================
# Install tmux
sudo apt install tmux -y

# ===========================
# Install fzf
sudo apt-get install silversearcher-ag -y
sudo apt-get install ripgrep -y
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# ===========================
# Install IDE
cd
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
git clone https://github.com/msaio/cfg_nvim
ln -s -f ~/cfg_nvim ~/.config/nvim
nvim +PlugInstall +qall
nvim +CocInstall\ coc-prettier\ coc-html\ coc-yaml\ coc-xml\ coc-tsserver\ coc-sql\ coc-solargraph\ coc-sh\ coc-lua\ coc-go\ coc-json +qall

cd
git clone https://github.com/msaio/cfg_zsh
echo 'source "$HOME/cfg_zsh/init.sh"' >> ~/.zshrc
# ln -s -f ~/.zshrc ~/cfg_zsh/.zshrc
ln -f ~/.zshrc ~/cfg_zsh/.zshrc

cd ~
rm -rf .tmux .tmux.conf .tmux.conf.local
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .
mv ~/.tmux.conf.local ~/.tmux.conf.local.bk
ln ~/cfg_zsh/tmux.conf ~/.tmux.conf.local

# ===========================
# install backup kde theme
sudo apt install python3 python-is-python3 pip pipx -y
pipx install konsave
tee -a ~/.zshrc  <<EOF
if [ -d "\$HOME/.local/bin" ]; then
	PATH="\$HOME/.local/bin:\$PATH"
fi
EOF

# ===========================
# Massive zsh history
tee -a ~/.zshrc <<EOF
HISTFILE=~/.zsh_history
HISTSIZE=999999999
SAVEHIST=\$HISTSIZE
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
EOF

# ===========================
# Install flatpak
sudo apt install flatpak -y
echo '\nexport XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"' >> ~/.zshrc
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub

# ===========================
# Install docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo apt install docker-desktop
systemctl --user start docker-desktop
gpg --generate-key
pass init <key>

# ===========================
# Install snap and add snap apps to desktop (zsh)
sudo apt install snap snapd -y
sudo echo "emulate sh -c 'source /etc/profile'" >> /etc/zsh/zprofile

# ===========================
# Install asusctl
# https://gitlab.com/asus-linux/asusctl
git clone https://gitlab.com/asus-linux/asusctl.git ~/asusctl
sudo apt install libgtk-3-dev libpango1.0-dev libgdk-pixbuf-2.0-dev libglib2.0-dev cmake libclang-dev libudev-dev libayatana-appindicator3-1 -y
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
cd ~/asusctl
make
sudo make install
systemctl restart asusd

# ===========================
# Install go
curl -fsSLo- https://s.id/golang-linux | zsh
echo "" >> ~/.zshrc
tee -a ~/.zshrc  <<EOF
export GOROOT="\$HOME/go"
export GOPATH="\$HOME/go/packages"
export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin
EOF

# ===========================
# Install ibus-unikey (works perfect with x11)
sudo apt install ibus-unikey -y
sudo tee -a /etc/environment <<EOF

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
EOF

# ===========================
# Install fcitx5 (work perfect with wayland, ibus in wayland suck) 
# https://fcitx-im.org/wiki/Install_Fcitx_5
sudo apt install fcitx5 fcitx5-unikey -y
sudo tee -a /etc/environment <<EOF

INPUT_METHOD=fcitx5
GTK_IM_MODULE=fcitx5
QT_IM_MODULE=fcitx5
XMODIFIERS=@im=fcitx5
EOF
# Settings -> Virtual Keyboard -> Fcitx5 -> Apply

# ===========================
# Enable hibernate
# https://askubuntu.com/a/1316444/1745859
UUID=$(sudo swapon --show=NAME,UUID | awk 'NR==2 {print $2}')
replacement_string="GRUB_CMDLINE_LINUX_DEFAULT=\"resume=UUID=$UUID\""
sudo sed -i "/GRUB_CMDLINE_LINUX_DEFAULT/c\\$replacement_string" /etc/default/grub
sudo update-grub
sudo cat << "EOF" > /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla
[Re-enable hibernate by default in upower]
Identity=unix-user:*
Action=org.freedesktop.upower.hibernate
ResultActive=yes

[Re-enable hibernate by default in logind]
Identity=unix-user:*
Action=org.freedesktop.login1.hibernate;org.freedesktop.login1.handle-hibernate-key;org.freedesktop.login1;org.freedesktop.login1.hibernate-multiple-sessions;org.freedesktop.login1.hibernate-ignore-inhibit
ResultActive=yes
EOF
# restart

# ===========================
# Install resilio-sync
# https://help.resilio.com/hc/en-us/articles/206178924-Installing-Sync-package-on-Linux
echo "deb http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free" | sudo tee /etc/apt/sources.list.d/resilio-sync.list
wget -qO- https://linux-packages.resilio.com/resilio-sync/key.asc | sudo tee /etc/apt/trusted.gpg.d/resilio-sync.asc > /dev/null 2>&1
sudo apt-get update -y
sudo apt-get install resilio-sync -y
sudo usermod -aG $USER rslsync
sudo usermod -aG rslsync $USER
sudo chmod g+rw $HOME
systemctl --user enable resilio-sync
systemctl --user start resilio-sync
# http://127.0.0.1:8888

# ===========================
# Install syncthing
sudo apt-get install apt-transport-https -y
sudo apt-get install ca-certificates -y
# Add the release PGP keys:
sudo curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
# Add the "stable" channel to your APT sources:
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
# Add the "candidate" channel to your APT sources:
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing candidate" | sudo tee /etc/apt/sources.list.d/syncthing.list
# Update and install syncthing:
sudo apt-get update -y
sudo apt-get install syncthing -y

# ===========================
# Install touchegg/touche'/toucheggKDE
# https://github.com/JoseExposito/touchegg
# https://github.com/NayamAmarshe/ToucheggKDE
# https://github.com/JoseExposito/touche
sudo add-apt-repository ppa:touchegg/stable
sudo apt update -y
sudo apt install touchegg -y

# ===========================
# Install bash-it
# https://github.com/Bash-it/bash-it
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh
# Choose N to overwrite all
# ln -s -f ~/.bashrc ~/cfg_zsh/.bashrc
ln -f ~/.bashrc ~/cfg_zsh/.bashrc
echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
~/.fzf/install
echo 'source "$HOME/cfg_zsh/init.sh"' >> ~/.bashrc
tee -a ~/.bashrc <<EOF

HISTSIZE= 
HISTFILESIZE=
HISTTIMEFORMAT="[%F %T] "

export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:\$HOME/.local/share/flatpak/exports/share:\$XDG_DATA_DIRS"

export GOROOT="\$HOME/go"
export GOPATH="\$HOME/go/packages"
export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin
EOF

# Add oh-my-posh theme
# https://ohmyposh.dev/
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
tee -a ~/.bashrc <<EOF

eval "\$(oh-my-posh init bash)"
EOF
sed -i '/BASH_IT_THEME/c\export BASH_IT_THEME='\''oh-my-posh'\''' ~/.bashrc

# ===========================
# Install powershel (pwsh) (debian-11, bullseye)
# https://learn.microsoft.com/en-us/powershell/scripting/install/install-debian?view=powershell-7.4
sudo apt-get update -y
sudo apt-get install -y wget
DEBIAN_VERSION=11
wget -q https://packages.microsoft.com/config/debian/$DEBIAN_VERSION/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get update -y
sudo apt-get install -y powershell
# > pwsh
