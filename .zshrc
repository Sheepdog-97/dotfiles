# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

######################################
# MERGED EXTRAS (Bash → Zsh safe)
######################################

# ---- History (Zsh-native) ----
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

# ---- PATH additions ----
path+=("$HOME/.cargo/bin")

# ---- FZF styling (if installed) ----
if command -v fzf >/dev/null; then
  export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --color=fg:-1,fg+:#c3c4c4,bg:-1,bg+:#262626
    --color=hl:#577354,hl+:#577354,info:#577354
    --color=prompt:#577354,pointer:#577354
    --border="rounded" --preview-window="border-rounded"'
fi

######################################
# QUALITY OF LIFE FUNCTIONS
######################################

# cd + auto ls
function cd() {
  builtin cd "$@" && ls -AF
}

# safer rm → moves to ~/.trash
function rm() {
  local trash="$HOME/.trash"
  mkdir -p "$trash"

  for f in "$@"; do
    [[ "$f" == -* ]] && continue
    mv -- "$f" "$trash/$(basename "$f").$(date +%s)" 2>/dev/null
  done
}

# extract archives
function ex() {
  [[ -f "$1" ]] || { echo "$1 is not a file"; return 1; }

  case "$1" in
    *.tar.gz) tar xzf "$1" ;;
    *.tar.xz) tar xf "$1" ;;
    *.zip) unzip "$1" ;;
    *.gz) gunzip "$1" ;;
    *.7z) 7z x "$1" ;;
    *) echo "Cannot extract $1" ;;
  esac
}

# show public IP
function myip() {
  curl -s https://ipinfo.io/ip && echo
}

######################################
# FZF DIRECTORY JUMP (cleaned)
######################################

function fz() {
  command -v fd >/dev/null || return
  command -v fzf >/dev/null || return

  local dir
  dir=$(fd --type d --hidden \
    --exclude .git \
    --exclude node_modules \
    --exclude .cache \
    . / 2>/dev/null \
    | fzf --query="$*" --select-1 --exit-0 \
          --extended-exact --height 40% --reverse \
          --preview 'tree -L 2 -C {}') \
    && cd "$dir"
}



######################################
# GIT HELPERS
######################################

function gacp() {
  local msg="${*:-Add files}"
  local branch remote

  branch=$(git branch --show-current)
  remote=$(git config --get "branch.$branch.remote" || echo origin)

  git add .
  git commit -m "$msg" && git push -u "$remote" "$branch"
}

######################################
# ALIASES (safe subset)
######################################

alias ll='ls -alF'
alias la='ls -lah'
alias l='ls -CF'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias h='history'
alias hg='history | grep'

alias gs='git status'
alias ga='git add .'
alias gc='git commit -m "Add files"'
alias gp='git push origin main'
alias gstash='git stash'

# redo last command with sudo (zsh-safe)
alias pls='sudo $(fc -ln -1)'

# print PATH nicely
alias path='echo $PATH | tr ":" "\n"'

[[ -f ~/.zshrc.private ]] && source ~/.zshrc.private
