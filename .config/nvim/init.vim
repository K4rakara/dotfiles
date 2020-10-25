" Plug
" =====================================

call plug#begin('~/.local/share/nvim/plugged')

Plug 'tpope/vim-sensible'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'preservim/nerdtree'

Plug 'sheerun/vim-polyglot'

Plug 'cespare/vim-toml'

Plug 'mklabs/vim-json'

Plug 'dracula/vim', {'as': 'dracula'}

call plug#end()

" Utilities
" =====================================

function! Utilities_Match(value, default, dict)
	if has_key(a:dict, a:value)
		return a:dict[a:value]
	else
		return a:default
	endif
endfunction

function! Utilities_GUIColor(n)
	return Utilities_Match(a:n, a:n, {
		\ "red":    "#FF5555",
		\ "orange": "#FFB86C",
		\ "yellow": "#F1FA8C",
		\ "green":  "#50FA7B",
		\ "cyan":   "#8BE8FD",
		\ "blue":   "#62A5F4",
		\ "purple": "#BD93F9",
		\ "pink":   "#FF79C6",
		\ })
endfunction

let g:icons = JSON#parse(join(readfile(fnamemodify("~", ":p").".config/nvim/icons.json"), ""))

function! Utilities_IconOf(type, path)
	let l:to_return = "󰈔"
	if a:type == "file"
		let ext = fnamemodify(a:path, ':e')
		let name = fnamemodify(a:path, ':t')
		if has_key(g:icons.file.format, ext)
			let l:to_return = g:icons.file.format[ext]
		endif
		if has_key(g:icons.file.name, name)
			let l:to_return = g:icons.file.name[name]
		endif
	elseif a:type == "directory"
		let name = fnamemodify(a:path, ':t')
		if has_key(g:icons.directory, name)
			let l:to_return = g:icons.directory[name]
		endif
	endif
	if stridx(l:to_return, "+") >= 0
		let split = split(l:to_return, "+")
		let first = Utilities_GUIColor(split[0])
		let second = split[1]
		return [ first, second ]
	else
		return [ "", l:to_return ]
	endif
endfunction

" General preferences
" =====================================

set number
set nowrap
set termguicolors

set noautoindent
set noexpandtab
set smartindent

set tabstop=4
set shiftwidth=4
set smarttab

set noswapfile
set nobackup
set undodir=~/.config/nvim/undo
set undofile
set noemoji

colorscheme dracula

" Custom statusline
" =====================================

let s:StatusLine_FileIcon_State = {
	\ "lastUpdated": 0,
	\ "lastResult": [ "", "" ],
	\ }

function! StatusLine_FileIcon()
	if s:StatusLine_FileIcon_State.lastUpdated + 60 < localtime()
		let s:StatusLine_FileIcon_State.lastUpdated = localtime()
		let s:StatusLine_FileIcon_State.lastResult = Utilities_IconOf("file", expand("%"))
		return s:StatusLine_FileIcon_State.lastResult
	else
		return s:StatusLine_FileIcon_State.lastResult
	endif
endfunction

call StatusLine_FileIcon()

let s:StatusLine_Git_State = {
	\ "lastUpdated": 0,
	\ "lastResult": "",
	\ }

function! StatusLine_Git()
	if s:StatusLine_Git_State.lastUpdated + 60 < localtime()
		let s:StatusLine_Git_State.lastUpdated = localtime()
		let l:branch = system("git branch --show-current")[:-2]
		if stridx(l:branch, "fatal") == -1
			let l:changed = system("git status --short")[:-2]
			if l:changed != ""
				let s:StatusLine_Git_State.lastResult = " 󱓊 ".l:branch." "
				return s:StatusLine_Git_State.lastResult
			else
				let s:StatusLine_Git_State.lastResult = " 󰘬 ".l:branch." "
				return s:StatusLine_Git_State.lastResult
			endif
		else
			let s:StatusLine_Git_State.lastResult = ""
			return s:StatusLine_Git_State.lastResult
		endif
	else
		return s:StatusLine_Git_State.lastResult
	endif
endfunction

call StatusLine_Git()

function! StatusLine_Saved()
	if &mod
		return " * "
	else
		return ""
	end
endfunction

set laststatus=2

set statusline=
" Start of statusline
set statusline+=%#StatusLine_Start#
" File icon
set statusline+=%#StatusLine_FileIcon#%{StatusLine_FileIcon()[1]}
" File name
set statusline+=%#StatusLine#\ %f
" Is file saved?
set statusline+=%{StatusLine_Saved()}
" Git context
set statusline+=%#StatusLine_Git#%{StatusLine_Git()}%#StatusLine#
" Align right
set statusline+=%=
" Line/Column number
set statusline+=\ 󰹹\ %03l,\ 󰹳\ %03v
" End of statusline
set statusline+=%#StatusLine_End#

highlight StatusLine
	\ ctermfg=white
	\ ctermbg=238
	\ guifg=#CCCCCC
	\ guibg=#333333
highlight StatusLine_Start
	\ ctermfg=238
	\ ctermbg=NONE
	\ guifg=#333333
	\ guibg=#222222
execute("highlight StatusLine_FileIcon guifg=".StatusLine_FileIcon()[0]." guibg=#333333")
highlight StatusLine_Git
	\ ctermfg=yellow
	\ ctermbg=238
	\ guifg=#EDF66C
	\ guibg=#333333
highlight StatusLine_End
	\ ctermfg=238
	\ ctermbg=NONE
	\ guifg=#333333
	\ guibg=#222222

" Language specific preferences
" =====================================

autocmd Filetype css  setlocal tabstop=2 shiftwidth=2
autocmd Filetype sass setlocal tabstop=2 shiftwidth=2
autocmd Filetype scss setlocal tabstop=2 shiftwidth=2
autocmd Filetype html setlocal tabstop=2 shiftwidth=2
autocmd Filetype vim  setlocal tabstop=2 shiftwidth=2
autocmd Filetype lua  setlocal tabstop=2 shiftwidth=2
autocmd Filetype json setlocal tabstop=2 shiftwidth=2

" COC extensions
" =====================================

let g:coc_global_extensions = [
	\ "coc-snippets",
	\ "coc-pairs",
	\ "coc-tsserver",
	\ "coc-eslint",
	\ "coc-rls",
	\ "coc-python",
	\ ]

" NERDTree customizations
" =====================================

let g:NERDTreeDirArrowExpandable = "󰉋"
let g:NERDTreeDirArrowCollapsible = "󰝰"

" Custom keybindings
" =====================================

" Intellesense on CTRL+space
inoremap <silent><expr> <c-space> coc#refresh()

" Open/close NERDTree intellegently when e is pressed in NORMAL mode.
nmap e :NERDTreeToggle<CR>

" Automation
" =====================================

" Intellesense on pause
autocmd CursorHold * silent call CocActionAsync("highlight")

" Closes nerdtree if its the only remaining window.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

