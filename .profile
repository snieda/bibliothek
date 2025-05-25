# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [[ ! $(alias ll) ]]; then
	if [ -n "$BASH_VERSION" ]; then
	    # include .bashrc if it exists
	    if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	    fi
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

# save history after each command (otherwise tmux will do this only on exit)
PROMPT_COMMAND="history -a; history -c; history -r"

alias x=xdg-open
alias fd=fdfind
alias python=python3
#alias bat="batcat --theme Nord" 

shopt -s globstar
shopt -s expand_aliases

export LESS=FRX
eval "$(lesspipe)"
export LESSOPEN="| /usr/bin/lesspipe %s";
export LESSCLOSE="/usr/bin/lesspipe %s %s";

#export CDPATH=.
#cd_() { cd $@; [[ "$CDPATH" != *"$(pwd)"* ]] && (export CDPATH=$CDPATH:$(pwd); echo "CDPATH=$CDPATH" >> ~/.profile; ) }
#alias exit="echo $CDPATH >> ~/.profile; exit;"
alias gg='elinks https://www.google.com/search?q=$(read -ep "Search in Google: "; echo $REPLY)'

bind -x '"\C-g":"read f < <(tree -idf ~ | fzy -l 30) | xsel -i && echo -en "\033[2K \e[5n $(xsel -o)"'
bind -x '"\C-h":"{ apropos . ; [ -f ~/bash.txt ] && cat bash.txt; } | fzy"'
bind -x '"\C-k":"gg"'

#command -v __git_ps1 >/dev/null 2>&1 && export PS1="$PS1\n\[\033[1;34m\]└─ ▶$(__git_ps1):\[\033[0m\]"
function ff() { find . -name $2 | fzy | xargs $1; }
function hh() { cat bash_history | fzy; }
function fo() { first=$(fzy) && second=$(fzy) && $1 $first $second; }
function ft() { find . -type f -name $1 -exec sh -c 'less {} | grep --with-filename $2' ; }

export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export NNN_PLUG='f:fzcd;h:fzhist;m:mocplay;d:diffs;t:nmount;v:imgview;p:-!less -iR $nnn*;s:-!sudo -E vim $nnn*;l:-!git log;h:-!hx $nnn*;g:-!git diff;r:rg'
export MVND_HOME=~/mvnd
export VIRTUAL_ENV=~/.config/python3-venv
export VISUAL=vim
export EDITOR=micro
export VIEWER=bat
export PAGER=bat

source $VIRTUAL_ENV/bin/activate

source $MVND_HOME/bin/mvnd-bash-completion.bash

#PATH="$MVND_HOME/bin:/home/$USER/bin:/home/$USER/.local/bin:$JAVA_HOME/bin:$JDTLS_HOME/bin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
PATH="$MVND_HOME/bin:$VIRTUAL_ENV/bin:/home/$USER/bin:/home/$USER/.local/bin:$JAVA_HOME/bin:$JDTLS_HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# eclipse requests this variable
export WEBKIT_DISABLE_COMPOSITING_MODE=1

CDPATH=.:/home/$USER:/home/$USER/workspace/heroku:/home/$USER/workspace/$USERl2nano-code

source ~/bin/smartcd.sh

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/home/$USER/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

if [ -d ~/.bash_completion.d ]; then
  for file in ~/.bash_completion.d/*; do
    . $file
  done
fi
