#!/bin/sh

case "$1" in
*.man)
    nroff -Tascii -man $1 2>/dev/null
    ;;
*.man.gz)
    gunzip -c $1 2>/dev/null | nroff -Tascii -man 2>/dev/null
    ;;
*.tar.Z)
    uncompress -c $1 2>/dev/null | tar -tf - 2>/dev/null
    ;;
*.tar.z)
    uncompress -c $1 2>/dev/null | tar -tf - 2>/dev/null
    ;;
*.Z)
    uncompress -c $1 2>/dev/null
    ;;
*.tgz)
    gunzip -c $1 2>/dev/null | tar -tf - 2>/dev/null
    ;;
*.tar.gz)
    gunzip -c $1 2>/dev/null | tar -tf - 2>/dev/null
    ;;
*.tar.bz2)
    bunzip2 -c $1 2>/dev/null | tar -tf - 2>/dev/null
    ;;
*.gz)
    gunzip -c $1 2>/dev/null
    ;;
*.tar)
    tar -tf $1 2>/dev/null
    ;;
*.zip)
    unzip -l $1 2>/dev/null
    ;;
*.bz2)
    bunzip -c $1 2>/dev/null
    ;;
esac
