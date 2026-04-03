# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
alias pi='ssh pi@78.202.39.55'
alias server='ssh lion@192.168.1.7'

# Show files with bat syntax highlighting without opening a pager when available.
cat() {
  if [[ -t 1 ]] && command -v bat >/dev/null 2>&1; then
    bat --paging=never --style=header,grid "$@"
  else
    command cat "$@"
  fi
}

# Print the current directory and copy it to the Wayland clipboard when available.
pwd() {
  if [[ -n $WAYLAND_DISPLAY ]] && command -v wl-copy >/dev/null 2>&1; then
    builtin pwd "$@" | tee >(wl-copy >/dev/null)
  else
    builtin pwd "$@"
  fi
}

# Use duf when available, otherwise fall back to df.
df() {
  if command -v duf >/dev/null 2>&1; then
    duf "$@"
  else
    command df "$@"
  fi
}

#alias for cheat.sh
cheat() { curl -sL "https://cheat.sh/$1"; }

# Make cd use exact paths first, then fall back to zoxide jumps.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"

  cd() {
    if (( $# == 0 )); then
      builtin cd ~ || return
    elif [[ -d $1 ]]; then
      builtin cd "$1" || return
    else
      z "$@" || return
    fi

    if command -v eza >/dev/null 2>&1; then
      eza -lah --group-directories-first --icons=auto
    else
      command ls -lah
    fi
  }
fi

#######################################################
# GENERAL ALIAS'S
#######################################################
# To temporarily bypass an alias, we precede the command with a \
# EG: the ls command is aliased, but to use the normal ls command you would type \ls

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Search files in the current folder
alias f="find . | grep "

# Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

# Alias's for multiple directory listing commands
alias la='ls -Alh' # show hidden files
#alias ls='ls -aFh --color=always' # add colors and file type extensions
alias lx='ls -lXBh'              # sort by extension
alias lk='ls -lSrh'              # sort by size
alias lc='ls -ltcrh'             # sort by change time
alias lu='ls -lturh'             # sort by access time
alias lr='ls -lRh'               # recursive ls
alias lt='ls -ltrh'              # sort by date
alias lm='ls -alh |more'         # pipe through 'more'
alias lw='ls -xAh'               # wide listing format
alias ll='ls -Fls'               # long listing format
alias labc='ls -lap'             # alphabetical sort
alias lf="ls -l | grep -E -v '^d'" # files only
alias ldir="ls -l | grep -E '^d'"  # directories only
alias lla='ls -Al'               # List and Hidden Files
alias las='ls -A'                # Hidden Files
alias lls='ls -l'                # List

# Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
#tree but only for directories. Add -L x to limit to x deep in the sub-directories
alias treed='tree -CAFda -I ".git"'
alias mountedinfo='df -hT'

# Alias's for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

alias docker-clean=' \
  docker container prune -f ; \
  docker image prune -f ; \
  docker network prune -f ; \
  docker volume prune -f '

# Searches for text in all files in the current folder
ftext() {
  # -i case-insensitive
  # -I ignore binary files
  # -H causes filename to be printed
  # -r recursive search
  # -n causes line number to be printed
  # optional: -F treat search term as a literal, not a regular expression
  # optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
  grep -iIHrn --color=always "$1" . | less -r
}

# Copy file with a progress bar
cpp() {
  set -e
  strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
    awk '{
        count += $NF
        if (count % 10 == 0) {
            percent = count / total_size * 100
            printf "%3d%% [", percent
            for (i=0;i<=percent;i++)
                printf "="
            printf ">"
            for (i=percent;i<100;i++)
                printf " "
            printf "]\r"
        }
    }
    END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

# IP address lookup
alias whatismyip="whatsmyip"
function whatsmyip() {
  # Internal IP Lookup.
  if command -v ip &>/dev/null; then
    echo -n "Internal IP: "
    ip addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
  else
    echo -n "Internal IP: "
    ifconfig wlan0 | grep "inet " | awk '{print $2}'
  fi

  # External IP Lookup
  echo -n "External IP: "
  curl -s ifconfig.me
}

lazyg() {
  git add .
  git commit -m "$1"
  git push
}

alias gs='git status'

export TLDR_OPTIONS=both
