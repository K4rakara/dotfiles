" vim-plug
" =============================================================================

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'

Plug 'dracula/vim', { 'as': 'dracula' }

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'leafgarland/typescript-vim'

Plug 'Quramy/tsuquyomi'

Plug 'ycm-core/YouCompleteMe'

call plug#end()

" general stuff
" =============================================================================

set number

set nowrap

set autoindent noexpandtab tabstop=4 shiftwidth=4

colorscheme dracula

filetype plugin on
set omnifunc=syntaxcomplete#Complete

let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1

