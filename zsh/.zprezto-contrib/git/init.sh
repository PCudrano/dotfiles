#
# Provides Git aliases and functions.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
# Adapted to load oh-my-zsh plugin instead - Autror: Paolo Cudrano 2024

# Return if requirements are not found.
if (( ! $+commands[git] )); then
  return 1
fi

# Load dependencies.
# pmodload 'helper'

# Load 'run-help' function.
# autoload -Uz run-help-git

# Source module files.
# source "${0:h}/alias.zsh"
source "${0:h}/git.plugin.zsh"
