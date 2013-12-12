# Application and utility aliases

if [[ $OSTYPE == solaris* ]]; then
	if [ -f /opt/sfw/bin/ls ]; then
	alias ls='/opt/sfw/bin/ls -F --color=auto'
	fi
else
	alias ls='ls -F --color=auto'
fi

alias md5='md5sum'

# Word count with parameters to count line numbers

alias lc='wc -l'

# Octal dump configure to do hex dump

alias hexdump='od -Ax -tx1 -v'
alias hd='od -Ax -tx1 -v'

# Long listing

alias lsl='ls -lag'

alias cb='cbrowser'
alias em='emacs'
alias oldem='emacs-20.5'
alias pt='ps -u $USER'
alias dir='ls'
alias rm='rm -i'
alias rmrf="'rm' -rf"
alias type='type -all'
alias vncserver='vncserver -geometry 1890x1000'
alias egrep='egrep --color'
alias egrep='grep --color'
alias dblink='dblink -auto_translate'

# Less with line numbers

alias lessl='less -N'

# Perform X-11 forwarding when using SSH

alias ssh='ssh -X'

# Define a repeat function, for example repeat 10 echo foo

repeat()
{
	local count="$1" i;
	shift;
	for i in $(seq 1 "$count");
	do
	eval "$@";
	done
}

# Helper function for repeat function

seq()
{
	local lower upper output;
	lower=$1 upper=$2;

	if [ $lower -ge $upper ]; then
	return;
	fi
	
	while [ $lower -le $upper ];
	do
	echo -n "$lower "
	lower=$(($lower +1))
	done
	echo "$lower"
}

# ClearCase aliases

alias ct='cleartool'
alias ctsv='cleartool setview'
alias ctls='cleartool ls -l'
alias ctcatcs='cleartool catcs'
alias ctsetcs='cleartool setcs'
alias ctedcs='cleartool edcs'

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

# ClearCase function to diff an element against the zero version on the branch

function ctdiffz()
{
	cleartool diff -graphical $(cleartool describe -fmt "%n" $1 | sed 's%[0-9]*$%0%') $1
}

# ClearCase function to diff an element with a specific label against its predecessor

function ctdifflbl()
{
	cleartool diff -graphical -predecessor $2@@/$1 &
	cleartool diff -graphical -pred $2 &
}


# Clearcase VOBs directory aliases

alias vobs='cd /vobs'
alias os='cd /vobs/OS'
alias oem='cd /vobs/oem'
alias ghs='cd /vobs/ghs'
alias apps='cd /vobs/apps'
alias cards='cd /vobs/cards'
alias drivers='cd /vobs/drivers'
alias tools='cd /vobs/tools'
alias vrx='cd /vobs/cards/vrx'

# Project directory aliases

alias proj='cd /vobs/OS/proj'
alias archive='cd /vobs/OS/proj/archive'
alias srm4='cd /vobs/OS/proj/srm4'
alias srm10='cd /vobs/OS/proj/srm10'
alias hsim4='cd /vobs/OS/proj/hsim4'
alias hsim10='cd /vobs/OS/proj/hsim10'

# Motorola source code directory aliases

alias ard='cd /vobs/apps/ard'
alias mac='cd /vobs/apps/mac'
alias agent='cd /vobs/OS/epilogue/agent'
alias cli='cd /vobs/OS/cli'
alias crm='cd /vobs/OS/crm/crm'
alias lbm='cd /vobs/apps/lbm'

# WindRiver source code directory aliases

alias netwrs='cd $WIND_BASE/target/src/netwrs'
alias netinet='cd $WIND_BASE/target/src/netinet'
alias wind='cd $WIND_BASE'
alias target='cd $WIND_BASE/target'
alias arch='cd $WIND_BASE/target/src/arch/ppc'

# Aliases for setting build environment

alias srm4env='source /vobs/OS/proj/srm4/env.bash'
alias srm10env='source /vobs/OS/proj/srm10/env.bash'
alias hsim4env='source /vobs/OS/proj/hsim4/env.bash'
alias hsim10env='source /vobs/OS/proj/hsim10/env.bash'

# Alias for copying archive.Z to public FTP directory

alias cpzftp='cp /vobs/OS/proj/archive/bin/archive.srm* ~ftp/pub/$USER/; echo "Copied archive files to ~ftp/pub/$USER/"'

# Aliases for Clearmake

alias cm='clearmake'
alias cmj='clearmake -J 8'

# Aliases for building the entire archive with a serial clearmake

alias cmall='archive; cm all; cpzftp'
alias cmall4='archive; cm all4; cpzftp'
alias cmall10='archive; cm all10; cpzftp'

# Aliases for building the entire archive with a parallel clearmake

alias cmjall='archive; cmj all; cpzftp'
alias cmjall4='archive; cmj all4; cpzftp'
alias cmjall10='archive; cmj all10; cpzftp'

# Aliases for building individual cards with a serial clearmake

alias cmsrm4='archive; cm srm4; cpzftp'
alias cmsrm10='archive; cm srm10; cpzftp'
alias cmhsim4='archive; cm hsim4; cpzftp'
alias cmhsim10='archive; cm hsim10; cpzftp'
alias cmdtx='archive; cm dtx; cpzftp'
alias cmdrx='archive; cm drx; cpzftp'
alias cmvrx='archive; cm vrx; cpzftp'

# Aliases for building individual cards with a parallel clearmake

alias cmjsrm4='archive; cmj srm4; cpzftp'
alias cmjsrm10='archive; cmj srm10; cpzftp'
alias cmjhsim4='archive; cmj hsim4; cpzftp'
alias cmjhsim10='archive; cmj hsim10; cpzftp'
alias cmjdtx='archive; cmj dtx; cpzftp'
alias cmjdrx='archive; cmj drx; cpzftp'
alias cmjvrx='archive; cmj vrx; cpzftp'

# Aliases for using Multi debugger on cards

alias multisrm4='srm4; dblink bin/vxWorks.elf; multi vxWorks.elf'
alias multisrm10='srm10; dblink bin/vxWorks.elf; multi vxWorks.elf'
alias multihsim4='hsim4; dblink bin/vxWorks.elf; multi vxWorks.elf'
alias multihsim10='hsim10; dblink bin/vxWorks.elf; multi vxWorks.elf'

# Aliases for building Cscope databases

alias cmjcs='cd /vobs/OS/proj/cscope; clearmake -J $PARALLEL all; touch *'
alias cmcs='cd /vobs/OS/proj/cscope; clearmake all; touch *'

# Card directory aliases

alias rx48='cd /vobs/cards/rx48'
alias tx='cd /vobs/cards/tx'
alias vrx='cd /vobs/cards/vrx'
alias p4080ds='cd /vobs/cards/P4080DS'

# Viewtool aliases

alias vtls='vt lsview'

# Klocwork aliases

function kwbuildproj()
{
    kwbuildproject --verbose --color --tables-directory $1 --strict --host ma35kws01 --project $2 --jobs-num auto --force $3
}

# gbuild aliases

alias gbuildvrx='gbuild -top /vobs/cards/vrx/default.gpj'
alias gbuildrx='gbuild -top /vobs/cards/rx48/default.gpj'
alias gbuildtx='gbuild -top /vobs/cards/tx/default.gpj'
alias gbuildp4080ds='gbuild -top /vobs/cards/P4080DS/default.gpj'

# Hostname aliases

alias ssh_acme='ssh -X -Y labuser@vsp-acme-01'

