# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

alias x=xdg-open
alias fd=fdfind
alias python=python3

shopt -s globstar

export VISUAL=vim
export EDITOR=micro
export PAGER=less

export LESS=FRX
eval "$(lesspipe)"
export LESSOPEN="| /usr/bin/lesspipe %s";
export LESSCLOSE="/usr/bin/lesspipe %s %s";

#export CDPATH=.
#cd_() { cd $@; [[ "$CDPATH" != *"$(pwd)"* ]] && (export CDPATH=$CDPATH:$(pwd); echo "CDPATH=$CDPATH" >> ~/.profile; ) }
#alias exit="echo $CDPATH >> ~/profile; exit;"
bind -x '"\C-g":"read f < <(locate . | fzy) && printf echo -e "\033[2K \e[5n"'
bind -x '"\C-h":"{ apropos . ; [ -f ~/bash.txt ] && cat bash.txt; } | fzy"'

#command -v __git_ps1 >/dev/null 2>&1 && export PS1="$PS1\n\[\033[1;34m\]└─ ▶$(__git_ps1):\[\033[0m\]"
function ff() { find . -name $2 | fzy | xargs $1; }
function hh() { cat bash_history | fzy; }
function fo() { first=$(fzy) && second=$(fzy) && $1 $first $second; }
function ft() { find . -type f -name $1 -exec sh -c 'less {} | grep --with-filename $2' ; }
export NNN_PLUG='f:fzcd;h:fzhist;m:mocplay;d:diffs;t:nmount;v:imgview;p:-!less -iR $nnn*;s:-!sudo -E vim $nnn*;l:-!git log;h:-!hx $nnn*;g:-!git diff;r:rg'
