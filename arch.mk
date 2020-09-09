.PHONY: basic dev apps

basic:
	$(info --> Installing tools)
	sudo pacman -S --noconfirm bat neofetch nmap feh pass expect tree wget zsh whois pdftk picom scrot i3lock-fancy htop upx imagemagick gist heroku-cli
	sudo pacman -S --noconfirm xf86-input-libinput system-config-printer bluez blueman pulseaudio-bluetooth udiskie
	sudo pacman -S --noconfirm gvfs-afc gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb
	sudo pacman -S --noconfirm playerctl lm_sensors sysstat acpi inotify-tools

	$(info --> Installing fonts)
	sudo pacman -S --noconfirm ttf-bitstream-vera ttf-dejavu ttf-mac-fonts ttf-monaco ttf-ms-fonts

dev:
	$(info --> Installing php)
	sudo pacman -S --noconfirm php php-gd php-xsl php-intl php-redis php-pgsql php-sqlite xdebug

	$(info --> Installing java)
	sudo pacman -S --noconfirm jdk jdk-openjdk icedtea-web

	$(info --> Installing elixir, go, nodejs, npm and dotnet)
	sudo pacman -S --noconfirm elixir go nodejs npm yarn dotnet-sdk

	$(info --> Installing PostgreSQL)
	sudo pacman -S --noconfirm postgresql
	sudo -iu postgres initdb -D /var/lib/postgres/data
	sudo systemctl start postgresql.service

	$(info --> Installing virtualbox)
	sudo pacman -S --noconfirm virtualbox virtualbox-guest-iso virtualbox-host-dkms virtualbox-ext-oracle vagrant

	$(info --> Installing docker and docker-compose)
	sudo pacman -S --noconfirm docker docker-compose
	sudo usermod -aG docker "$(USER)"

apps:
	$(info --> Installing apps)
	sudo pacman -S --noconfirm rofi nautilus evince eog gimp libreoffice vlc spotify audacity dropbox rclone transmission filezilla
	sudo pacman -S --noconfirm firefox google-chrome emacs visual-studio-code-bin

	$(info --> Installing TLP)
	sudo systemctl start tlp.service
	sudo systemctl enable tlp.service