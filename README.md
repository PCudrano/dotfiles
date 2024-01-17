# dotfiles

My dotfiles collections across different environments.

Sets up a bare repo under ~/.dotfiles directory, which can be managed using a `dotfiles` command instead of `git`. Quick and practical way to not have your home folder under git, but still have it ;-)<br>
I use a different branch for different machine configurations. The `main` branch only contains this README.

Credits for this setup to: https://www.atlassian.com/git/tutorials/dotfiles

## Quick guide

### Clone a setup on a new machine

```
git clone --recurse-submodules <git-repo-url> $HOME/dotfiles_tmp --branch zsh_macos
cp -r dotfiles_tmp/.git .dotfiles
cp dotfiles_tmp/.gitmodules .
rm -rf dotfiles_tmp
function dotfiles {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

# zprezto setup
#restore my runcom files for zprezto
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto_myruncoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
#restore git aliases
mv .zprezto/modules/git .zprezto/modules/_git
cp -r .zprezto_mymodules/git .zprezto/modules/git

# attempt to set up dotfiles
dotfiles checkout
if [ $? = 0 ]; then # if is overwriting some files
  echo "Checked out config.";
else
  # make backup of current dotfiles
  echo "Backing up pre-existing dot files.";
  mkdir -p .dotfiles-backup;
  dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{};
  dotfiles checkout
fi;
dotfiles config status.showUntrackedFiles no


```

### Add a new setup

First, make sure this repo is present on the machine: (If this dotfiles management is already used on the machine, you can skip this part)

```
git clone --bare <git-repo-url> $HOME/.dotfiles
function dotfiles {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
```

Create a branch for the new setup:
```
dotfiles checkout -b <branch-name>
```

Enable difference tracking:
```
dotfiles config --unset status.showUntrackedFiles
```

Add any file you modified with:
```
dotfiles add <filepaths>
```

Push the branch and changes:
```
dotfiles push --set-upstream origin <branch-name>
```
