# .bashrc
#
# This is run by bash for interactive and (in later versions) non-interactive
# shells alike.

# Basic variable setups for PATH, etc.  Sourced by .bash_profile for
# interactive shells.
PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin
if [ `uname` == "Darwin" ]; then
    PATH=$PATH:/Applications/Xcode.app/Contents/Developer/usr/bin:/opt/hsi/bin
fi
EDITOR=vim
CVS_RSH=ssh
BASHRC_SEEN=true
export PATH EDITOR CVS_RSH BASHRC_SEEN 

# If this isn't interactive, abort before we set variables that could
# interfere with shell commands
[ -z "$PS1" ] && return

PAGER=`which less`
LESSOPEN='|$HOME/dotfiles/lesspipe.sh %s'
export LESSOPEN PAGER
