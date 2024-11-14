# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# If there are multiple matches for completion, Tab should cycle through them
bind 'TAB:menu-complete'

# Display a list of the matching files
bind "set show-all-if-ambiguous on"

# Perform partial (common) completion on the first Tab press, only start
# cycling full results on the second Tab press (from bash version 5)
bind "set menu-complete-display-prefix on"

# Catch terminal window resizes properly: check the window size after each 
# command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Enable 256 color capabilities if dircolors exist
# (ls --color=auto) will use solarized colors
hash dircolors 2>/dev/null && eval `dircolors $HOME/.dircolors`

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
 
# GIT AUTOCOMPLETE
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash
fi


# CUDA
export LD_LIBRARY_PATH=/usr/local/cuda/lib64/${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/cuda/lib64/${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export CPATH=/usr/local/cuda/include${CPATH:+:${CPATH}}
export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
export CUDA_ROOT=/usr/local/cuda/

# texlive path
# export PATH=/usr/local/texlive/2016/bin/x86_64-linux${PATH:+:${PATH}}
# export INFOPATH=/usr/local/texlive/2016/texmf-dist/doc/info


# PATHS
#=======
# export PYTHONPATH_INIT="$PYTHONPATH"
export PATH=$HOME/.local/bin:${PATH:+:${PATH}}
# export PATH_INIT="$PATH"

# Set TMP
export TMP='/tmp'
export TMPDIR='/tmp'

# OTHERS
#========
export EDITOR=vim

# Ctrl-D
#IGNOREEOF=10   # Shell only exists after the 10th consecutive Ctrl-d

# autojump
#[[ -s /u/visin/.autojump/etc/profile.d/autojump.sh ]] && source /u/visin/.autojump/etc/profile.d/autojump.sh

# cool bash and git bash extension
#if [ -f ~/.git-prompt.sh ]; then
#    source ~/.git-prompt.sh
#fi

################################## My prompt ###################################
# SOLARIZED
# if [[ $COLORTERM = gnome-* && $TERM = xterm ]]  && infocmp gnome-256color >/dev/null 2>&1; then TERM=gnome-256color; fi
# See http://unix.stackexchange.com/questions/105926/how-to-include-commands-in-bashs-ps1-without-breaking-line-length-calculation

# You can get a list of colors with:
# for i in {0..255}; do
#     printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
# done

if tput setaf 1 &> /dev/null; then
    tput sgr0
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
      BASE03=$(tput setaf 234)
      BASE02=$(tput setaf 235)
      BASE01=$(tput setaf 240)
      BASE00=$(tput setaf 241)
      BASE0=$(tput setaf 244)
      BASE1=$(tput setaf 245)
      BASE2=$(tput setaf 254)
      BASE3=$(tput setaf 230)
      YELLOW=$(tput setaf 136)
      ORANGE=$(tput setaf 166)
      RED=$(tput setaf 160)
      MAGENTA=$(tput setaf 125)
      VIOLET=$(tput setaf 61)
      BLUE=$(tput setaf 33)
      BLUE2=$(tput setaf 75)
      CYAN=$(tput setaf 37)
      GREEN=$(tput setaf 64)
      GREEN2=$(tput setaf 76)
    else
      BASE03=$(tput setaf 8)
      BASE02=$(tput setaf 0)
      BASE01=$(tput setaf 10)
      BASE00=$(tput setaf 11)
      BASE0=$(tput setaf 12)
      BASE1=$(tput setaf 14)
      BASE2=$(tput setaf 7)
      BASE3=$(tput setaf 15)
      YELLOW=$(tput setaf 3)
      ORANGE=$(tput setaf 9)
      RED=$(tput setaf 1)
      MAGENTA=$(tput setaf 5)
      VIOLET=$(tput setaf 13)
      BLUE=$(tput setaf 4)
      BLUE2=$(tput setaf 4)
      CYAN=$(tput setaf 6)
      GREEN=$(tput setaf 2)
      GREEN2=$(tput setaf 2)
    fi
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    # Linux console colors. I don't have the energy
    # to figure out the Solarized values
    # foreground colors
    BLACK="\e[0;30m"        # Black
    RED="\e[0;31m"          # Red
    GREEN="\e[0;32m"        # Green
    YELLOW="\e[0;33m"       # Yellow
    BLUE="\e[0;34m"         # Blue
    BLUE2="\e[0;34m"         # Blue
    PURPLE="\e[0;35m"       # Purple
    CYAN="\e[0;36m"         # Cyan
    WHITE="\e[0;37m"        # White
    MAGENTA="\033[1;31m"
    ORANGE="\033[1;33m"
    GREEN="\033[1;32m"
    GREEN2="\033[1;32m"
    PURPLE="\033[1;35m"
    WHITE="\033[1;37m"
    BOLD=""
    RESET="\033[m"
fi
if [ -f /.dockerenv ]; then
    BASH_COLOR=${ORANGE}
else
    BASH_COLOR=${GREEN}
fi

function ps1_python_env_info {
    env=""
    [[ -n "${VIRTUAL_ENV}" ]] && env+="\001${BLUE2}\002(venv:${VIRTUAL_ENV##*/})"
    [[ -n "${CONDA_DEFAULT_ENV}" ]] && env+="\001${GREEN2}\002(conda:${CONDA_DEFAULT_ENV##*/})"
    # Note: \001 and \002 are octal escapes instead of \[ and \], since these do not work inside
    # functions (https://wiki.archlinux.org/title/Bash/Prompt_customization)
    echo -e $env
}

# Hide conda current env in the prompt
if hash conda 2>/dev/null; then
    conda config --set changeps1 False
fi

# format bash
export VIRTUAL_ENV_DISABLE_PROMPT=1
PS1='$([ $? == 0 ] && echo "\[${BASH_COLOR}\]┌─" || echo "\[${RED}\]X " )\[${BASH_COLOR}\]─────── \u@\h\[${BLUE}\] [\w]\[${YELLOW}\]$(__git_ps1 " (%s)")\n\[${BASH_COLOR}\]└─ $(ps1_python_env_info)\[${BASH_COLOR}\] λ \[${RESET}\]'

# If this is an gnome-terminal set the title to user@host:dir
# For konsole, just modify the preferences to print %w
# Set an xterm title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#    ;;
#*)
#    ;;
#esac

# SSH Agent (save passphrase after first use)
if [ $(ps aux | grep -v grep | grep ssh-agent | wc -l) -eq 0 ]; then
	eval $(ssh-agent -s) > /dev/null
fi

# History stuff
export HISTFILESIZE=1000000000
export HISTSIZE=1000000
export HISTTIMEFORMAT="%F %T "
shopt -s cmdhist
shopt -s histappend

# added by Miniconda3 installer
export PATH="$HOME/miniconda3/bin:$PATH"

# Custom function for magrathea GPUs
if [[ -f ~/.magrathea_fcn ]]; then
    source ~/.magrathea_fcn
fi

################################################################################

# Huggingface
export HF_HOME="/multiverse/storage/cudrano/.cache/huggingface"

# VS Code Python Debugger
export DEBUGPY_PROCESS_SPAWN_TIMEOUT=500

