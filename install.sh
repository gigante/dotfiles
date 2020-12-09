#!/bin/bash

function help() {
    echo -e "
${GREEN}Script to configure Archlinux or Fedora${NC}

${YELLOW}Some useful commands are:${NC}
  ${GREEN}basic${NC}  install basic packages
  ${GREEN}dev${NC}    install dev packages
  ${GREEN}apps${NC}   install general apps
  ${GREEN}dots${NC}   symlink dotfiles
  ${GREEN}prezto${NC} config prezto
  ${GREEN}rbenv${NC}  clone rbenv repo
  ${GREEN}pyenv${NC}  clone pyenv repo
  ${GREEN}bin${NC}    download binaries
  ${GREEN}pg${NC}     minimal postgresql config"
    exit 1
}











function basic() {
    case "$DISTRO" in
    arch)
        echo -e "${GREEN}Installing packages${NC}"
        "$YAY" bat neofetch nmap feh pass expect tree wget zsh stow whois pdftk jq picom scrot i3blocks i3lock-fancy htop upx \
            imagemagick gist heroku-cli xf86-input-libinput system-config-printer bluez blueman pulseaudio-bluetooth udiskie \
            gvfs-afc gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb playerctl lm_sensors sysstat acpi inotify-tools ;;
    fedora)
        echo -e "${GREEN}Updating packages${NC}"
        "$DNF" "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
        "$DNF" "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
        sudo dnf update
        echo -e "${GREEN}Installing packages${NC}"
	    "$DNF" util-linux-user redhat-rpm-config curl wget zsh stow nano jq bat pass expect neofetch ImageMagick \
	        gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel \
	        libyaml-devel libffi-devel gdbm-devel ncurses-devel dnf-plugins-core
        echo -e "${GREEN}Configuring${NC}"
        sudo sed -i "/SELINUX=.*/c\SELINUX=permissive" /etc/selinux/config
        sudo dnf groupinstall -y 'Development Tools' ;;
    esac
}

function dev() {
    case "$DISTRO" in
    arch)
        echo -e "${GREEN}Installing packages${NC}"
	    "$YAY" php php-gd php-xsl php-intl php-redis php-pgsql php-sqlite xdebug jdk jdk-openjdk icedtea-web nodejs npm yarn elixir go \
            dotnet-sdk postgresql virtualbox virtualbox-guest-iso virtualbox-host-dkms virtualbox-ext-oracle vagrant docker docker-compose
        echo -e "${GREEN}Configuring${NC}"
        sudo -iu postgres initdb -D /var/lib/postgres/data
	    sudo systemctl start postgresql.service
	    sudo usermod -aG docker "$NEWUSER" ;;
    fedora)
        echo -e "${GREEN}Removing (distro) docker packages${NC}"
        sudo dnf remove -y docker docker-client docker-client-latest docker-common docker-latest \
	        docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine
        sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
        echo -e "${GREEN}Installing packages${NC}"
	    "$DNF" golang docker-ce docker-ce-cli containerd.io \
	        php php-cli php-common php-gd php-json php-mbstring php-mcrypt php-opcache php-pdo php-pear php-pgsql \
	        php-mysqlnd php-mysqli php-process php-xml php-pecl-zip php-imap php-intl php-pecl-apcu php-soap \
	        java-1.8.0-openjdk java-1.8.0-openjdk-devel icedtea-web java-11-openjdk java-11-openjdk-devel java-latest-openjdk java-latest-openjdk-devel \
	        dotnet-sdk-3.1 aspnetcore-runtime-3.1 dotnet-runtime-3.1 elixir nodejs npm postgresql postgresql-server postgresql-contrib
        # docker-compose
        DOCKER_COMPOSE="$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)"
        sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	    sudo chmod +x /usr/local/bin/docker-compose
        echo -e "${GREEN}Configuring${NC}"
        mkdir -p "$HOME/go"
        # docker
	    sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
	    sudo usermod -aG docker "$NEWUSER"
        # postgresql
        sudo postgresql-setup --initdb --unit postgresql
	    sudo systemctl start postgresql.service ;;
    esac
}

function apps() {
    case "$DISTRO" in
    arch)
        echo -e "${GREEN}Installing apps${NC}"
	    "$YAY" rofi nautilus evince eog gimp libreoffice vlc spotify audacity dropbox rclone transmission filezilla \
	        firefox google-chrome emacs visual-studio-code-bin
        echo -e "${GREEN}Configuring${NC}"
	    sudo systemctl start tlp.service
	    sudo systemctl enable tlp.service ;;
    fedora)
        echo -e "${GREEN}Configuring${NC}"
        sudo dnf config-manager --set-enabled google-chrome
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
	    sudo dnf check-update
        echo -e "${GREEN}Installing apps${NC}"
        "$DNF" gnome-tweak-tool terminator vlc audacity rclone transmission filezilla emacs fedora-workstation-repositories google-chrome-stable code ;;
    esac
}

function dots() {
    echo -e "${GREEN}Installing dots${NC}"
    rm -rf "$HOME/.xinitrc" "$HOME/.config/{user-dirs.dirs,user-dirs.locale}"
    stow files
}

function prezto() {
    echo -e "${GREEN}Installing prezto${NC}"
    zsh ./prezto.sh
}

function rbenv() {
    echo -e "${GREEN}Installing rbenv${NC}"
    git clone https://github.com/rbenv/rbenv.git "$HOME/.rbenv"
	mkdir -p "$HOME/.rbenv/plugins"
	git clone https://github.com/rbenv/ruby-build.git "$HOME/.rbenv/plugins/ruby-build"
}

function pyenv() {
    echo -e "${GREEN}Installing pyenv${NC}"
    git clone https://github.com/pyenv/pyenv.git "$HOME/.pyenv"
}

function bin() {
    echo -e "${GREEN}Downloading bin files${NC}"
    curl -sS https://getcomposer.org/installer | php -- --install-dir="$HOME/bin" --filename=composer
	wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -O "$HOME/bin/lein" && chmod +x "$HOME/bin/lein"
	curl -sL https://git.io/JJvpl | bash -
}

function pg() {
    echo -e "${GREEN}Configuring postgresql${NC}"
    sudo -iu postgres createuser -P -s -e "$NEWUSER"
	createdb "$NEWUSER"
}

function main() {
    [[ -z "$command" ]] && help

    case "$command" in
    basic) basic ;;
    dev) dev ;;
    apps) apps ;;
    dots) dots ;;
    prezto) prezto ;;
    rbenv) rbenv ;;
    pyenv) pyenv ;;
    bin) bin ;;
    pg) pg ;;
    esac
}

NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'

YAY='yay -S --noconfirm'
DNF='sudo dnf install -y'
DISTRO=$(sed -n 's/^ID=//p' /etc/os-release)

NEWUSER='gigante'

command=$1
main "$@"