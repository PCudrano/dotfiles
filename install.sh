#!/usr/bin/env bash
# Usage: ./install.sh <profile>     profile: cluster | airlab | macos
# Run again without arguments after a `git pull` to link newly added files.
# NO_CLAUDE=1 ./install.sh <profile> skips the Claude config step.
#
# ./install.sh --copy <profile> copies the files instead of linking them, for
# people who only want the setup: afterwards the clone can be deleted. It removes
# my git identity from the copied .gitconfig and skips the Claude config step.
set -euo pipefail

repo=$(cd "$(dirname "$0")" && pwd)
cd "$repo"

copy=
if [[ ${1:-} == --copy ]]; then copy=1; shift; fi
profile=${1:-$(git config dotfiles.profile || true)}
case $profile in
  macos)          dirs=(common zsh) ;;
  cluster|airlab) dirs=(common bash "hosts/$profile") ;;
  *) echo "usage: $0 cluster|airlab|macos" >&2; exit 1 ;;
esac
git config dotfiles.profile "$profile"

# Keep only this machine's folders on disk (needs git >= 2.25).
if ! { git sparse-checkout init --cone && git sparse-checkout set "${dirs[@]}"; } 2>/dev/null; then
  echo "warning: this git has no sparse checkout; the other hosts' folders stay in $repo (unused)"
fi

# Fetch only the submodules that belong to this profile.
git config -f .gitmodules --get-regexp '\.path$' | while read -r _ path; do
  for d in "${dirs[@]}"; do
    case $path in "$d"/*) git submodule update --init --recursive -- "$path" ;; esac
  done
done

# Symlink (or with --copy, copy) every tracked file into $HOME. For the same path a later folder of the
# profile wins (hosts/<profile>/ over bash/ over common/). Existing real files
# are moved to a backup folder.
backup=$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)
for i in "${!dirs[@]}"; do
  d=${dirs[i]}
  git ls-files -- "$d" | while read -r f; do
    rel=${f#"$d"/}
    for later in "${dirs[@]:i+1}"; do [[ -e $later/$rel ]] && continue 2; done
    dst=$HOME/$rel
    if [[ -L $dst ]]; then
      rm "$dst"
    elif [[ -e $dst ]]; then
      mkdir -p "$(dirname "$backup/$rel")"
      mv "$dst" "$backup/$rel"
      echo "moved existing ~/$rel to $backup/"
    fi
    mkdir -p "$(dirname "$dst")"
    if [[ -z $copy ]]; then
      ln -s "$repo/$f" "$dst"
    else
      cp -Rp "$repo/$f" "$dst"
      # a submodule: drop its pointer back into this clone
      if [[ -d $dst ]]; then find "$dst" -name .git -exec rm -rf {} +; fi
    fi
  done
done

if [[ -n $copy ]]; then
  git config --file "$HOME/.gitconfig" --remove-section user 2>/dev/null || true
  echo "dotfiles: copied profile '$profile' into $HOME; you can delete $repo"
  echo "set your own git identity: git config --global user.name '...'; git config --global user.email '...'"
  exit
fi
echo "dotfiles: linked profile '$profile' into $HOME"

# Claude config lives in its own repo; it is only called from here.
# Skipped where it is already linked (for example from another clone location).
if [[ -z ${NO_CLAUDE:-} && ! -L $HOME/.claude/CLAUDE.md ]]; then
  [[ -d $HOME/claude-config ]] || git clone git@github.com:PCudrano/claude-config.git "$HOME/claude-config"
  "$HOME/claude-config/install.sh"
fi
