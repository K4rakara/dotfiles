" Plug
" =====================================

call plug#begin('~/.local/share/nvim/plugged')

Plug 'tpope/vim-sensible'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'preservim/nerdtree'

Plug 'editorconfig/editorconfig-vim'

Plug 'sheerun/vim-polyglot'

Plug 'cespare/vim-toml'

Plug 'mklabs/vim-json'

Plug 'k4rakara/vim-devicons'

" TODO: Make a rust implementation of this and replace this with that, this
" plugin is slow as _fuck_.
" Plug 'vbe0201/vimdiscord'

Plug 'dracula/vim', {'as': 'dracula'}

call plug#end()

" Utilities
" =====================================

let s:true = 1
let s:false = 0

let b:is_help_file = 0
function! IsHelpFile()
	if has_key(b:, "is_help_file")
		return get(b:, "is_help_file", s:false)
	else
		let current_file = expand("%")
		if ( current_file =~ "/usr/share/nvim/" && current_file =~ "doc" )
		\ || ( current_file =~ ".local/share/nvim/" && current_file =~ "doc" )
			let b:is_help_file = 1
		else
			let b:is_help_file = 0
		endif
		return get(b:, "is_help_file", s:false)
	endif
endfunction

let s:Utilities_thisScript = expand("<sfile>:p")

function! Match(value, default, dict)
	if has_key(a:dict, a:value)
		return a:dict[a:value]
	else
		return a:default
	endif
endfunction

