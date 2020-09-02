#!/usr/bin/bash

[ -d ~/.vim/ ] || mkdir -p ~/.vim/;

[ -f $PWD/.vim/autoload/plug.vim ] || curl https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > $PWD/.vim/autoload/plug.vim;

ln -s -f $PWD/.vim/autoload ~/.vim/autoload;

