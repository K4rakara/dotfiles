#!/usr/bin/bash

[ -d ~/.config/nvim/ ] || mkdir -p ~/.config/nvim/;

[ -f ~/.local/share/nvim/site/autoload/plug.vim ] || {
  sh -c 'curl -fLo "$HOME"/.local/share/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim';
};

ln -s -f "$PWD/.config/nvim/init.vim" "$HOME/.config/nvim/init.vim";

ln -s -f "$PWD/.config/nvim/coc-settings.json" "$HOME/.config/nvim/coc-settings.json";

ln -s -f "$PWD/.config/nvim/icons.json" "$HOME/.config/nvim/icons.json";

ln -s -f "$PWD/.config/nvim/dracula.vim" "$HOME/.local/share/nvim/plugged/dracula/autoload/dracula.vim";

