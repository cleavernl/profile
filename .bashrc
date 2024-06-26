# .bashrc

# --------------------------------- #
#  SOURCE GLOBAL DEFINITION         #
# --------------------------------- #

if [ -f /etc/bashrc ]; then
	source /etc/bashrc
fi

# --------------------------------- #
#  SETUP GLOBAL VARIABLES           #
# --------------------------------- #

export EDITOR=vimx

WORKING="${HOME}/working"
TESTING="${HOME}/testing"

# Unlimited corefile size
ulimit -c unlimited

# always use vimx
#alias vim=vimx

# Add some local paths to the PATH
export PATH="${HOME}/.scripts:${PATH}"

# used by ls for some specific formats
export LS_COLORS="di=94:ow=30;42:ln=1;33:or=31:ex=93"
alias ls="ls --color"

# used to identify color support
export COLORTERM="truecolor"

# make make not spit out so much text
#export MAKEFLAGS="-s"
# adjust on the fly whether make spits out so much text
#alias makeq='echo "export MAKEFLAGS=\"-s\"" && export MAKEFLAGS="-s"'
#alias makel='echo "export MAKEFLAGS=\"\"" && export MAKEFLAGS=""'

# --------------------------------- #
#  UTILITY FUNCTIONS                #
# --------------------------------- #

function rgb() {
  # This function will print the escape sequence needed in order to display
  # text in the provided RGB color. It should be noted that, once an escape
  # sequence has been printed, all following etxt will be formatted that way
  # until another escape sequence is provided to format the text a different
  # way. If you call this function with an inappropriate number of arguments,
  # then it will return the escape sequence needed to reset all formatting.
  # NOTE: When using this with echo, you need to provide the -e option.
  #
  # ${1}  R
  # ${2}  G
  # ${3}  B
  #
  # examples:
  #   echo -e "$(rgb 162 156 211)cleavernl$(rgb reset)"
  #   MYCOLOR="$(rgb 162 156 211)"
  #
  if [ $# == 3 ]
  then
    echo -e -n "\033[38;2;${1};${2};${3}m"
  else
    echo -e -n "\033[0m"
  fi
}

function timec() {
  # This function will time a provided command and print out how long it took
  # to run in HH:MM:SS format after it finishes
  #
  # $*    The command to run
  #
  # example:
  #   timec make -j12
  #
  local START_TIME END_TIME RUN_TIME RET
  START_TIME=$(date +%s)
  eval $*
  RET=$?
  END_TIME=$(date +%s)
  RUN_TIME=$((END_TIME-START_TIME))
  echo -e "\n\033[33;1mCompleted in $(date -u -d @$RUN_TIME +%H:%M:%S)\033[0m"
  return ${RET}
}

function printc() {
  # This function will simple print out the command passed to it before executing
  # it. It uses some formatting to make the command printed out more visible in
  # cases where the command makes a lot of output.
  #
  # $*  the command to print
  #
  # example:
  #   printc scl enable devtoolset-11 'cmake3 .. -DCMAKE_BUILD_TYPE=Release'
  #
  local CMD
  CMD="$*"
  echo -e "\033[33m${CMD}\033[0m"
  eval ${CMD}
  return $?
}

# Time and print the command
function tpc() {
  timec printc $*
}

# --------------------------------- #
#  BASH PROMPT                      #
# --------------------------------- #

PROMPT_COMMAND=set_prompt

function set_prompt() {
  #$(rgb 44 159 246)  # Blue
  #$(rgb 118 109 156) # Pomp and Power (Plum)
  #$(rgb 120 224 220) # Tiffany Blue (Cyan)
  #(rgb 23 184 144)   # Mint
  #$(rgb 157 105 90)  # Redwood (Dull Orange / Brown)

  HOSTCOLOR=$(rgb 255 243 0)          # Yellow
  CURRENTDIRCOLOR=$(rgb 132 188 156)  # Cambridge Blue (Pale Green)
  USERCOLOR=$(rgb 162 156 211)        # Wisteria (Misty Purple)
  SEPERATIONCOLOR=$(rgb 125 130 128)  # Gray
  BRANCHCOLOR="$SEPERATIONCOLOR"
  RESETCOLOR=$(rgb "reset")           # Default

  # Check to see if we are in a git repository
  BRANCHNAME="[$(git rev-parse --abbrev-ref HEAD 2> /dev/null)]"
  [[ $? -ne 0 ]] && BRANCHNAME=""

  # Left-aligned prompt
  PS1L="${USERCOLOR}\u${SEPERATIONCOLOR}@${HOSTCOLOR}\h${SEPERATIONCOLOR}:${BRANCHCOLOR}${BRANCHNAME}${CURRENTDIRCOLOR}\w/${RESETCOLOR}"
  # Right-aligned prompt
  PS1R="[\D{%H:%M}]"
  # Write the right side of the prompt, reset the cursor to the beginning, and write the left side of the prompt
  # The +4 in the COLUMNS+4 is important because the \, D, {, and } characters from PS1R are counted, but not displayed
  PS1=$(printf "${BRANCHCOLOR}%*s${RESETCOLOR}\r%s\n\$ " $((${COLUMNS}+4)) "$PS1R" "$PS1L")
}

# --------------------------------- #
#  GNOME PROFILE                    #
# --------------------------------- #

function gnome-profile() {
  # This function will load in my gnome profile, set it as the default, and
  # append it to the list of visible profiles from the "Preferences" GUI
  #
  which uuid > /dev/null 2>&1
  [[ $? -ne 0 ]] && echo "Error. Install uuid first." && return 1

  local PROFILE_IDS MY_PROFILE UUID
  UUID="$(uuid)"
  PROFILE_IDS="$(dconf read /org/gnome/terminal/legacy/profiles:/list | tr -d "]")"

  if [ -z "${PROFILE_IDS}" ]; then
    PROFILE_IDS="['${UUID}']"
  else
    PROFILE_IDS="${PROFILE_IDS}, '${UUID}']"
  fi

  # Load in my profile
  dconf load /org/gnome/terminal/legacy/profiles:/:${UUID}/ < ${HOME}/.reference/profile.dconf
  # Add my profile to the list in the GUI
  dconf write /org/gnome/terminal/legacy/profiles:/list "${PROFILE_IDS}"
  # Set my profile as the default
  gsettings set org.gnome.Terminal.ProfilesList default \'${UUID}\'
}

