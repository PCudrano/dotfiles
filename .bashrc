# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=999999
HISTFILESIZE=50000
export HISTTIMEFORMAT="%F %T "
shopt -s cmdhist
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

################################# Mila prompt ##################################
# set variable identifying the chroot you work in (used in the prompt below)
# if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
#     debian_chroot=$(cat /etc/debian_chroot)
# fi
# 
# set a fancy prompt (non-color, unless we know we "want" color)
# case "$TERM" in
#     xterm-color|*-256color) color_prompt=yes;;
# esac
# 
# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes
# 
# if [ -n "$force_color_prompt" ]; then
#     if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
# 	# We have color support; assume it's compliant with Ecma-48
# 	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
# 	# a case would tend to support setf rather than setaf.)
# 	color_prompt=yes
#     else
# 	color_prompt=
#     fi
# fi
# 
# if [ "$color_prompt" = yes ]; then
#     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# else
#     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
# fi
# unset color_prompt force_color_prompt
# 
# # If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*)
#     PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#     ;;
# *)
#     ;;
# esac
################################################################################
#
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
# disable the default virtualenv prompt change
export VIRTUAL_ENV_DISABLE_PROMPT=1
# format bash
# RESET=${WHITE}
PS1='$([ $? == 0 ] && echo "\[${BASH_COLOR}\]┌─" || echo "\[${RED}\]X " )\[${BASH_COLOR}\]─────── \u@\h\[${BLUE}\] [\w]\[${YELLOW}\]$(__git_ps1 " (%s)")\n\[${BASH_COLOR}\]└─ $(ps1_python_env_info)\[${BASH_COLOR}\] λ \[${RESET}\]'
#PS1='\[${BASH_COLOR}\]┌─────── \u@\h\[${BLUE}\] [\w]\[${YELLOW}\]$(__git_ps1 " (%s)")\n\[${BASH_COLOR}\]└─ $(ps1_python_env_info)\[${BASH_COLOR}\] λ \[${RESET}\]'
#PS1='\[${BASH_COLOR}\]┌─────── \u@\h\[${BLUE}\] [\w]\[${YELLOW}\]$(__git_ps1 " (%s)")\n\[${BASH_COLOR}\]└─ \[${BASH_COLOR}\] λ \[${RESET}\]'

# If this is an gnome-terminal set the title to user@host:dir
# For konsole, just modify the preferences to print %w
# Set an xterm title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

################################################################################

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Source global definitions
# if [ -f /etc/bashrc ]; then
#     . /etc/bashrc
# fi
 
# GIT AUTOCOMPLETE
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
# if [ -f ~/.git-completion.bash ]; then
#     source ~/.git-completion.bash
# fi

# cool bash and git bash extension
if [ -f ~/.git-prompt.sh ]; then
    source ~/.git-prompt.sh
fi

export EDITOR=vim

# Huggingface
export HF_HOME="${SCRATCH}/.cache/huggingface"

# VS Code Python Debugger
export DEBUGPY_PROCESS_SPAWN_TIMEOUT=500

# Avoid escape of $ in tab completion
shopt -s direxpand

