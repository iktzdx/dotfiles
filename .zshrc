## Color output in console
if [ "$TERM" = "linux" ]; then
    _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    for i in $(sed -n "$_SEDCMD" $HOME/.Xresources | awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
        echo -en "$i"
    done
    clear
fi

## try to avoid the 'zsh: no matches found...'
setopt nonomatch

## alert me if something failed
setopt printexitvalue

## changed completer settings
zstyle ':completion:*' rehash true
zstyle ':completion:*' completer _complete _correct _approximate _expand_alias
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' menu select

## Use a default width of 80 for manpages for more convenient reading
export MANWIDTH=${MANWIDTH:-80}

eval `dircolors -b ~/.dir_colors`

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

## History
setopt correctall
export HISTSIZE=10000
export HISTFILE="$HOME/.zsh_history"
export SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups
setopt hist_ignore_space

## Some magic from gentoo wiki
setopt autocd
setopt extendedglob

## Prompt customization
autoload -Uz promptinit
promptinit
prompt off

setopt prompt_subst

## Colorize the prompt char depending of user
function _prompt_char() {
  if [[ $EUID -eq 0 ]]; then
    echo '%F{9}%#%f'
  else
    echo '%F{10}%#%f'
  fi
}

## Get the current directory length and reduce it to <= 45
function _current_directory() {
  local _max_pwd_length="45"
  if [[ $(echo -n $PWD | wc -c) -gt ${_max_pwd_length} ]]; then
    echo '%-2~/../%1~'
  else
    echo '%~'
  fi
}

## Git status magic
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr '%F{2} ●%f'
zstyle ':vcs_info:*' unstagedstr '%F{yellow} ●%f'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{red}:%f%F{yellow}%r%f'
zstyle ':vcs_info:*' enable git


precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats '%F{12}/%b%c%u%f%F{12}%f'
    } else {
        zstyle ':vcs_info:*' formats '%F{12}/%b%c%u%f%F{red} ●%f%F{12}%f'
    }
    vcs_info
}

## Set prompts
function vi_mode_prompt_info() {
  VIM_PROMPT="%F{8}✗ n %f"
  VIM_RPROMPT="%F{8}→ i %f"

  echo "${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/$VIM_RPROMPT}"
}

function venv_info {
  [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function _current_user() {
  if [[ $(echo "$USER") != "root" ]]; then
    echo "%n";
  else
    echo "%f%F{1}%n%f%F{8}";
  fi
}


function zle-line-init zle-keymap-select {
  PROMPT='%{%f%k%b%}
 %F{8}$(_current_directory)%f ${vcs_info_msg_0_}
 $(venv_info)$(_prompt_char) '
 RPROMPT='%{$(echotc UP 1)%}$(vi_mode_prompt_info)%F{8}/%l:$(_current_user)@%M%f%{$(echotc DO 1)%}'

  zle reset-prompt
  zle -R
}

zle -N zle-line-init
zle -N zle-keymap-select

## Key binds
bindkey -v

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search
bindkey '^A' vi-beginning-of-line
bindkey '^E' vi-end-of-line

bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

bindkey -s '^[f' '~/.local/bin/tmux-sessionizer^M'
bindkey -s '^[d' '~/.local/bin/tmux-sessionizer ~/Documents/Notes/^M'
bindkey -s '^[s' '~/.local/bin/tmux-sessionizer ~/.local/share/scripts/^M'
bindkey -s '^[t' '~/.local/bin/tmux-sessionizer ~/.config/tmux/^M'
bindkey -s '^[v' '~/.local/bin/tmux-sessionizer ~/.config/nvim/^M'

## fzf
source '/usr/share/fzf/key-bindings.zsh'
source '/usr/share/fzf/completion.zsh'

export KEYTIMEOUT=1

## Aliases
source $HOME/.aliases

DISABLE_UPDATE_PROMPT=true
