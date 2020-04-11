.PHONY: dots php pyenv rbenv lein basic dev apps virtualbox docker fonts

export PY_VERSION=3.8.2
export RB_VERSION=2.7.1
export PY_PATH=$(HOME)/.pyenv
export RB_PATH=$(HOME)/.rbenv

dots:
	@yay -S stow
	@rm -rf $(HOME)/.xinitrc $(HOME)/.config/{user-dirs.dirs,user-dirs.locale}
	@stow bin && stow dots

php:
	@yay -S php php-gd php-xsl php-intl php-redis php-pgsql php-sqlite xdebug
	@curl -sS https://getcomposer.org/installer | php -- --install-dir=$(HOME)/bin --filename=composer

pyenv:
	@git clone https://github.com/pyenv/pyenv.git $(HOME)/.pyenv
	@${PY_PATH}/bin/pyenv install ${PY_VERSION} && ${PY_PATH}/bin/pyenv global ${PY_VERSION}

rbenv:
	@git clone https://github.com/rbenv/rbenv.git $(HOME)/.rbenv
	@mkdir -p ${RB_PATH}/plugins
	@git clone https://github.com/rbenv/ruby-build.git ${RB_PATH}/plugins/ruby-build
	@${RB_PATH}/bin/rbenv install ${RB_VERSION} && ${RB_PATH}/bin/rbenv global ${RB_VERSION}

lein:
	@wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -O $(HOME)/bin/lein && chmod +x $(HOME)/bin/lein

basic:
	@yay -S bat neofetch nmap feh pass expect qrencode xclip tree wget whois pdftk picom scrot i3lock-fancy htop upx imagemagick gist heroku-cli
	@yay -S xf86-input-libinput system-config-printer bluez blueman pulseaudio-bluetooth udiskie
	@yay -S gvfs-afc gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb
	@yay -S playerctl lm_sensors sysstat acpi inotify-tools

dev:
	@yay -S jdk jdk-openjdk icedtea-web elixir go nodejs npm dotnet-sdk

apps:
	@yay -S rofi nautilus evince eog gimp libreoffice vlc spotify audacity dropbox rclone transmission filezilla
	@yay -S firefox google-chrome emacs visual-studio-code-bin

virtualbox:
	@yay -S virtualbox virtualbox-guest-iso virtualbox-host-dkms virtualbox-ext-oracle vagrant

docker:
	@yay -S docker docker-compose ctop-bin
	@sudo usermod -aG docker $(USER)

fonts:
	@yay -S otf-font-awesome ttf-bitstream-vera ttf-dejavu ttf-fantasque-sans-mono ttf-fira-code ttf-hack ttf-mac-fonts ttf-monaco ttf-ms-fonts

home: php pyenv rbenv lein

install: basic dev apps virtualbox docker fonts