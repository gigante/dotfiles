.PHONY: help basic dev apps dots prezto rbenv pyenv bin pg

DISTRO := $$(sed -n 's/^ID=//p' /etc/os-release)

help:
	@echo 'Some useful commands are:'
	@echo ' - basic   install basic packages'
	@echo ' - dev     install dev packages'
	@echo ' - apps    install general apps'
	@echo ' - dots    symlink dotfiles'
	@echo ' - prezto  config prezto'
	@echo ' - rbenv   clone rbenv repo'
	@echo ' - pyenv   clone pyenv repo'
	@echo ' - bin     download binaries'
	@echo ' - pg      minimal postgresql config"'

basic:
	@./scripts/$(DISTRO) basic

dev:
	@./scripts/$(DISTRO) dev

apps:
	@./scripts/$(DISTRO) apps

dots:
	@./scripts/common dots

prezto:
	@./scripts/common prezto

rbenv:
	@./scripts/common rbenv

pyenv:
	@./scripts/common pyenv

bin:
	@./scripts/common bin

pg:
	@./scripts/common pg
