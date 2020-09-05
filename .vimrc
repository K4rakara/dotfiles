" general stuff
" =============================================================================

set number

set nowrap

set autoindent noexpandtab tabstop=4 shiftwidth=4

" vim-plug
" =============================================================================

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'

Plug 'dracula/vim', { 'as': 'dracula' }

Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

colorscheme dracula

