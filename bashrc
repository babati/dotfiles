## General
# Completion
[ -r /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

# Shell options
set -o vi # Vi mode
shopt -s checkwinsize # Bash does not get SIGWINCH if another process is in foreground
shopt -s cdspell # Fix minor typos in directory names
shopt -s dirspell # Ignore typos in directory names at completion
shopt -s cmdhist # Multiline command appear as one entry in the history
shopt -s globstar # Enable ** pattern
shopt -s no_empty_cmd_completion # No completion for empty lines

# History
# Append to the history at exit
shopt -s histappend

# Path of history file
HISTFILE=~/.bash_history

# Size of stored history
HISTSIZE=50000
HISTFILESIZE=50000

# Avoid duplicates
HISTCONTROL=ignoredups:erasedups

## Theme
# Colors
RESET="\[\017\]"
NORMAL="\[\033[0m\]"
RED="\033[38;5;131m"
GREEN="\033[38;5;66m"
PURPLE="\033[38;5;60m"
BLUE="\033[38;5;116m"
DARKBLUE="\033[38;5;25m"
WHITE="\033[38;5;15m"

# Return value
STATUS_OK="${GREEN}>${NORMAL}"
STATUS_FAIL="${RED}|${WHITE}\${RV}${RED}|>${NORMAL}"
STATUS_MARK="RV=\$?; if [ \${RV} = 0 ]; then echo \"${STATUS_OK}\"; else echo \"${STATUS_FAIL}\"; fi"

# Git status
BRANCH_CMD="git rev-parse --abbrev-ref HEAD 2> /dev/null"
STATUS_BRANCH="${DARKBLUE}(${PURPLE}\${BRANCH}${DARKBLUE})${NORMAL} "
STATUS_GIT="BRANCH=\$(${BRANCH_CMD}); if [ ! -z \${BRANCH} ]; then echo \"${STATUS_BRANCH}\"; fi"

# PS1
PS1="${RESET}\`${STATUS_MARK}\` ${BLUE}\W${NORMAL} \`${STATUS_GIT}\`"

## User config
# Variables
export KEYTIMEOUT=1
export EDITOR='nvim'
export MANPAGER='less'
export PATH="$HOME/.cargo/bin:$PATH"

# Aliases
alias ls='ls --color=always'
alias ll='ls -lah --color=always'
alias :q='exit'
alias cd..='cd ..'
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias grep='grep --color=auto'
alias diff='colordiff'
alias vi=$EDITOR
alias vim=$EDITOR
alias vimdiff='vim -d'
alias tis='tig status'

# Git
alias gs='git status'
alias grbi='git rebase -i'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias gc='git commit'
alias gca='git commit --amend'
alias gcpc='git cherry-pick --continue'
alias gco='git checkout'
alias gf='git fetch -p'

# Terminal
if [[ $TERM == xterm ]]; then
  TERM=xterm-256color
fi
