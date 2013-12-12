###########################################################################
# MA26 Software Engineering standard login template
#
# The latest version of this template can be found in /project/bcs/shell,
# or in /vobs/tools/shell
#
# This is the login file executed by bash each time a new interactive
# session is created.
#
###########################################################################

# Execute the master profile which sets up global settings

        if [ -f /project/bcs/shell/bash_profile ]; then 
	    . /project/bcs/shell/bash_profile;
#	    . /project/bcs/test/shell/bash_profile;
	fi

	# Enable Klocwork by default

#	export VSP_KLOCWORK=0
	export VSP_NO_USE_KLOCWORK=1

# Set correct path to GHS license server at MA35

	if [[ $HOSTNAME == ma35* ]]; then
	    GHS_LMHOST=@ma26nis02.am.mot.com
	fi

# VSP is using x86 Linux servers. Put any shell code specific to Linux
# in this section.

#	if [[ $OSTYPE == linux* ]]; then
#	    export LC_ALL=en_US
#	    unset MANPATH
#	fi

# Add Motorola installed software bin directories to the path

	if [ -d /opt/sfw/bin ]; then
	    PATH=$PATH:/opt/sfw/bin
	    MANPATH=$MANPATH:/opt/sfw/man
	fi

# Add KDE bin to the path

	if [ -d /opt/sfw/kde ]; then
	    PATH=$PATH:/opt/sfw/kde/bin
	    MANPATH=$MANPATH:/opt/sfw/kde/man
	fi
	
# Add WindRiver Sun libraries to path

#	if [[ $OSTYPE == solaris* ]]; then
#	    PATH=$PATH:/vobs/OS/wind/host/sun4-solaris/lib
#	fi

# WARNING: PATH has already been defined for you. If you modify the PATH
# incorrectly, you may introduce unexpected results into your builds, and/or
# may not find the correct versions of various tools. Make sure you know
# what you are doing.

# Add the GHS scripts directory to the PATH if we're in a view

if [ -n "$CLEARCASE_ROOT" ] ; then
    PATH=$PATH:/vobs/apps/scripts
fi

# If you have a bin directory, this adds it to the beginning of your
# PATH so that your versions of tools are selected first 

	if [ -d $HOME/bin ] ; then
#	    PATH=$HOME/bin:$PATH
	    PATH=$PATH:$HOME/bin
	fi

# It's considered bad practice to have the current directory in your PATH,
# however many users like having it. This should always appear at the END
# of your PATH. Comment this out if you don't want it at all.

#	PATH=$PATH:

# Which pager to use for viewing text, ie; more, less, pg, and
# any default options for your pager.

#	PAGER=${PAGER:-more} ; export PAGER ; MORE='' ; export MORE
	PAGER=${PAGER:-less} ; export PAGER ; LESS='-M' ; export LESS
#	PAGER=${PAGER:-pg} ; export PAGER ; PG='' ; export PG

# Which editor to use by default.
# EDITOR is for a line editor, VISUAL is for a full screen editor, and
# overrides the value of editor anyway.	 We'll set both to be sure.

	EDITOR=${EDITOR:-emacs} ; export EDITOR ;
	VISUAL=${EDITOR} ; export VISUAL
#	EDITOR=${EDITOR:-vi} ; export EDITOR ;
#       VISUAL='xterm -e vi' ; export VISUAL

# Which printer to use as a default.

	LPDEST=ma26p06 ; export LPDEST
	PRINTER=${LPDEST} ; export PRINTER

# ma26p02, ma26p03, ma26p05, ma26p06, ma26p07, ma26p08, ma26p09, ma26p10,
# ma26p11, ma26p15, ma26p17, ma26p19, ma26p23


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

# Pick a prompt style from the following, and uncomment it,
# or roll your own.

# Incorporate the view name into the prompt

if [ -n "$CLEARCASE_ROOT" ] ; then
#       export PS1='${CLEARCASE_ROOT##*/}@${HOSTNAME%%.*}>${PWD##*/}\$ '
    export PS1='[${PWD}]'
else
    export PS1='[${PWD}]'
#       export PS1='${HOSTNAME%%.*}>${PWD##*/}\$ '
#	export PS1='[${HOSTNAME%%.*}]${PWD##*/}\$ ' # [ma26ccs01]dirname$
#	export PS1='[${HOSTNAME%%.*}]\$ '	    # [ma26ccs01]$
#	export PS1='[${PWD}]\$ '		    # [/full/path/to/currentdir]$
#	export PS1='![${HOSTNAME%%.*}]${PWD}\$ # 52[ma26ccs01]/full/path/to/cwd$
fi

