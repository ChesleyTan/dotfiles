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
nnoremap t :tabnew
"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>
" Allow saving when forgetting to start vim with sudo
cmap w!! w !sudo tee > /dev/null %
call pathogen#infect()
function GitBranch()
	let	output=system('git branch | grep "*"')
	if output=="" " git branch returns NOTHING i.e '' if not in a git repo, not an error message as expected...
		return "[Not a Git Repository]"
	else
		return "[Git][Branch: " . output[0 : strlen(output)-2] . " | " " Strip newline ^@
	endif
endfunction
function GitStatus()
	let output=system('git status')
	if output=="" 
		return ""
	elseif output=~"Changes to be committed"
		return "Status: Commits not yet pushed]"
	elseif output=~"modified"
		return "Status: Changes not yet committed]"
	else	
		return "Status: Up to date]"
	endif
endfunction
function GitRemote(branch) " Note: this function takes a while to execute
	let remotes=split(system("git remote")) " Get names of remotes
	if remotes==[] " End if no remotes found or error
		return ""
	else
		let remotename=remotes[0] " Get name of first remote
	endif
	let output=system("git remote show " . remotename . " | grep \"" . a:branch . "\"")
	if output=="" " Checkpoint for error
		return ""
	elseif output =~ "local out of date"
		return "(!)Local repo out of date: Use git pull"
	else
		return ""
	endif
endfunction
let g:gitbranch=GitBranch()
let g:gitstatus=GitStatus() . " " . GitRemote(gitbranch)
hi User1 ctermfg=202 ctermbg=239 cterm=bold term=bold "Orange
hi User2 ctermfg=51 ctermbg=239 cterm=bold term=bold "Sky Blue
hi User3 ctermfg=39 ctermbg=239 cterm=bold term=bold "Darker Blue
hi User4 ctermfg=255 ctermbg=239 cterm=bold term=bold "Off-White
"hi User5 ctermfg=226 ctermbg=239 "Yellow
set statusline=%t      "tail of the filename
set statusline+=%y      "filetype
if winwidth(0) > 85
	set statusline+=[%{strlen(&fenc)?&fenc:'none'}\|  "file encoding
	set statusline+=%{&ff}] "file format
endif
set statusline+=%1*%r%*      "read only flag
set statusline+=%2*%m\%*       "modified flag
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
set statusline+=%% " Add percent symbol 
hi StatusLine ctermfg=239 ctermbg=118 "Status line of current window
hi StatusLineNC ctermfg=239 ctermbg=255 "Status line color for noncurrent window
hi LineNr ctermfg=118 ctermbg=239 "Line numbers
hi VertSplit ctermfg=239 ctermbg=118 "Vertical split divider
hi TabLine ctermbg=239 ctermfg=118 cterm=none "Nonselected tabs
hi TabLineFill ctermfg=239 "Empty space on tab bar
hi TabLineSel ctermbg=239 ctermfg=45 "Selected tab

let g:ConqueTerm_Color = 1
