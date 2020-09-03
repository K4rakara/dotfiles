" general stuff
" =============================================================================

set number

" vim-plug
" =============================================================================

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'

Plug 'dracula/vim', { 'as': 'dracula' }

Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

colorscheme dracula

