#!/usr/bin/env bash
# Usage: ./install.sh <profile>     profile: cluster | airlab | macos
# Run again without arguments after a `git pull` to link newly added files.
# NO_CLAUDE=1 ./install.sh <profile> skips the Claude config step.
set -euo pipefail

repo=$(cd "$(dirname "$0")" && pwd)
cd "$repo"

profile=${1:-$(git config dotfiles.profile || true)}
case $profile in
  macos)          dirs=(hosts/macos) ;;
  cluster|airlab) dirs=(linux "hosts/$profile") ;;
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

# Symlink every tracked file into $HOME. A file in hosts/<profile>/ wins over
# the same path in linux/. Existing real files are moved to a backup folder.
backup=$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)
for d in "${dirs[@]}"; do
  git ls-files -- "$d" | while read -r f; do
    rel=${f#"$d"/}
    [[ $d == linux && -e hosts/$profile/$rel ]] && continue
    dst=$HOME/$rel
    if [[ -L $dst ]]; then
      rm "$dst"
    elif [[ -e $dst ]]; then
      mkdir -p "$(dirname "$backup/$rel")"
      mv "$dst" "$backup/$rel"
      echo "moved existing ~/$rel to $backup/"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$repo/$f" "$dst"
  done
done
echo "dotfiles: linked profile '$profile' into $HOME"

# Claude config lives in its own repo; it is only called from here.
# Skipped where it is already linked (for example from another clone location).
if [[ -z ${NO_CLAUDE:-} && ! -L $HOME/.claude/CLAUDE.md ]]; then
  [[ -d $HOME/claude-config ]] || git clone git@github.com:PCudrano/claude-config.git "$HOME/claude-config"
  "$HOME/claude-config/install.sh"
fi
