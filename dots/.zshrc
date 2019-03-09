# source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

setopt CLOBBER # overwrite existing files with '>'

source $HOME/.exports
source $HOME/.aliases
source $HOME/.functions
source $HOME/.user
