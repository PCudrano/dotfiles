# dotfiles

My shell, git, vim and tmux configuration, on one branch for all machines.

```
install.sh        installs one profile into $HOME
common/           every machine (vim)
bash/             base for the bash machines (bash, git, tmux, inputrc)
zsh/              zsh with prezto, used on the Mac
hosts/cluster/    additions for the SLURM cluster
hosts/airlab/     additions for the AIRLab servers
```

| Profile | Uses |
|---|---|
| `cluster` | `common/` + `bash/` + `hosts/cluster/` |
| `airlab` | `common/` + `bash/` + `hosts/airlab/` |
| `macos` | `common/` + `zsh/` |

Each folder mirrors `$HOME` (`bash/.bashrc` becomes `~/.bashrc`). For the same path,
the later folder of the profile wins. Files already in `$HOME` are moved to
`~/.dotfiles-backup/<timestamp>/` first.

## Copy (one-off, no repo kept)

```
git clone --filter=blob:none --sparse https://github.com/PCudrano/dotfiles.git ~/dotfiles
~/dotfiles/install.sh --copy <profile>
rm -rf ~/dotfiles
```

The files are plain copies: customize whatever you need. The git identity is removed
from the copied `.gitconfig`; set your own with `git config --global user.name` and
`user.email`.

## Link (stays in sync with the repo)

```
git clone --filter=blob:none --sparse git@github.com:PCudrano/dotfiles.git ~/dotfiles
~/dotfiles/install.sh <profile>
```

- The files in `$HOME` are symlinks into `~/dotfiles`; only the profile's folders are
  checked out (sparse checkout, git 2.25 or newer).
- Update: `git -C ~/dotfiles pull`, then `~/dotfiles/install.sh` if files were added.
- Change: edit, `git commit`, `git push` in `~/dotfiles`.
- This mode also installs my private Claude config (`claude-config` repo); skip it
  with `NO_CLAUDE=1`.

After either mode, on the bash profiles: open tmux and press `<prefix> + I` to
install the tmux plugins.

## Where settings go

| Applies to | File |
|---|---|
| Every machine | `common/` |
| All bash machines | `bash/` |
| One machine, tracked | `hosts/<profile>/.bashrc.host` |
| One machine, untracked | `~/.bashrc.local`, `~/.gitconfig.local` |

To add a machine: create `hosts/<name>/.bashrc.host` and add `<name>` to the `case`
in `install.sh`.

The old per-machine branches (`bash_ubuntu*`, `ubuntu-mila`, `zsh_macos*`) are kept
for reference only.
