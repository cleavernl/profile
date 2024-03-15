# Dotgit repository
The dotgit repository is used to manage any dotfiles you need for your environment configuration. Things like your `.bashrc`, `.vimrc`, `.gitconfig`, etc. The original idea came from a [discussion thread](https://news.ycombinator.com/item?id=11071754) and the later adapted [article](https://www.atlassian.com/git/tutorials/dotfiles) online. I have adapted their ideas to better suit my needs to create what you see here.

[TOC]

## Seting up a new environment with this dotgit repository
### Quickstart
1. Set up the `dotgit` alias 
```
alias dotgit="git --git-dir=${HOME}/.files --work-tree=${HOME}"
```
1. Clone this bare repository at `~/.files`
```
git clone --bare ${HOME}/.files
```
1. Checkout the files
    * NOTE: after running this, you may get some git complaints about files already existing. If this is the case, just remove those files and rerun the command.
```
dotgit checkout
```

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
1. Add any files you care about and push up like normal, but use `dotgit` instead of `git`
```
dotgit add <filename>
[...]
dotgit add <filename>
dotgit commit -m "Initial commit"
dotgit remote add origin <url-to-blank-repository>
dotgit push -u origin --all
```