# --------------------------------- #
#  QUICK CDs                        #
# --------------------------------- #

alias working="cd ${WORKING}"
alias work="cd ${WORKING}"
alias testing="cd ${TESTING}"
alias tst="cd ${TESTING}"
alias ..="cd ../"
alias ....="cd ../../"
alias ......="cd ../../../"
alias ........="cd ../../../../"
alias ..........="cd ../../../../../"
function gtop() {
  # This function will bring you to the top level of your git repository regardless how many
  # submodules deep you are. Additionally, it will ensure a "cd -" will still work to put you
  # back to where you were
  #
  local GIT_TOP TEMP START
  GIT_TOP=$(git rev-parse --show-toplevel)
  [ $? -ne 0 ] && return 1

  START=$(pwd)
  while [ true ]; do
    cd ${GIT_TOP}/..
    # Check if there is another layer of submodules
    TEMP=$(git rev-parse --show-toplevel 2> /dev/null)
    if [ $? -eq 0 ]; then
      GIT_TOP="${TEMP}"
    else
      # Go back to the start so a "cd -" will go to the right place
      cd ${START}
      cd ${GIT_TOP}
      return 0
    fi
  done
}

# --------------------------------- #
#  QUICK SSHs                       #
# --------------------------------- #

# --------------------------------- #
#  QUICK SHORTHANDS                 #
# --------------------------------- #

# various ls formats
alias lt="ls -ltrh"
alias ll="ls -lh"
alias lla="ls -lah"

# podman imfo
#alias pman='sudo podman'
#alias pl="echo '===== PODS =====' && podman pod list && echo -e '\n===== IMAGES =====' && podman images && echo -e '\n===== CONTAINERS =====' && podman ps -a"

# Easy *rc access
alias sb="source ~/.bashrc"
alias brc="vim ~/.bashrc"
alias vrc="vim ~/.vimrc"

alias hrc="vim ${HOME}/.bashrc.d/${HOSTNAME}_bashrc"

# default some grep flags
alias grep="grep --color=auto --exclude-dir=.svn --exclude-dir=.git --binary-files=without-match --exclude=*.min* --exclude=tags"
alias grepf="`builtin` grep --color=auto -n"

# --------------------------------- #
#  REFERENCE INFORMATION            #
# --------------------------------- #

# cat some info files I wrote for myself
alias cdInfo="cat ${HOME}/.reference/cd_info"
alias vimdiffInfo="cat ${HOME}/.reference/vimdiff_info"
alias colorInfo="cat ${HOME}/.reference/color_info"

