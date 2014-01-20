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
alias sshlab='ssh -X -l root'
alias sshroot='ssh -X -l root'
alias type='type -all'
alias vncserver='vncserver -geometry 1500x1000'
alias vnc4server='vnc4server -geometry 1500x1000'

# Operating system specfic code

case "$OSTYPE" in
    solaris*)
	echo "Running on Solaris"
	;;
    darwin*)
	echo "Running on Mac OS"
	alias ls='ls -F -G'
	alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'
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

# Variable to hold different types of Akamai SSH keys

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

    # Set the permissions for the various SSH files according to what
    # the Akamai guidelines suggest

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

