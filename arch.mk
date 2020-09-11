.PHONY: basic dev apps

px := yay -S --noconfirm

basic:
	$(info --> Installing tools)
	@${px} bat neofetch nmap feh pass expect tree wget zsh stow whois pdftk picom scrot i3blocks i3lock-fancy htop upx imagemagick gist heroku-cli
	@${px} xf86-input-libinput system-config-printer bluez blueman pulseaudio-bluetooth udiskie
	@${px} gvfs-afc gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb
	@${px} playerctl lm_sensors sysstat acpi inotify-tools

	$(info --> Installing fonts)
	@${px} ttf-bitstream-vera ttf-dejavu ttf-mac-fonts ttf-monaco ttf-ms-fonts

dev:
	$(info --> Installing php)
	@${px} php php-gd php-xsl php-intl php-redis php-pgsql php-sqlite xdebug

	$(info --> Installing java)
	@${px} jdk jdk-openjdk icedtea-web

	$(info --> Installing elixir, go, nodejs, npm and dotnet)
	@${px} elixir go nodejs npm yarn dotnet-sdk

	$(info --> Installing PostgreSQL)
	@${px} postgresql
	sudo -iu postgres initdb -D /var/lib/postgres/data
	sudo systemctl start postgresql.service

	$(info --> Installing virtualbox)
	@${px} virtualbox virtualbox-guest-iso virtualbox-host-dkms virtualbox-ext-oracle vagrant

	$(info --> Installing docker and docker-compose)
	@${px} docker docker-compose
	sudo usermod -aG docker "$(USER)"

apps:
	$(info --> Installing apps)
	@${px} rofi nautilus evince eog gimp libreoffice vlc spotify audacity dropbox rclone transmission filezilla
	@${px} firefox google-chrome emacs visual-studio-code-bin

	$(info --> Installing TLP)
	sudo systemctl start tlp.service
	sudo systemctl enable tlp.service