# Define the shell characteristics
# set -o option_name turns on the option, set +o option_name turns it off

	set +o noglob		# allows use of <TAB><TAB> to expand names
	set +o ignoreeof	# allow ^D to exit shell instead of "exit"
	set +o noclobber	# allows redirection (>) to overwrite files

# Define which "editor" to use for editing command line and history

	set -o emacs		# chose one of 'vi', 'emacs'

# Set Clearcase editor to older version of Emacs for speed

export WINEDITOR=emacs

# Unset the default ClearCase parallel jobs number

unset CCASE_CONC

# Set number of jobs for parallel clearmake

#export CCASE_CONC=8

# Add the Klocwork VOBS to the list of VOBS

CLEARCASE_AVOBS=$CLEARCASE_AVOBS:/vobs/klocwork:/vobs/vsp-klocwork

# Set the ClearCase color scheme for Linux

export SCHEMESEARCHPATH=~/ClearCase/%T/%N%S:/opt/rational/clearcase/config/ui/%T/%N%S

# Define any aliases below this point, or in $HOME/.bash_aliases

if [ -f ~/.bash_aliases ] ; then . ~/.bash_aliases ; fi

# Launch Klocwork Shell if we are in a ClearCase view and the Klocwork
# Shell is not running yet

#if [ -n "$CLEARCASE_ROOT" ] && [ -z $KWSHELL_RUN ] ; then

    # Make sure kwcheck is in the path
    
#    KWCHECK=$(type -P kwcheck)

#    if [ $? -eq 0 ] ; then

#	echo "kwcheck is at $KWCHECK"

    # Determine the location of the Klocwork user tool kwcheck, from
    # there we know that the .kwlp directory is up directory up

#	export KWLP_DIR=$(cd "$(dirname $KWCHECK)"; cd ..; pwd)"/.kwlp"
#	export KWPS_DIR=$(cd "$(dirname $KWCHECK)"; cd ..; pwd)"/.kwps"

#    else

#	echo "Could not locate kwcheck in $PATH"

    # Could not locate kwcheck in the PATH, this usually happens
    # when we have a new view with the default config spec
    # so we take a risk and just hard code the values

#	export KWLP_DIR="/vobs/vsp-klocwork/user/.kwlp"
#	export KWPS_DIR="/vobs/vsp-klocwork/user/.kwps"
#    fi

#    echo "Exporting KWLP_DIR=$KWLP_DIR"
#    echo "Exporting KWPS_DIR=$KWPS_DIR"

    # If the .kwlp directory does not exist then the user needs
    # to create a local Klocwork project
    
#    if [ ! -d $KWLP_DIR ] ; then
#	echo "Run 'kwcreate <branch>' to create a local Klocwork project"
#    fi
    
    # Start the Klocwork shell and point it to the local project directory

#    if [ $VSP_KLOCWORK -eq 1 ] ; then

#	KWSHELL=$(type -P kwshell)

#	if [ $? -eq 0 ] ; then

#	    echo "kwshell is at $KWSHELL"

	    # If kwshell exists, start it up

#	    kwshell --project-dir $KWLP_DIR

	    # We won't get here until the user exist the Klocwork
	    # Shell, and when they do we don't want them to have to
	    # type exit twice to get out of their ClearCase view

#	    builtin exit
#	fi
#    fi
#fi

#if [ -n "$CLEARCASE_ROOT" ] ; then

    # If we're in a view setup a bunch of Klocwork aliases to make
    # it easier for our engineers to run the tool. Mostly we are
    # setting the project directory so they don't need to do it
    # every time they run a kwcheck command.

#    alias kwshell='kwshell --project-dir $KWLP_DIR'
#    alias kwchecklistproj='kwcheck list-projects'
#    alias kwcheckrun='kwcheck run --project-dir $KWLP_DIR --jobs-num auto'
#    alias kwchecklist='kwcheck list --project-dir $KWLP_DIR'
#    alias kwchecksetstatus='kwcheck set-status --project-dir $KWLP_DIR'
#    alias kwchecksync='kwcheck sync --project-dir $KWLP_DIR'
#    alias kwcheckdisable='kwcheck disable --project-dir $KWLP_DIR'
#    alias kwcheckenable='kwcheck enable --project-dir $KWLP_DIR'
#    alias kwcheckexport='kwcheck export --project-dir $KWLP_DIR'
#    alias kwcheckimport='kwcheck import --project-dir $KWLP_DIR'
#    alias kwcheckinfo='kwcheck info --project-dir $KWLP_DIR'
#    alias kwchecklistconf='kwcheck list-conf --project-dir $KWLP_DIR'
#    alias kwcheckliststatus='kwcheck list-statuses'
#    alias kwcheckset='kwcheck set --project-dir $KWLP_DIR'

#fi

