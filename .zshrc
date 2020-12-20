# For some reason, zsh doesn't source /etc/profile. wtf.
source /etc/profile;
# Source devkitPro stuffs (for homebrew)
source /etc/profile.d/devkit-env.sh

# Oh-my-zsh init.
export ZSH="/home/jack/.oh-my-zsh";
ZSH_THEME="kawaii-dracula";
plugins=(git);
source $ZSH/oh-my-zsh.sh;

export EDITOR="nvim";
export PATH=~/.local/bin:$PATH;

if [[ $TERM = alacritty ]]; then
	bspc config -n $(bspc query -N -n) border_width 8 > /dev/null;
fi;

alias vim=nvim;
alias vj=$EDITOR "/home/$USER/documents/vim-journal.md";
alias :q=exit;
alias eyed3=eyeD3;
alias back=cd $OLDPWD;

clear;

