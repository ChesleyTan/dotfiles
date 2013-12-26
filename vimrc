set nocp
set hidden " Hides buffers instead of closing them, allows opening new buffers when current has unsaved changes
set title " Show title in terminal
set number " Show line numbers
set hlsearch " Highlight search term in text
set incsearch " Show search matches as you type
set wrapscan " Automatically wrap search when hitting bottom
set autoindent
set copyindent " Copy indent of previous line
set history=1000 " Command history
set undolevels=500 " Levels of undo
set wildignore=*.class
set tabstop=4
set shiftwidth=4
set laststatus=2
set pastetoggle=<F3>
set t_Co=256 " Enable 256 colors
syntax on
filetype indent on
filetype plugin on
colorscheme default
:command Q q
:command W w
"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>
" Allow saving when forgetting to start vim with sudo
cmap w!! w !sudo tee > /dev/null %
call pathogen#infect()
function PercSym()
	return "%"
endfunction
function GitBranch()
	let	output=system('git branch')
	if output=~"fatal"
		return ""
	endif
	return "[Git][Branch: " . output[0 : strlen(output)-2] . " | " " Strip newline ^@
endfunction
function GitStatus()
	let output=system('git status')
	if output=~"fatal"
		return ""
	endif
	if output=~"Changes to be committed"
		return "Status: Commits not yet pushed]"
	endif
	if output=~"modified"
		return "Status: Changes not yet committed]"
	endif
	return "Status: Up to date]"
endfunction
let gitbranch=GitBranch()
let gitstatus=GitStatus()
hi User1 ctermfg=202 ctermbg=239 "Orange
hi User2 ctermfg=51 ctermbg=239 "Sky Blue
hi User3 ctermfg=39 ctermbg=239 "Darker Blue
hi User4 ctermfg=255 ctermbg=239 "Off-White
"hi User5 ctermfg=226 ctermbg=239 "Yellow
set statusline=%t      "tail of the filename
set statusline+=%1*%r%*      "read only flag
set statusline+=%2*%m\%*\        "modified flag
set statusline+=%4*[%*%Y%4*]%*\       "filetype
if winwidth(0) > 85
	set statusline+=%4*[%*Enc:\ %{strlen(&fenc)?&fenc:'none'}\ %4*\|%*\   "file encoding
	set statusline+=Fmt:\ %{&ff}%4*]%* "file format
endif
set statusline+=%h      "help file flag
set statusline+=\ Buffer:%n "Buffer number
if winwidth(0) > 130
	set statusline+=\ %1*%{gitbranch}%* "Git branch
	set statusline+=%1*%{gitstatus}%* "Git status
endif
set statusline+=%=      "left/right separator
set statusline+=%3*%F%*\ %4*\|%*\  	"file path
set statusline+=Col:%c\      "cursor column
set statusline+=Row:%l/%L\    "cursor line/total lines
set statusline+=%4*\|%*\ %p   "percent through file
set statusline+=%{PercSym()} "workaround for percent symbol, can't figure out how to do it with escape chars
hi StatusLine ctermfg=239 ctermbg=118
hi StatusLineNC ctermfg=239 ctermbg=255 "Status line color for noncurrent window
hi LineNr ctermfg=118 ctermbg=239
hi VertSplit ctermfg=239 ctermbg=118 "Vertical split divider

