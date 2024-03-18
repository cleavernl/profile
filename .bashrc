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

# Used to source team-specific bashrc files
#HCP=1
#FDP=1
SS=1

export EDITOR=vimx

WORKING="${HOME}/working"
TESTING="${HOME}/testing"

# Unlimited corefile size
ulimit -c unlimited

# always use vimx
alias vim=vimx

# Add some local paths to the PATH
export PATH=${HOME}/.scripts:$PATH

# used by ls for some specific formats
export LS_COLORS="di=94:ow=1;34;47:ln=1;33:or=31:ex=93"

# used to identify color support
export COLORTERM="truecolor"

# make make not spit out so much text
#export MAKEFLAGS="-s"
# adjust on the fly whether make spits out so much text
alias makeq='echo "export MAKEFLAGS=\"-s\"" && export MAKEFLAGS="-s"'
alias makel='echo "export MAKEFLAGS=\"\"" && export MAKEFLAGS=""'

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

function time_command() {
  # This function will time a provided command and print out how long it took
  # to run in HH:MM:SS format after it finishes
  #
  # $*    The command to run
  #
  # example:
  #   time_command make -j12
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

function print_command() {
  # This function will simple print out the command passed to it before executing
  # it. It uses some formatting to make the command printed out more visible in
  # cases where the command makes a lot of output.
  #
  # $*  the command to print
  #
  # example:
  #   print_command scl enable devtoolset-11 'cmake3 .. -DCMAKE_BUILD_TYPE=Release'
  #
  local CMD
  CMD="$*"
  echo -e "\033[33m${CMD}\033[0m"
  eval ${CMD}
  return $?
}

# Time and print the command
alias tp="time_command print_command"

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
alias hcp="cd ${WORKING}/hcp"
alias fdp="cd ${WORKING}/fdp"
alias ss="cd ${WORKING}/ss"
function gtop() {
  local GIT_TOP
  GIT_TOP=$(git rev-parse --show-toplevel)
  [[ $? == 0 ]] && cd ${GIT_TOP}
}

# == U.L3 == #
alias RSMReleases="cd /net/eggs/space/data/eggs/RSMReleases/"
# == U.L3 == #

# --------------------------------- #
#  QUICK SSHs                       #
# --------------------------------- #

# == U.L3 == #
alias oss="ssh -Y ssc-oss.u.l3"
alias ginko="ssh -Y ginko.u.l3"
alias gremlin="ssh -Y gremlin.u.l3"
alias meteorite="ssh -Y meteorite.u.l3"
# == U.L3 == #

# --------------------------------- #
#  QUICK SHORTHANDS                 #
# --------------------------------- #

# various ls formats
alias lt="ls -ltrh"
alias ll="ls -lh"
alias lla="ls -lah"

# podman imfo
alias pman='sudo podman'
alias pl="echo '===== PODS =====' && podman pod list && echo -e '\n===== IMAGES =====' && podman images && echo -e '\n===== CONTAINERS =====' && podman ps -a"

# Easy *rc access
alias sb="source ~/.bashrc"
alias brc="vim ~/.bashrc"
alias vrc="vim ~/.vimrc"

alias hcrc="vim ${HOME}/.bashrc.d/hcp_bashrc"
alias frc="vim ${HOME}/.bashrc.d/fdp_bashrc"
alias ssrc="vim ${HOME}/.bashrc.d/ss_bashrc"

# default some grep flags
alias grep="grep --color=auto --exclude-dir=.svn --exclude-dir=.git --binary-files=without-match --exclude=*.min* --exclude=tags"
alias grepf="`builtin` grep --color=auto -n"

# == U.L3 == #
# resize my terminal window to fit two monitors wide with the  monitors I have
alias wides="resize -s 52 424"
alias widet="resize -s 54 424"
# == U.L3 == #

# --------------------------------- #
#  REFERENCE INFORMATION            #
# --------------------------------- #

# cat some info files I wrote for myself
alias cdInfo="cat ${HOME}/.reference/cd_info"
alias vimdiffInfo="cat ${HOME}/.reference/vimdiff_info"
alias colorInfo="cat ${HOME}/.reference/color_info"

# == U.L3 == #
# Hostnames for people I may care about
alias david="echo 'calico'"
alias sam="echo 'laviren'"
alias brendan="echo 'miura'"
alias cavett="echo 'gremlin'"
# == U.L3 == #

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

  tp make -j$(nproc) $* 2> >(tee ${ERR_FILE})
  RET=$?

  echo -e "\n\033[33;1mSTDERR:\033[0m"
  cat ${ERR_FILE}

  rm ${ERR_FILE}
  return ${RET}
}

# perform a threaded make and time how long it takes
alias makef="tp make -j$(nproc)"

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

  print_command \
  podman run \
    --rm \
    -it \
    --entrypoint=/bin/bash \
    -w $(pwd) \
    --volume ${TOP}:/${TOP} \
    --volume ${HOME}:/root \
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

[[ "${HCP}" != "" ]] && source ${HOME}/.bashrc.d/hcp_bashrc > /dev/null 2>&1
[[ "${FDP}" != "" ]] && source ${HOME}/.bashrc.d/fdp_bashrc > /dev/null 2>&1
[[ "${SS}" != "" ]] && source ${HOME}/.bashrc.d/ss_bashrc > /dev/null 2>&1


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

