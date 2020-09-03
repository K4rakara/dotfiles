#!/usr/bin/bash

[ -d ~/.vim/ ] || mkdir -p ~/.vim/;

[ -f $PWD/.vim/autoload/plug.vim ] || curl https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > $PWD/.vim/autoload/plug.vim;

ln -s -f $PWD/.vim/autoload ~/.vim/autoload;

[ -d ~/.vim/plugged/dracula/autoload/ ] || mkdir -p ~/.vim/plugged/dracula/autoload/;

cp $PWD/.vim/dracula.vim ~/.vim/plugged/dracula/autoload/dracula.vim;

