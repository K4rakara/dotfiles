# Oh-my-zsh init.
export ZSH="/home/jack/.oh-my-zsh";
ZSH_THEME="kawaii-dracula";
plugins=(git);
source $ZSH/oh-my-zsh.sh;

export EDITOR="vim";
export PATH=~/.local/bin:$PATH;

if [[ $TERM = alacritty ]]; then
	bspc config -n $(bspc query -N -n) border_width 8 > /dev/null;
fi;

alias vj=$EDITOR "/home/$USER/documents/vim-journal.md";

clear;

