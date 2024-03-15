# Initial setup

1. Set up the `dotgit` alias
  `alias dotgit="git --git-dir=${HOME}/.files --work-tree=${HOME}"`
1. (optional) Set the git default branchname to `main`
  `git config --global init.defaultBranch main`
1. Create a new bare repository at `~/.files`
  `git init --bare ${HOME}/.files`
1. 

