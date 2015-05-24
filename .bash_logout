# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy
if [[ ${SHLVL} -eq 1 ]]; then
    if [[ -x /usr/bin/clear_console ]]; then
      /usr/bin/clear_console -q
    fi
fi

# vim: fenc=utf-8:ff=unix:ft=help:norl:et:ci:pi:sts=0:sw=8:ts=2:tw=80:syntax=sh:
