# If running non-interactive shell, don't execute this file. Tools like
# scp will break if we echo text.

if [ -z "$PS1" ]; then
    return
else
    echo "Executing $BASH_SOURCE"
fi

# Function to prepend a directory to the beginning of the PATH

path_prepend()
{
    if [ -d $1 ] ; then
        PATH=${PATH//":$1"/}   #delete any instances in the middle or at the end
        PATH=${PATH//"$1:"/}   #delete any instances at the beginning
        export PATH="$1:$PATH" #prepend to beginning
    fi
}

# Add the syscomm bin directory to the beginning of the PATH

#path_prepend "/u4/syscomm/bin"

# Add Perforce sandbox bin directory to the beginning of the PATH
# so that these versions take precendence over tools later in the PATH

path_prepend "$HOME/projects/sandbox/$USER/bin"

#path_prepend "$HOME/bin/p4sandbox-2012.3.640073/bin"
path_prepend "$HOME/bin/p4v-2014.3.1007540/bin"

# If you have a bin directory, this adds it to the beginning of your
# PATH so that your versions of tools are selected first 

path_prepend "$HOME/bin"

#if [ -d $HOME/bin ] ; then
#   PATH=$HOME/bin:$PATH
#   PATH=$PATH:$HOME/bin
#fi

# It's considered bad practice to have the current directory in your PATH,
# however many users like having it. This should always appear at the END
# of your PATH. Comment this out if you don't want it at all.

#PATH=$PATH:

# Set the Bash prompt

export PS1='\h:\W\$ '

# Perforce related environment variables

export P4EDITOR=emacs
export P4DIFF=p4merge
export P4MERGE=p4merge

# Which pager to use for viewing text, ie; more, less, pg, and
# any default options for your pager.

#	PAGER=${PAGER:-more} ; export PAGER ; MORE='' ; export MORE
PAGER=${PAGER:-less} ; export PAGER ; LESS='-M' ; export LESS
#	PAGER=${PAGER:-pg} ; export PAGER ; PG='' ; export PG

# Which editor to use by default.
# EDITOR is for a line editor, VISUAL is for a full screen editor, and
# overrides the value of editor anyway.	 We'll set both to be sure.

export EDITOR=emacs
export VISUAL=emacs
export WINEDITOR=emacs

# Set to a value of 'ignorespace', it means don't enter lines which begin
# with a space or tab into the history list. Set to a value of 'ignoredups',
# it means don't enter lines which match the last entered line. A value of
# 'ignoreboth' combines the two options.

HISTCONTROL='ignoreboth'

# Set size of the .bash_history file to 10000 commands

HISTIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\[\033[00m\]\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\[\033[00m\]\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)} \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Things we should ONLY be doing if we're an interactive shell
# we figure this out by $PS1 being set or not, so make sure you
# don't do something silly like setting PS1 before this block

#if [ -n "$PS1" ] ; then

   # Define the terminal characteristics
#   stty erase ^H intr ^C kill ^U start ^Q stop ^S susp ^Z

   # set the window title if we can

#   if [ -n "$DISPLAY" ] ; then
#      if [ -n "$CLEARCASE_ROOT" ] ; then
#      	 PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}(${CLEARCASE_ROOT##*/}) ${LOGNAME} ${PWD}\007"'
#      else
#	 PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME} ${LOGNAME} ${PWD}\007"'
#      fi
#   fi
#fi

# Define the shell characteristics
# set -o option_name turns on the option, set +o option_name turns it off

set +o noglob		# allows use of <TAB><TAB> to expand names
set +o ignoreeof	# allow ^D to exit shell instead of "exit"
set +o noclobber	# allows redirection (>) to overwrite files

# Define which "editor" to use for editing command line and history

set -o emacs		# chose one of 'vi', 'emacs'

# Enable command completion

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# If it exists, source the Bash aliases file

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
    ssh_load_keys
fi
