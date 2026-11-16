# dotfiles

My dotfiles for all machines, on one branch. Each machine checks out only the
shared files and its own folder, and `install.sh` symlinks them into `$HOME`.

```
install.sh        links one profile into $HOME
common/           shared by every machine (vim)
bash/             shared by the machines that use bash (bash, git, tmux, inputrc)
zsh/              the zsh setup with prezto, used on the Mac
hosts/cluster/    additions for the SLURM cluster: .bashrc.host
hosts/airlab/     additions for the AIRLab servers: .bashrc.host, GPU helpers, tmux, terminal theme
```

| Profile | Folders on disk |
|---|---|
| `cluster` | `common/`, `bash/`, `hosts/cluster/` |
| `airlab` | `common/`, `bash/`, `hosts/airlab/` |
| `macos` | `common/`, `zsh/` |

Every folder mirrors `$HOME`: `bash/.bashrc` becomes `~/.bashrc`. For the same
path, `hosts/<profile>/` wins over `bash/`, which wins over `common/`.

## Set up a new machine

```
git clone --filter=blob:none --sparse git@github.com:PCudrano/dotfiles.git ~/dotfiles
~/dotfiles/install.sh <profile>
```

`install.sh` does four things:

1. Restricts the checkout to the profile's folders (git sparse checkout, git 2.25 or
   newer). With an older git it prints a warning and keeps the full checkout.
2. Fetches the submodules of that profile (tpm, prezto, zsh-watch).
3. Symlinks each tracked file into `$HOME`. A file that already exists is moved to
   `~/.dotfiles-backup/<timestamp>/` first.
4. Sets up the Claude config, which lives in its own repo:
   `git clone git@github.com:PCudrano/claude-config.git ~/claude-config` and
   `~/claude-config/install.sh`. It skips this when `~/.claude/CLAUDE.md` is already
   a symlink, or when run as `NO_CLAUDE=1 ~/dotfiles/install.sh <profile>`.

On the bash profiles, open tmux and press `<prefix> + I` to install the tmux plugins.

A machine that only needs to pull can clone over HTTPS instead; the repo URL is the
only difference.

## Daily use

The files in `$HOME` are symlinks into `~/dotfiles`, so an edit to `~/.bashrc` is an
edit in the repo.

- Get updates: `git -C ~/dotfiles pull`, then `~/dotfiles/install.sh` (no argument;
  it remembers the profile) if files were added.
- Send changes back: `git commit` and `git push` in `~/dotfiles`.
- Track a new file: move it to the matching path under `common/`, `bash/`, `zsh/` or `hosts/<profile>/`,
  run `~/dotfiles/install.sh`, commit.

## Where a setting goes

| Setting applies to | Put it in |
|---|---|
| Every machine | `common/` |
| All bash machines | `bash/.bashrc`, `bash/.bash_aliases`, ... |
| One machine, tracked | `hosts/<profile>/.bashrc.host` (sourced at the end of `~/.bashrc`) |
| One machine, not tracked (secrets, experiments) | `~/.bashrc.local` (sourced last); for git, `~/.gitconfig.local` |
| The Mac | `zsh/.zshrc`, `zsh/.aliases` |

## Add a machine

1. Create `hosts/<name>/` with at least a `.bashrc.host`.
2. Add `<name>` to the `case` in `install.sh`.
3. Commit, then run the two setup commands on that machine.

## Old layout

Until 2026 this repo was a bare repo at `~/.dotfiles` with one branch per machine
(`bash_ubuntu`, `bash_ubuntu_airlab`, `bash_ubuntu_cluster`, `ubuntu-mila`,
`zsh_macos`, `zsh_macos_old`). Those branches are kept unchanged for reference.

To move a machine from the old layout: run the two setup commands above. The old
files in `$HOME` are moved to `~/.dotfiles-backup/`, and `~/.dotfiles` can be deleted
once the new setup works.
