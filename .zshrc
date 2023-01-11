autoload -Uz vcs_info # enable vcs_info
precmd () { vcs_info } # always load before displaying the prompt
setopt prompt_subst
#PS1='%n@%m %F{red}%/%f$vcs_info_msg_0_ $ '
PS1='%3~ ${vcs_info_msg_0_}%# '

export PATH="$PATH:$HOME/Dev/ccls/Release"

HISTFILE=~/.zsh_history
HISTSIZE=10000  # Save most-recent 10000 lines
SAVEHIST=10000  # Save most-recent 10000 lines

source ~/.zsh_aliases

bindkey -v
bindkey '^R' history-incremental-search-backward
bindkey '^[[3~' delete-char
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
