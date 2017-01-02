# ~/.bashrc: executed by bash(1) for interactive shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Basic variable setups for PATH, etc.  Sourced by .bash_profile for
# interactive shells.
PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin
if [ `uname` == "Darwin" ]; then
    PATH=$PATH:/Applications/Xcode.app/Contents/Developer/usr/bin:/opt/hsi/bin
fi
PAGER=`which less`
EDITOR=vim
LESSOPEN='|$HOME/dotfiles/lesspipe.sh %s'
CVS_RSH=ssh
BASHRC_SEEN=true
#LD_PRELOAD=libsdp.so
export PATH PAGER EDITOR LESSOPEN CVS_RSH BASHRC_SEEN MPI_HOME LD_LIBRARY_PATH #LD_PRELOAD #EF_STRIPE_NETMASK
# If running interactively, include the bash_profile.
[ ! -z "$PS1" ] && . ~/.bash_profile

