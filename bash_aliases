echo "Executing $BASH_SOURCE"

# General command aliases 

alias cb='cbrowser'
alias dir='ls'
alias em='emacs'
alias grep='grep --color=auto'
alias hd='hexdump'
#alias hd='od -Ax -tx1 -v'
#alias hexdump='od -Ax -tx1 -v'
alias lc='wc -l'
alias lessl='less -N'
alias pt='ps -u $USER'
alias rm='rm -i'
alias rmrf='rm -rf'
#alias rmrf="'rm' -rf"
alias sshx='ssh -X'
alias sshroot='ssh -l root'
alias sshkvm='ssh -l sysadmin'
alias type='type -all'
alias vncserver='vncserver -geometry 1500x1000'
alias vnc4server='vnc4server -geometry 1500x1000'

# Directory aliases

alias projects='cd ~/projects'
alias akakernel='cd ~/projects/akakernel/'
alias lkc='cd /projects/kernel'
alias oird='cd /projects/alsi6'

# Operating system specfic code

case "$OSTYPE" in
    solaris*)
	echo "Running on Solaris"
	;;
    darwin*)
	echo "Running on Mac OS"
	alias ls='ls -F -G'
	alias emacs='open -a /Applications/Emacs.app/Contents/MacOS/Emacs'
	;;
    linux*)
	echo "Running on Linux"
	alias ls='ls -F --color=auto'
	alias md5='md5sum'
	;;
    bsd*)
	echo "Running on BSD"
	;;
    win*)
	echo "Running on Windows"
	;;
    cgywin*)
	echo "Running on Cgywin"
	;;
    *)
	echo "Running on unknown operating system"
	;;
esac

# Function to repeat a command N times, eg repeat 10 <command>

repeat()
{
    n=$1
    shift
    while [ $(( n -= 1 )) -ge 0 ]
    do
        "$@"
    done
}

# SSH related functions and aliases

function sshlab()
{
#	scp ~/.bashrc root@$1:/tmp/$USER-bashrc	
#	scp ~/.bash_aliases root@$1:/tmp/$USER-bash_aliases	
	ssh -l root ${*:1} "cat > ~/.bashrc_remote" < ~/.bashrc_remote
	ssh -l root ${*:1} "cat > ~/.bash_aliases_remote" < ~/.bash_aliases_remote
	ssh -l root -t ${*:1} 'bash --rcfile <(echo "source /etc/profile; source ~/.bashrc_remote; source ~/.bash_aliases_remote"); rm ~/.bash*remote'
}

# Variable to hold different types of SSH keys

KEY_TYPES="internal external deployed"

# Function to make SSH keys

ssh_mkkeys()
{
    mkdir -p ~/.ssh/active

    for type in $KEY_TYPES
    do
	KEYNAME=$USER-$type-`date +'%Y-%m-%d'`
	echo "Generating $type key in $KEYNAME"
	mkdir -p ~/.ssh/$type
	ssh-keygen -t rsa -b 2048 -C $KEYNAME -f ~/.ssh/$type/$KEYNAME
	ln -sf ~/.ssh/$type/$KEYNAME ~/.ssh/active/$type
	ln -sf ~/.ssh/$type/$KEYNAME.pub ~/.ssh/active/$type.pub
    done

    # Set the permissions for the various SSH files

    chmod -R 700 ~/.ssh
    chmod go-rwx ~/.ssh/*
    chmod 644 ~/.ssh/known_hosts

    # Append the new key to the local authorized_keys file

    cat ~/.ssh/active/internal.pub >> ~/.ssh/authorized_keys
}

# Function to add SSH keys to agent

ssh_addkeys()
{
    for type in $KEY_TYPES
    do
	echo "Adding $type key to keychain"
	ssh-add ~/.ssh/active/$type
    done
}

# Check if Perforce is installed and load ClearCase aliases and functions

hash p4 &> /dev/null

if [ $? -eq 0 ]; then
   
   # p4 is present so Perforce must be installed

   alias p4client='p4 client'
   alias p4edit='p4 edit'
   alias p4add='p4 add'
   alias p4del='p4 delete'
   alias p4revert='p4 revert'
   alias p4diff='p4 diff'
   alias p4submit='p4 submit'
fi

# Check if ClearCase is installed and load ClearCase aliases and functions

hash cleartool &> /dev/null

if [ $? -eq 0 ]; then
   
   # cleartool is present so ClearCase must be installed

   # Aliases for Clearmake

   alias cm='clearmake'
   alias ct='cleartool'

   alias ctcatcs='cleartool catcs'
   alias ctsetcs='cleartool setcs'
   alias ctedcs='cleartool edcs'
   alias ctsv='cleartool setview'
   alias ctls='cleartool ls -l'
   alias ctmyco='cleartool lscheckout -short -cview -avobs'
   alias ctco='cleartool checkout -unreserved'
   alias ctcoall='cleartool checkout -unreserved -c'
   alias ctunco='cleartool uncheckout -keep'
   alias ctuncoall='ctunco `ctmyco`'
   alias ctci='cleartool checkin'
   alias ctciall='cleartool checkin -nc `cleartool lsco -avobs -cview -short`'
   alias ctcialli='cleartool checkin -ide -nc `cleartool lsco -avobs -cview -short`'
   alias ctdiff='cleartool diff -graphical -predecessor'
   alias ctdiffco='cleartool lscheckout -short -cview -avobs | xargs -n 1 cleartool diff -graphical -predecessor'
   alias ctlv='cleartool lsvtree -graphical'
   alias ctfm='cleartool findmerge'
   alias ctfmver='cleartool findmerge -avobs -fversion'

   # ClearCase function to remove a branch

   function ctrmbr()
   {
	 cleartool rmtype -rmall -force brtype:$1
   }

   # ClearCase function to diff an element against the zero version on
   # the branch

   function ctdiffz()
   {
	cleartool diff -graphical $(cleartool describe -fmt "%n" $1 | sed 's%[0-9]*$%0%') $1
   }

   # ClearCase function to diff an element with a specific label against
   # its predecessor

   function ctdifflbl()
   {
	cleartool diff -graphical -predecessor $2@@/$1 &
	cleartool diff -graphical -pred $2 &
   }
fi