function! GUIColor(n)
	return Match(a:n, a:n, {
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
function! IconOf(type, path)
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
		let first = GUIColor(split[0])
		let second = split[1]
		return [ first, second ]
	else
		return [ "fg", l:to_return ]
	endif
endfunction

function! NERDTreeSmartToggle()
	" Only execute if this is the current buffer.
	if bufnr() == bufnr("%")
		if exists("b:NERDTree")
			NERDTreeClose
		else
			NERDTree
		endif
	endif
endfunction

" General preferences
" =====================================

set number
set nowrap
set termguicolors

set noautoindent
set noexpandtab
set nosmartindent

set tabstop=4
set shiftwidth=4
set nosmarttab

set noswapfile
set nobackup
set undodir=~/.config/nvim/undo
set undofile
set noemoji

colorscheme dracula

" Custom statusline
" =====================================

" Displays the file icon in my custom statusline.
let s:sl_file_icon = {
	\ "last_updated": 0,
	\ "last_result": [ "", "" ],
	\ }
function! SlFileIcon()
	" If the current file is not a help file...
	if !IsHelpFile() && expand("%") != ""
		" If it's been more than 60 seconds since the last time the icon was
		" updated, then...
		if s:sl_file_icon.last_updated + 60 < localtime()
			" Set the time since the last update to now.
			let s:sl_file_icon.last_updated = localtime()
			" Store the previous result.
			let old = s:sl_file_icon.last_result
			" Get the icon and store the result.
			let s:sl_file_icon.last_result = IconOf("file", expand("%"))
			" If the result is different from the previous result, then reapply the
			" highlighting.
			if old != s:sl_file_icon.last_result
				execute("highlight StatusLine_FileIcon guifg=".s:sl_file_icon.last_result[0]." guibg=#333333")
			endif
			" Return the result.
			return s:sl_file_icon.last_result
		" Otherwise...
		else
			" Return the previous result.
			return s:sl_file_icon.last_result
		endif
	" If the current file is a help file...
	else
		return ""
	endif
endfunction
call SlFileIcon()

" Displays the filename in my custom statusline.
function! SlFileName()
	if !IsHelpFile()
		let expanded = expand("%:p")
		let home = expand("~")."/"
		let modified = substitute(expanded, home, "", "")
		if modified != expanded
			let modified = "~/".modified
		endif
		return modified." "
	else
		return ""
	endif
endfunction

" Displays the git status in my custom statusline.
let s:sl_git = {
	\ "last_updated": 0,
	\ "last_result": "",
	\ }
function! SlGit()
	" If the current file is not a help file...
	if !IsHelpFile()
		" If the git status hasn't been updated in more than 60 seconds...
		if s:sl_git.last_updated + 60 < localtime()
			" Set the last update to now.
			let s:sl_git.last_updated = localtime()
			" Get the absolute path containing the current file.
			let dir = expand("%:p:h")
			" Try to get the current git branch.
			let branch = system("sh -c \"cd ".dir." && git branch --show-current\"")[:-2]
			" If no error occurred...
			if stridx(l:branch, "fatal") == -1
				" Get a list of changes.
				let changes = system("sh -c \"cd ".dir." && git status --short\"")[:-2]
				" If there's one or more changes, then...
				if changes != ""
					" Set the result to the modified branch icon.
					let s:sl_git.last_result = " 󱓊 ".l:branch." "
					" Return the result.
					return s:sl_git.last_result
				" If there's no changes...
				else
					" Set the result to the unmodified branch icon.
					let s:sl_git.last_result = " 󰘬 ".l:branch." "
					" Return the result.
					return s:sl_git.last_result
				endif
			" If an error occurred...
			else
				" Clear the result, there probably isn't a git repo.
				let s:sl_git.last_result = ""
				" Return the result.
				return s:sl_git.last_result
			endif
		" Otherwise...
		else
			return s:sl_git.last_result
		endif
	" If the current file is a help file...
	else
		return ""
	endif
endfunction

call SlGit()

function! StatusLine_Saved()
	if !IsHelpFile()
		if &mod
			return " * "
		else
			return ""
		endif
	else
		return ""
	endif
endfunction

set laststatus=2

set statusline=
" Start of statusline
set statusline+=%#StatusLine_Start#
" File icon
set statusline+=%#StatusLine_FileIcon#%{SlFileIcon()[1]}
" File name
set statusline+=%#StatusLine#\ %{SlFileName()}
" Is file saved?
set statusline+=%{StatusLine_Saved()}
" Git context
set statusline+=%#SlGit#%{SlGit()}%#StatusLine#
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
highlight SlGit
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

" Some of these are redundant, but for some odd reason, not all languages just
" listen to my config. Mabye COC is telling it to use something different, but
" whatever.
autocmd Filetype css             setlocal tabstop=2 shiftwidth=2
autocmd Filetype sass            setlocal tabstop=2 shiftwidth=2
autocmd Filetype scss            setlocal tabstop=2 shiftwidth=2
autocmd Filetype html            setlocal tabstop=2 shiftwidth=2
autocmd Filetype vim             setlocal tabstop=2 shiftwidth=2
autocmd Filetype lua             setlocal tabstop=2 shiftwidth=2
autocmd Filetype json            setlocal tabstop=2 shiftwidth=2
autocmd Filetype typescript      setlocal tabstop=2 shiftwidth=2 expandtab
autocmd Filetype typescriptreact setlocal tabstop=2 shiftwidth=2 expandtab
autocmd Filetype python          setlocal tabstop=2 shiftwidth=2 expandtab
autocmd Filetype rust            setlocal tabstop=4 shiftwidth=4

" COC extensions
" =====================================

let g:coc_global_extensions = [
	\ "coc-ccls",
	\ "coc-eslint",
	\ "coc-html",
	\ "coc-json",
	\ "coc-pairs",
	\ "coc-python",
	\ "coc-rls",
	\ "coc-snippets",
	\ "coc-tsserver",
	\ ]

" COC customizations
" =====================================

" Custom completion icons (Requires ttf-codicon)
autocmd User CocNvimInit call coc#config("suggest.completionItemKindLabels", {
	\ "class":      "",
	\ "color":      "",
	\ "constant":   "",
	\ "default":    "",
	\ "enum":       "",
	\ "enumMember": "",
	\ "event":      "",
	\ "field":      "",
	\ "file":       "",
	\ "folder":     "",
	\ "function":   "",
	\ "interface":  "",
	\ "keyword":    "",
	\ "method":     "",
	\ "module":     "",
	\ "operator":   "",
	\ "property":   "",
	\ "reference":  "",
	\ "snippet":    "",
	\ "struct":	    "",
	\ "text":       "",
	\ "unit":       "",
	\ "variable":   "",
	\ })

autocmd User CocNvimInit highlight CocFloating guifg=#CCCCCC guibg=#333333

" Custom autocomplete menu colors.
highlight Pmenu      guifg=#CCCCCC guibg=#333333
highlight PmenuSel   guifg=#DDDDDD guibg=#444444
highlight PmenuThumb guibg=#444444
highlight PmenuSBar  guibg=#333333

" NERDTree customizations
" =====================================

" Show less stuff.
let g:NERDTreeMinimalUI = 1

" Show hidden files.
let g:NERDTreeShowHidden = 1

" Quit when a file is opened from NERDTree.
let g:NERDTreeQuitOnOpen = 1

" Frees up the E key.
let g:NERDTreeHijackNetrw = 0
let g:NERDTreeMapOpenExpl = "fuck off" " Yes, this works.
let g:loaded_netrwPlugin = 1

" Custom keybindings
" =====================================

" Intellesense on CTRL+space
inoremap <silent><expr> <c-space> coc#refresh()

" Open/close NERDTree intellegently when e is pressed in NORMAL mode.
nmap e :call NERDTreeSmartToggle()<CR>:echo "NERDTree toggled"<CR>

" Automation
" =====================================

" Closes nerdtree if its the only remaining window.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Auto updates statusline when entering a buffer.
autocmd bufenter * silent call execute("if has_key(b:, \"is_help_file\") | let s:sl_file_icon.last_updated = 0 | endif") | redraw

