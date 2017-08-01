# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/login.defs
#umask 022

# the rest of this file is commented out.

# set variable identifying the chroot you work in
#if [ -f /etc/debian_chroot ]; then
#  debian_chroot=$(cat /etc/debian_chroot)
#fi

# If I'm not user "shuey", that should show up in my prompt.
if [ "x${USER}x" != "shuey" -a "x${USER}x" != "xx" ]; then
    alt_user=$USER
fi

# Set up prompts with a terminal-specific command (borrowed from RHE)
case $TERM in
    xterm*)
	export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
	;;
    screen)
	export PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\033\\"'
	;;
    *)
	# Must be some kind of dumb terminal
	unset PROMPT_COMMAND
	;;
esac
export PS1a='\h:\w\$ '
export PS1b='\u@\h\$ '
export PROMPT_TYPE='default'
export PS1="${PS1a}"

# Bash options
set -o vi
shopt -s checkwinsize

# Special defines, if I'm on a Linux box
if [ `uname` == 'Linux' -o `uname` == 'OpenBSD' -o `uname` == 'FreeBSD' ]; then
    PS_LIST_ALL='ps auxw'
else
    PS_LIST_ALL='ps -eaf'
fi

# include .bashrc if it exists and we haven't seen it before (since bashrc
# can now occaisionally include bash_profile)
if [ -f ~/.bashrc -a "x${BASHRC_SEEN}x" == "xx" ]; then
    . ~/.bashrc
fi

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

# do the same with MANPATH
#if [ -d ~/man ]; then
#    MANPATH=~/man:"${MANPATH}"
#    export MANPATH
#fi


# Really handy functions n' things.

# pathfix() will make sure there are no duplicate entries in my PATH.
# Please note that this requires perl.  An alternate, non-perl
# implementation has also been provided.
if which perl > /dev/null 2> /dev/null; then
    pathfix()
    {
        export PATH=`perl -e '
@path = split /:/, $ENV{PATH};
foreach $pathelem (@path) {
    if( ! exists $hash{$pathelem} ) {
        $outstring .= ":" . $pathelem;
        $hash{$pathelem} = 1;
    }
}
$outstring =~ s/^://;
print $outstring;
'`
    }
else
    pathfix()
    {
        echo "Warning: non-perl implementation of pathfix selected!\n"
        NEWPATH=''
        for dir in `echo $PATH | sed 's/:/ /g'`; do
            if [[ x$NEWPATH = x ]]; then
                NEWPATH=$dir
            else
                if [ x$NEWPATH = x`echo $NEWPATH | grep -v $dir` -a $dir != "." ]; then
                    NEWPATH=$NEWPATH:$dir
                fi
            fi
        done
        export PATH=$NEWPATH
        unset NEWPATH
    }
fi

pskill()
{
    pid=$(${PS_LIST_ALL} | grep $1 | grep -v grep | awk '{ print $2 }')
    if [ "x${pid}" != "x" ]; then
        echo "Killing $1 (process ${pid})"
        kill -9 ${pid}
        echo "Slaughtered."
    else
        echo "No such process."
    fi
}

swprompt()
{
    if [ $PROMPT_TYPE = 'default' ]; then
        export PS1=${PS1b}
        export PROMPT_TYPE='x-thing'
        echo "Prompt changed to x-thing prompt."
    else
        export PS1=${PS1a}
        export PROMPT_TYPE='default'
        echo "Prompt changed to the default prompt."
    fi
}

ggrep()
{
    ${PS_LIST_ALL} | grep $1 | grep -v grep
}

findagent()
{
    SSH_AGENT_PID=`${PS_LIST_ALL} | grep ^$USER | grep ssh-agent | grep -v grep | awk '{ print $2 }' | tail -n 1`
    if [ "x$SSH_AGENT_PID" != "x" ]; then
        export SSH_AGENT_PID
        SSH_AUTH_SOCK=`/bin/ls /tmp/ssh-$USER/*agent* 2>/dev/null`
        if [ x$SSH_AUTH_SOCK = x ]; then
            SSH_AUTH_SOCK=`/bin/ls -c \`find /tmp/ssh-* -user $USER -name 'agent.*'\` | head -1`
        fi
        export SSH_AUTH_SOCK
        echo "Agent pid is $SSH_AGENT_PID, socket is $SSH_AUTH_SOCK"
    else
        echo "No agent available.  Creating an ssh-agent for you."
        rm -rf /tmp/ssh-$USER/*
        eval `ssh-agent`
    fi
}

loseagent()
{
    unset SSH_AUTH_SOCK
    unset SSH_AGENT_PID
    echo "No ssh-agent for you!"
}

nocolor()
{
    unset LS_COLORS
    alias ls='ls -F'
}

color()
{
    if [ `uname` == "Linux" ]; then
	eval `dircolors -b`
	alias ls='ls -F --color=auto'
    else
	alias ls='ls -F -G'
    fi
}

# Include common aliases
. ~/.aliasrc

# Pull in a local config, if any.
if [ -f ~/.localrc ]; then
    . ~/.localrc
fi

# Finally, now that _everything_ is defined, fix the path and turn on colors.
color
pathfix
