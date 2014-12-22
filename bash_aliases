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
alias quiltdiff='quilt diff --diff=p4merge'
alias rm='rm -i'
alias rmrf='rm -rf'
alias sshx='ssh -X'
alias sshroot='ssh -l root'
alias sshkvm='ssh -l sysadmin'
alias type='type -all'
alias vncserver='vncserver -geometry 1850x1080'
alias vnc4server='vnc4server -geometry 1850x1080'

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
    # Make the active directory if it does not exist

    mkdir -p ~/.ssh/active

    # Loop through the different types of keys

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

ssh_updatekeys()
{
    # Loop through the different types of keys

    for type in $KEY_TYPES
    do
	KEYNAME=$USER-$type-`date +'%Y-%m-%d'`
	echo "Updating $type key in $KEYNAME"
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

# Function to push SSH keys from host to target

ssh_pushkeys()
{
   for type in $KEY_TYPES
   do
       echo "Pushing $type keys to $1"
       scp ~/.ssh/$type/* $USER@$1:~/.ssh/$type/
   done

   # Set the permissions for the various SSH files

#    chmod -R 700 ~/.ssh
#    chmod go-rwx ~/.ssh/*
#    chmod 644 ~/.ssh/known_hosts

    # Append the new key to the local authorized_keys file

#    cat ~/.ssh/active/internal.pub >> ~/.ssh/authorized_keys
}

# Function to pull SSH keys from target to host

ssh_pullkeys()
{
   for type in $KEY_TYPES
   do
       echo "Pulling $type keys from $1"
       scp $USER@$1:~/.ssh/$type/* ~/.ssh/$type/
   done
}

# Check if Perforce is installed and load Perforce aliases and functions

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
   alias p4sync='p4 sync ...'

   # Aliases below try to map Clearcase terminology/syntax to Perforce 

   # Open aka 'checkout' a file for editing

   alias p4co='p4 edit'

   # List opened aka 'checkedout' files

   alias p4lsco='p4 opened ...'

   # Function to make a Perforce branch

   function p4mkbr()
   {
	p4 sync ...
        p4 integrate -i -1 -d $1 $2
	p4 resolve
        p4 opened ...
   }
   
   function p4syncall()
   {
	OLD=$PWD
	cd ~/projects
	for D in `find ~/projects -mindepth 1 -maxdepth 1 -type d`
	do
             cd $D
             p4 sync ...
        done
        cd $OLD
   }

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

# Upload and install a kernel to a server

function kinstall()
{
	if [ -f $1 ]; then

	   # Copy the kernel to the server

	   scp $1 root@$2:/var/tmp

     	   # Copy the install script to the test machine

     	   scp ~/projects/sandbox/johunt/install-kernel.sh root@$2:/var/tmp

     	   # Login to the test machine, install the kernel, and reboot

     	   ssh root@$2 "cd /var/tmp; ./install-kernel.sh $1"

	else
	   echo "File $1 does not exist\n"
        fi
}

# Prep a kernel for private build / modifications

function kprep()
{
	dir=${1%.tar.*}
	ext=${1##*.}
	rm -rf $dir

	if [ $ext == "xz" ]
	then 
	     xzcat -cd $1 | tar -xv
	fi

	if [ $ext == "bz2" ]
	then
	     bzcat -cd $1 | tar -xv
        fi
}

# Function to download kernel files

function wgetkernel()
{
	wget ftp://ftp.kernel.org/pub/linux/kernel/v3.x/linux-$1.tar.xz
	wget ftp://ftp.kernel.org/pub/linux/kernel/v3.x/linux-$1.tar.sign
}

function wgetpatch()
{
	wget ftp://ftp.kernel.org/pub/linux/kernel/v3.x/patch-$1.xz
	wget ftp://ftp.kernel.org/pub/linux/kernel/v3.x/patch-$1.sign
}

# Function to open up VNC access in iptables

function iptables-enable-vnc()
{
	sudo iptables -A INPUT -p tcp --dport 5901 -j ACCEPT
	sudo iptables -A INPUT -p udp --dport 5901 -j ACCEPT
}

# Function to refresh kernel configuration patches

function krefresh()
{
	for x in akamai/config.akamai-*;
	do cp $x .config;
	make oldconfig; cp .config $x;
	done
}