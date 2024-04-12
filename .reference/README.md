# Dotgit repository
The dotgit repository is used to manage any dotfiles you need for your environment configuration. Things like your `.bashrc`, `.vimrc`, `.gitconfig`, etc.
The original idea came from a [discussion thread](https://news.ycombinator.com/item?id=11071754) and the later adapted [article](https://www.atlassian.com/git/tutorials/dotfiles) online.
I have adapted their ideas to better suit my needs to create what you see here.

[TOC]

## New Computer Setup
### Quickstart
1. Set up the `dotgit` alias 
    ```
    alias dotgit="git --git-dir=${HOME}/.files --work-tree=${HOME}"
    ```
1. Clone this bare repository at `~/.files`
    ```
    git clone --bare <git-url> ${HOME}/.files
    ```
1. Checkout the files
    * NOTE: after running this, you may get some git complaints about files already existing. If this is the case, just remove those files and rerun the command.
    ```
    dotgit checkout
    ```

### Additional Settings
These settings are things I like to setup on any new computer I use that are not related to `dotgit`, but are very important to my workflow.
1. Install `gnome-tweaks` (if necessary) and use it to set workspaces and dark theme
1. Set keyboard shortcuts for super+\<number\> and super+shift+\<number\>
1. Disable super+\<number\> defaults
    ```
    for i in {1..9}; do gsettings set org.gnome.shell.keybindings switch-to-application-$i "[]"; done
    ```
1. Set terminal profile colors based on `colorInfo`


## Setting up your own dotgit repository
### Quickstart
1. Set up the `dotgit` alias 
    ```
    alias dotgit="git --git-dir=${HOME}/.files --work-tree=${HOME}"
    ```
1. (optional) Set the git default branchname to `main`
    ```
    git config --global init.defaultBranch main
    ```
1. Create a new bare repository at `~/.files`
    ```
    git init --bare ${HOME}/.files
    ```
1. Set the repository to ignore all untracked files
    ```
    dotgit config --local status.showUntrackedFiles no
    ```
1. Add any files you care about and push up like normal, but use `dotgit` instead of `git`
    ```
    dotgit add <filename>
    [...]
    dotgit add <filename>
    dotgit commit -m "Initial commit"
    dotgit remote add origin <url-to-blank-repository>
    dotgit push -u origin --all
    ```

