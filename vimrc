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
set expandtab " Spaces instead of tabs
set softtabstop=4 " Treat n spaces as a tab
set shiftwidth=4
set laststatus=2
set pastetoggle=<F3>
set mouse=a " Allow using mouse to change cursor position
" Easy toggle for paste
nnoremap <C-p> <F3>
set t_Co=256 " Enable 256 colors
syntax on
filetype indent on
filetype plugin on
colorscheme default
:command Q q
:command W w
map Q <Nop>
" Prevent Ex Mode
nnoremap t :tabnew
"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>
" Allow saving when forgetting to start vim with sudo
cmap w!! w !sudo tee > /dev/null %
" Easy page up/down
nnoremap <C-Up> <C-u>
nnoremap <C-Down> <C-d>
" Allow window commands in insert mode
imap <C-w> <C-o><C-w>
nnoremap <A-Up> <C-w><Up>
nnoremap <A-Down> <C-w><Down>
nnoremap <A-Left> <C-w><Left>
nnoremap <A-Right> <C-w><Right>
" Note: <bar> denotes |
" Shortcuts for window commands
nnoremap <bar> <C-w>v
nnoremap _ <C-w>n
nnoremap - <C-w>-
nnoremap + <C-w>+
nnoremap > <C-w>>
nnoremap < <C-w><
autocmd InsertEnter * call RefreshColors(17)
autocmd InsertLeave * call RefreshColors(239)
" Easy system clipboard copy/paste
vnoremap <C-c> "*y
vnoremap <C-x> "*x
" Easy buffer switching
nnoremap <F5> :buffers<CR>:buffer<Space>

call pathogen#infect()
function GitBranch()
    let output=system("git branch | grep '*'| grep -o ' '[A-Za-z]* | cut -c2-")
    if output=="" " git branch returns NOTHING i.e '' if not in a git repo, not an error message as expected...
        return ""
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
let g:gitBranch=GitBranch()
let g:gitStatus=GitStatus() . " " . GitRemote(gitBranch)
" Note that these highlight themes have to formed with concatenation and then
" be evaluated with :execute because :hi does not accept variables as arguments
function RefreshColors(statusLineColor)
    "Orange
    exe 'hi User1 ctermfg=202 ctermbg=' . a:statusLineColor 'cterm=bold term=bold' 
    "Sky Blue
    exe 'hi User2 ctermfg=51 ctermbg=' . a:statusLineColor 'cterm=bold term=bold' 
    "Darker Blue
    exe 'hi User3 ctermfg=39 ctermbg=' . a:statusLineColor 'cterm=bold term=bold' 
    "Off-White
    exe 'hi User4 ctermfg=255 ctermbg=' . a:statusLineColor 'cterm=bold term=bold'
    "Status line of current window
    exe 'hi StatusLine term=bold cterm=bold gui=bold ctermfg=118 ctermbg=' . a:statusLineColor 
    "Status line color for noncurrent window
    exe 'hi StatusLineNC term=bold cterm=bold gui=bold ctermfg=255 ctermbg=' . a:statusLineColor 
    "Line numbers
    exe 'hi LineNr ctermfg=118 ctermbg=' . a:statusLineColor
    "Vertical split divider
    exe 'hi VertSplit term=bold cterm=bold gui=bold ctermfg=118 ctermbg=' a:statusLineColor
    "Nonselected tabs
    exe 'hi TabLine ctermfg=118 cterm=none ctermbg=' . a:statusLineColor 
    "Empty space on tab bar
    exe 'hi TabLineFill term=bold cterm=bold gui=bold ctermbg=' . a:statusLineColor
    "Selected tab
    exe 'hi TabLineSel ctermfg=45 ctermbg=' . a:statusLineColor 
    "indentLine plugin
    exe 'let g:indentLine_color_term = ' . a:statusLineColor
endfunction
exe RefreshColors(239)
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
    set statusline+=\ %1*%{gitBranch}%* "Git branch
    set statusline+=%1*%{gitStatus}%* "Git status
endif
set statusline+=%=      "left/right separator
set statusline+=%3*%F%*\ %4*\|%*\   "file path
set statusline+=Col:%c\      "cursor column
set statusline+=Row:%l/%L\    "cursor line/total lines
set statusline+=%4*\|%*\ %p   "percent through file
set statusline+=%% " Add percent symbol 

let g:ConqueTerm_Color = 1
let g:ConqueTerm_TERM = 'xterm-256color'
let g:ConqueTerm_PromptRegex = '^\w\+@[0-9A-Za-z_.-]\+:[0-9A-Za-z_./\~,:-]\+\$'
let g:indentLine_char = '┆'

set completeopt=longest,menuone
autocmd Filetype java setlocal omnifunc=javacomplete#Complete
autocmd Filetype java setlocal completefunc=javacomplete#CompleteParamsInfo
inoremap <C-O> <C-X><C-O>
