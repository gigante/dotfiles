.PHONY: help basic dev apps dots prezto rbenv pyenv bin pg

PY := 3.8.5
RB := 2.7.1
distro = arch

help:
	@echo
	@echo ".   ,     ,             .      "
	@echo "|\ /|     |        ,- o |      "
	@echo "| V | ,-: | , ,-.  |  . | ,-.  "
	@echo "|   | | | |<  |-'  |- | | |-'  "
	@echo "'   ' '-' ' \` '-'  |  ' ' '-' "
	@echo "                  -'           "
	@echo "Available target rules"
	@echo
	@echo "--- install ---"
	@echo "basic  basic packages"
	@echo "dev    development packages"
	@echo "apps   apps"
	@echo
	@echo "Examples:"
	@echo "  $$ make basic distro=fedora"
	@echo "  $$ make dev distro=arch"
	@echo
	@echo "--- shell ---"
	@echo "dots    symlink dotfiles"
	@echo "prezto  config prezto"
	@echo "rbenv   config rbenv"
	@echo "pyenv   config pyenv"
	@echo "bin     download binaries"
	@echo
	@echo "--- database ---"
	@echo "pg  create user, pass and db"

basic:
	@$(MAKE) -f ${distro}.mk basic

dev:
	@$(MAKE) -f ${distro}.mk dev

apps:
	@$(MAKE) -f ${distro}.mk apps

dots:
	$(info --> Config dots)
	@rm -rf $(HOME)/.xinitrc $(HOME)/.config/{user-dirs.dirs,user-dirs.locale}
	@stow files

prezto:
	$(info --> Config prezto)
	@$$(which zsh) ./prezto.sh

rbenv:
	$(info --> Installing rbenv)
	@git clone https://github.com/rbenv/rbenv.git $(HOME)/.rbenv
	@mkdir -p $(HOME)/.rbenv/plugins
	@git clone https://github.com/rbenv/ruby-build.git $(HOME)/.rbenv/plugins/ruby-build
	@$(HOME)/.rbenv/bin/rbenv install ${RB} && $(HOME)/.rbenv/bin/rbenv global ${RB}
	@gem update && gem install pry pry-meta

pyenv:
	$(info --> Installing pyenv)
	@git clone https://github.com/pyenv/pyenv.git $(HOME)/.pyenv
	@$(HOME)/.pyenv/bin/pyenv install ${PY} && $(HOME)/.pyenv/bin/pyenv global ${PY}
	@pip install -U pip setuptools youtube-dl pipenv

bin:
	$(info --> Downloading composer)
	@curl -sS https://getcomposer.org/installer | php -- --install-dir=$(HOME)/bin --filename=composer
	$(info --> Downloading leiningen)
	@wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -O $(HOME)/bin/lein && chmod +x $(HOME)/bin/lein
	$(info --> Downloading sh tools)
	@curl -sL https://git.io/JJvpl | bash -

pg:
	@sudo -iu postgres createuser -P -s -e $(USER)
	@createdb $(USER)
