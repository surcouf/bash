# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Print nickname for git/hg/bzr/svn version control in CWD
# Optional $1 of format string for printf, default "(%s) "
# Source: http://blog.grahampoulter.com/2011/09/show-current-git-bazaar-or-mercurial.html
function be_get_branch () {
  local dir="${PWD}"
  local vcs
  local nick
  while [[ "$dir" != "/" ]]; do
    for vcs in git hg svn bzr; do
      if [[ -d "$dir/.$vcs" ]] && hash "$vcs" &>/dev/null; then
        case "$vcs" in
          git)
            __git_ps1 "${1:-(git::%s) }"
            return
          ;;
          hg)
            nick=$(hg branch 2>/dev/null)
          ;;
          svn)
            repo=$(LC_ALL=C svn info 2>/dev/null \
                  | sed -ne 's/Repository Root: //p')
            nick=${repo##*/}
          ;;
          bzr)
            local conf="${dir}/.bzr/branch/branch.conf" # normal branch
            if [[ -f "$conf" ]]; then
              nick=$(grep -E '^nickname =' "$conf" | cut -d' ' -f 3)
            fi
            conf="${dir}/.bzr/branch/location" # colo/lightweight branch
            if [[ -z "$nick" ]]; then
              if [[ -f "$conf" ]]; then
                nick="$(basename "$(< $conf)")"
              fi
            fi
            if [[ -z "$nick" ]]; then
              nick="$(basename "$(readlink -f "$dir")")"
            fi
          ;;
        esac
        if [[ -n "$nick" ]]; then
          printf "${1:-($vcs::%s) }" "$nick"
        else
          printf "%s" ""
        fi
        return 0
      fi
    done
    dir="$(dirname "$dir")"
  done
}

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Define your own aliases here ...
if [[ -f ~/.bash_aliases ]]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [[ -f /etc/bash_completion ]]; then
    . /etc/bash_completion
fi
# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" -a -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
# ANSI color codes
RS="\[\033[00m\]"   # reset
HC="\[\033[1m\]"    # hicolor
UL="\[\033[4m\]"    # underline
INV="\[\033[7m\]"   # inverse background and foreground
FBLK="\[\033[30m\]" # foreground black
FRED="\[\033[31m\]" # foreground red
FGRN="\[\033[32m\]" # foreground green
FYEL="\[\033[33m\]" # foreground yellow
FBLE="\[\033[34m\]" # foreground blue
FMAG="\[\033[35m\]" # foreground magenta
FCYN="\[\033[36m\]" # foreground cyan
FWHT="\[\033[37m\]" # foreground white
BBLK="\[\033[40m\]" # background black
BRED="\[\033[41m\]" # background red
BGRN="\[\033[42m\]" # background green
BYEL="\[\033[43m\]" # background yellow
BBLE="\[\033[44m\]" # background blue
BMAG="\[\033[45m\]" # background magenta
BCYN="\[\033[46m\]" # background cyan
BWHT="\[\033[47m\]" # background white

case "${TERM}" in
  xterm*|rxvt*|sshd|gnome-terminal|screen)
    PS1="[${HC}${FGRN}\u${RS}@${HC}${FRED}\h${RS} ${HC}${FBLE}\t${RS} ${HC}\$(be_get_branch \"\$2\")${FCYN}\W${RS}]\$ "
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
  ;;
  *)
    PS1='[\u@\h \t $(be_get_branch "$2")\W]\$ '
  ;;
esac


if [[ -n "${debian_chroot}" ]]; then
  PS1='[${debian_chroot:+($debian_chroot)}'${PS1}
fi

# less
LESS_TERMCAP_mb=$'\E[01;31m'
LESS_TERMCAP_md=$'\E[01;31m'
LESS_TERMCAP_me=$'\E[0m'
LESS_TERMCAP_so=$'\E[01;44;33m'
LESS_TERMCAP_se=$'\E[0m'
LESS_TERMCAP_us=$'\E[01;32m'
LESS_TERMCAP_ue=$'\E[0m'

LESS="-FSRXI"

# vim: fenc=utf-8:ff=unix:ft=help:norl:et:ci:pi:sts=0:sw=8:ts=2:tw=80:syntax=sh:
