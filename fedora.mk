.PHONY: basic dev apps

DOCKER_FEDORA := 31 # https://download.docker.com/linux/fedora/
DOCKER_COMPOSE = $$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)

basic:
	$(info --> Basic configs)
	sudo sed -i "/SELINUX=.*/c\SELINUX=permissive" /etc/selinux/config
	sudo dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
	sudo dnf install -y "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
	sudo dnf update

	$(info --> Installing tools)
	sudo dnf groupinstall -y 'Development Tools'
	sudo dnf install -y util-linux-user redhat-rpm-config curl wget zsh stow nano bat pass expect neofetch ImageMagick
	sudo dnf install -y gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel
	sudo dnf install -y libyaml-devel libffi-devel gdbm-devel ncurses-devel

dev:
	$(info Installing golang)
	sudo dnf install -y golang
	mkdir -p "${HOME}"/go

	$(info Installing PHP packages)
	sudo dnf install -y php php-cli php-common php-gd php-json php-mbstring php-mcrypt php-opcache php-pdo php-pear php-pgsql
	sudo dnf install -y php-mysqlnd php-mysqli php-process php-xml php-pecl-zip php-imap php-intl php-pecl-apcu php-soap

	$(info Installing Java packages)
	sudo dnf install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel icedtea-web
	sudo dnf install -y java-11-openjdk java-11-openjdk-devel
	sudo dnf install -y java-latest-openjdk java-latest-openjdk-devel

	$(info Installing DotNet packages)
	sudo dnf install -y dotnet-sdk-3.1 aspnetcore-runtime-3.1 dotnet-runtime-3.1

	$(info Installing Elixir, NodeJS and npm)
	sudo dnf install -y elixir nodejs npm

	$(info Installing PostgreSQL)
	sudo dnf install -y postgresql postgresql-server postgresql-contrib
	sudo postgresql-setup --initdb --unit postgresql
	sudo systemctl start postgresql.service

	$(info Installing Docker)
	sudo dnf remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate
	sudo dnf remove -y docker-logrotate docker-selinux docker-engine-selinux docker-engine
	sudo dnf install -y dnf-plugins-core
	sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
	sudo sed -i 's/$$releasever/${DOCKER_FEDORA}/g' /etc/yum.repos.d/docker-ce.repo
	sudo dnf install -y docker-ce docker-ce-cli containerd.io
	sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
	sudo usermod -aG docker "${USER}"

	$(info Installing Docker compose)
	sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE}/docker-compose-$$(uname -s)-$$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose

apps:
	$(info Installing apps)
	sudo dnf install -y gnome-tweak-tool terminator vlc audacity rclone transmission filezilla emacs

	$(info Installing dropbox)
	cd "${HOME}" && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
	"${HOME}"/.dropbox-dist/dropboxd

	$(info Installing Google Chrome)
	sudo dnf install -y fedora-workstation-repositories
	sudo dnf config-manager --set-enabled google-chrome
	sudo dnf install -y google-chrome-stable

	$(info Installing VSCode)
	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
	sudo dnf check-update
	sudo dnf install -y install code