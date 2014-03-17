# If running non-interactive shell, don't execute this file. Tools like
# scp will break if we echo text.

if [ -z "$PS1" ]; then
    return
else
    echo "Executing $HOME/.bashrc"
fi

# If you have a bin directory, this adds it to the beginning of your
# PATH so that your versions of tools are selected first 

if [ -d $HOME/bin ] ; then
   PATH=$HOME/bin:$PATH
#   PATH=$PATH:$HOME/bin
fi

# It's considered bad practice to have the current directory in your PATH,
# however many users like having it. This should always appear at the END
# of your PATH. Comment this out if you don't want it at all.

#PATH=$PATH:

# Set the Bash prompt

export PS1='\h:\W\$ '

# Perforce related environment variables

export P4EDITOR=emacs

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

# Things we should ONLY be doing if we're an interactive shell
# we figure this out by $PS1 being set or not, so make sure you
# don't do something silly like setting PS1 before this block

if [ -n "$PS1" ] ; then

   # Define the terminal characteristics
   stty erase ^H intr ^C kill ^U start ^Q stop ^S susp ^Z

   # set the window title if we can
   if [ -n "$DISPLAY" ] ; then
      if [ -n "$CLEARCASE_ROOT" ] ; then
      	 PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}(${CLEARCASE_ROOT##*/}) ${LOGNAME} ${PWD}\007"'
      else
	 PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME} ${LOGNAME} ${PWD}\007"'
      fi
   fi
fi

# Define the shell characteristics
# set -o option_name turns on the option, set +o option_name turns it off

set +o noglob		# allows use of <TAB><TAB> to expand names
set +o ignoreeof	# allow ^D to exit shell instead of "exit"
set +o noclobber	# allows redirection (>) to overwrite files

# Define which "editor" to use for editing command line and history

set -o emacs		# chose one of 'vi', 'emacs'

# Quilt settings

export QUILT_REFRESH_ARGS="-p ab --strip-trailing-whitespace --backup"
export QUILT_NO_DIFF_TIMESTAMPS=1
export QUILT_DIFF_OPTS="-p -U 6"

# If it exists, source the Bash aliases file

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi
