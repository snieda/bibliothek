#!/bin/bash

# Zwei Fenster für unterschiedliche Verzeichnisse anzeigen
left_dir="$PWD"
right_dir="$PWD"

file_manager() {
    while true; do
        clear
        echo "$(ls -1 "$left_dir" | fzf --height 40% --border --preview 'bat --style=numbers --color=always --line-range=:100 "$left_dir/{}"')" > /tmp/left_selection
        echo "$(ls -1 "$right_dir" | fzf --height 40% --border --preview 'bat --style=numbers --color=always --line-range=:100 "$right_dir/{}"')" > /tmp/right_selection

        left_selection=$(cat /tmp/left_selection)
        right_selection=$(cat /tmp/right_selection)

        echo -e "\nLinks: $left_selection | Rechts: $right_selection"
        echo -e "[M] Verschieben [C] Kopieren [D] Löschen [Q] Beenden"
        read -r -n 1 action
        
        case "$action" in
            M|m) mv "$left_dir/$left_selection" "$right_dir/" ;;
            C|c) cp -r "$left_dir/$left_selection" "$right_dir/" ;;
            D|d) rm -rf "$left_dir/$left_selection" ;;
            Q|q) break ;;
        esac
    done
}

# Fuzzy-Suche nach einem Textmuster in allen Dateien in allen Unterverzeichnissen
search_in_files() {
    QUERY=$(fzf --prompt="Suchbegriff: ")
    if [[ -n "$QUERY" ]]; then
        rg --hidden --ignore-case --line-number --no-heading --color=always "$QUERY" . | fzf --ansi --delimiter=: --preview "bat --style=numbers --color=always --highlight-line={2} {1}" --bind "enter:execute(bat --style=numbers --color=always {1})"
    fi
}

# Hauptmenü
while true; do
    ACTION=$(echo -e "[1] Datei-Manager\n[2] Suchen in Dateien\n[3] Beenden" | fzf --prompt="Wähle eine Aktion: ")
    case "$ACTION" in
        "[1]"*) file_manager ;;
        "[2]"*) search_in_files ;;
        "[3]"*) exit 0 ;;
    esac
done
