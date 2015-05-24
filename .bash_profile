# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

#umask 022

# include .bashrc if it exists
if [[ -f ~/.bashrc ]]; then
    . ~/.bashrc
fi

# set PATH so it includes user's private bin if it exists
if [[ -d ~/bin ]]; then
    PATH=~/bin:"${PATH}"
fi

# vim: fenc=utf-8:ff=unix:ft=help:norl:et:ci:pi:sts=0:sw=8:ts=2:tw=80:syntax=sh:
