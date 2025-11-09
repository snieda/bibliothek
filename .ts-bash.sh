#!/bin/bash
# (cr) Thomas Schneider 2025/10
# provide help on                'Ctrl+h'
# provide a cd with selection on 'Ctrl+g'
#
# preconditions:
#   - xdo-open
#   - fzy or fzf

bind -x '"\C-h":select_expression'
bind -x '"\C-o":select_expression goto_select'

# lets the user select a known directory or a directory inside the current tree (using smartcd, find and fzf)
# usage: goto_select
#
goto_select() {
   { smartcd --list | sed -E "s/^[0-9]+[:]//g"; find -type d; } | fzy 
}

# prints the given user selection directly to the commandline without executing it.
# usage: select_expression [selected-item (default: help_select)]
#
select_expression() {
  local selected=${1:-"$(help_detail "$(help_select)" )"}
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${selected}${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}

# downloads and caches a help file
# usage: help_download <view-command> <url> <storing-filename>
#
help_download() {
   [ ! -f $3 ] && curl $2 -o $3 || $1 $3
}

# provides a help command with arguments for a given string
# usage: help_detail <text-to-evaluate-a-help-command-for>
#
help_detail() {
   if [[ "$1" == *":bash.txt:"* ]]; then
      echo "$1" | sed -E "s/([0-9]*)[:]([a-zA-Z0-9\.]+)[:](.*)/less +\1 \2 # \3/g"
   elif [[ "$1" == *":apt:"* ]]; then
      echo "$1" | sed -E "s/([0-9]*)[:]([a-zA-Z0-9\.]+)[:]\s*\w\s*([a-zA-Z0-9\.]+)(.*)/apt search \3 # \4/g"
   elif [[ "$1" == *":man:"* ]]; then
      echo "$1" | sed -E "s/([0-9]*)[:]([a-zA-Z0-9\.]+)[:]\s*([a-zA-Z0-9\.]+)(.*)/man \3 # \4/g"
   elif [[ "$1" == *":compgen:"* || "$1" == *":bash:"* ]]; then
      echo "$1" | sed -E "s/([0-9]*)[:]([a-zA-Z0-9\.]+)[:]\s*([a-zA-Z0-9\.]+)(.*)/\3 --help # \4/g"
   elif [[ "$1" == *"help_download"* ]]; then
      echo $1
   else
      echo "xdg-open www.google.com/search?q=$1"
   fi
}

# creates a list of help entries and lets the user select one through 'fzf'
# usage: help_select
# we combine 'apropos', 'compgen', 'bash help', 'aptitude', bash.txt and some online cheatsheets, faqs, handbooks
#
help_select() {
   echo $( { help -d '' | nl -b a -s ":bash: "; \
      apropos . | nl -b a -s ":man: "; \
      compgen -A function -abck | nl -b a -s ":compgen: "; \
      help_download cat https://www.gnu.org/software/bash/manual/bash.txt ~/bash.txt | nl -b a -s ":bash.txt: "; \
      aptitude search . | nl -b a -s ":apt: "; \
      echo "help_download xdg-open https://devhints.io/bash ~/bash-scripting-cheatsheets.html # bash scripting cheatsheet"; \
      echo "help_download xdg-open http://mywiki.wooledge.org/BashFAQ ~/bash-faq.html # bash FAQs"; \
      echo "help_download xdg-open https://github.com/denysdovhan/bash-handbook ~/bash-handbook.html # bash handbook"; \
   } | fzf )
}
