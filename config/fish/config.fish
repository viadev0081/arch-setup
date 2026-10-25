if status is-interactive
# Commands to run in interactive sessions can go here
end

set -g -x fish_greeting ''

set -gx EDITOR nvim

set -gx VISUAL $EDITOR

alias nv="nvim"
alias v="vim"
alias dnv="sudo nvim"
alias dv="sudo vim"
alias ls="eza --level=1 --icons --color=always"
alias cat="bat --theme=base16-256"
alias lg="lazygit"
alias mkln="make clean"
alias mkop="cd ~/open-delta/code/kernel/ && make"
alias install="sudo pacman -Sy"
alias remove="sudo pacman -Rdd"
alias update="sudo pacman -Syu"
alias ff="fastfetch"
alias nf="neofetch"
alias yz="yazi"

if command -v tree >/dev/null
    alias tree='tree -C -F --dirsfirst'
end

set -U fish_history 50000

set -g fish_complete_path $fish_complete_path /usr/share/fish/completions

zoxide init fish | source