# --------------------------------- #
#  DOTGIT CONFIGURATION             #
# --------------------------------- #

alias dotgit="git --git-dir=${HOME}/.files --work-tree=${HOME}"

# --------------------------------- #
#  MAKE FUNCTIONS                   #
# --------------------------------- #

function makefe() {
  # This function will do a threaded make and save off all stderr output. After the make
  # finishes, the stderr will be printed out again so you can get a quick summary of what
  # failed in your compile if the output is very large
  # NOTE: unfortunately, this command will also strip any colors that would normally exist
  #
  local TEMP_DIR ERR_FILE RET
  TEMP_DIR="/tmp/makefe$(pwd)"
  ERR_FILE="${TEMP_DIR}/makefe-stderr-$(date +%s)"

  mkdir -p -m 775 $TEMP_DIR

  tpc make -j$(nproc) $* 2> >(tee ${ERR_FILE})
  RET=$?

  echo -e "\n\033[33;1mSTDERR:\033[0m"
  cat ${ERR_FILE}

  rm ${ERR_FILE}
  return ${RET}
}

# perform a threaded make and time how long it takes
alias makef="tpc make -j$(nproc)"

# --------------------------------- #
#  PODMAN FUNCTIONS                 #
# --------------------------------- #

function podman-here() {
  # This function will start running a specified container image. It will mount the top level
  # of the git repository on the same path in the container if you are in one, otherwise, it
  # will mount your current directory instead. Also, it will mount your ${HOME} under /root
  # with the idea being that you will be root in the container so, by mounting your ${HOME},
  # you will be able to source all of your own .bashrc, .vimrc, etc
  #
  # ${1}  container image to run
  #
  # example:
  #   podman-here jinja2:latest
  #
  local TOP
  # TOP is either the top level of a git directory or, if your not in a git directory,
  # the current directory instead
  TOP="$(git rev-parse --show-toplevel 2> /dev/null)"
  [[ $? != 0 ]] && TOP="$(pwd)"

  printc \
  podman run \
    --rm \
    -it \
    --entrypoint=/bin/bash \
    -w $(pwd) \
    --volume ${TOP}:${TOP} \
    --volume ${HOME}:/root \
    --security-opt label=disable \
    $*
}

# --------------------------------- #
#  BASH COMPLETION FUNCTIONS        #
# --------------------------------- #

#
# These following are used to generate a list of options that can be used when
# tab-completing custom functions. Once you create a completion function for a
# command, you can register that command to use that completion function with
# bash's "complete" command. that is what is happening here.
#

function _podman_image_name_completion() {
  # This function will get a list of all podman container names for use in tab-completion
  #
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  # check if the image name has already been provided
  if [[ $COMP_CWORD -gt 1 ]]; then
    # No further completion
    COMPREPLY=()
  else
    # Generate completion suggestions for image names
    opts=$(podman images --format='{{.Repository}}:{{.Tag}}')
    COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
    if [ ${#COMPREPLY[@]} -gt 1 ]; then
      COMPREPLY=( "${COMPREPLY[@]}" )
    fi
  fi
}

complete -F _podman_image_name_completion podman-here

# --------------------------------- #
#  CUSTOM CONFIGURATION             #
# --------------------------------- #

#
# I am part of the rotation program which requires me to change bash configurations
# often. To support this, I have customized bashrc files for each of the teams I have
# been to which I will source if my variables up top have been set correctly.
#

# If there is a bashrc file specific to the hostname, use it
[[ -f "${HOME}/.bashrc.d/${HOSTNAME}_bashrc" ]] && source ${HOME}/.bashrc.d/${HOSTNAME}_bashrc



# --------------------------------- #
#  GRAVEYARD                        #
# --------------------------------- #

#
# This section consists of stuff I no longer use, but don't necessarily want to
# get rid of completely. Perhaps I think I will want to use it again or perhaps
# I am just too lazy to delete it. Maybe I want it here to reference some syntax
# that took me a while to find or maybe not. Who knows why stuff ends up here,
# but it does...
#

#function pypackage(){
#  # This function takes a tarball python package and installs it
#  tar -xf $1
#  if [[ $? == 0 ]]; then
#    cd ${1%.tar.gz}
#    sudo python3 setup.py install
#    cd ..
#    sudo rm -rf ${1%.tar.gz}
#  fi
#}

