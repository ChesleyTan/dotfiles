" General configuration {{{
" vim:fdm=marker
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
autocmd InsertEnter * call RefreshColors(17, '#00005f')
autocmd InsertLeave * call RefreshColors(235, '#262626')
" }}}
" Custom mappings {{{
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
" Easy system clipboard copy/paste
vnoremap <C-c> "+y
vnoremap <C-x> "+x
" Easy buffer switching
nnoremap <F5> :buffers<CR>:buffer<Space>
" Quick change syntax highlighting color for dark background
nnoremap <S-i> :call ReverseColors()<CR>
" }}}
" Functions for generating statusline {{{
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
" }}}
" Colorscheme changing function {{{ 
" Note that these highlight themes have to formed with concatenation and then
" be evaluated with :execute because :hi does not accept variables as arguments
function RefreshColors(statusLineColor, gui_statusLineColor)
    "Orange
    exe 'hi User1 ctermfg=202 ctermbg=' . a:statusLineColor 'cterm=bold term=bold gui=bold guifg=#ff5f00 guibg=' . a:gui_statusLineColor
    "Sky Blue
    exe 'hi User2 ctermfg=51 ctermbg=' . a:statusLineColor 'cterm=bold term=bold gui=bold guifg=#00ffff guibg=' . a:gui_statusLineColor 
    "Darker Blue
    exe 'hi User3 ctermfg=39 ctermbg=' . a:statusLineColor 'cterm=bold term=bold gui=bold guifg=#00afff guibg=' . a:gui_statusLineColor 
    "Off-White
    exe 'hi User4 ctermfg=255 ctermbg=' . a:statusLineColor 'cterm=bold term=bold gui=bold guifg=#eeeeee guibg=' . a:gui_statusLineColor
    "Red
    exe 'hi User5 ctermfg=196 ctermbg=' . a:statusLineColor 'cterm=bold term=bold gui=bold guifg=#ff0000 guibg=' . a:gui_statusLineColor
    "Status line of current window
    exe 'hi StatusLine term=bold cterm=bold gui=bold ctermfg=118 ctermbg=' . a:statusLineColor 'guifg=#87ff00 guibg=' . a:gui_statusLineColor
    "Status line color for noncurrent window
    exe 'hi StatusLineNC term=bold cterm=bold gui=bold ctermfg=255 ctermbg=' . a:statusLineColor 'guifg=#eeeeee guibg=' . a:gui_statusLineColor
    "Line numbers
    exe 'hi LineNr ctermfg=118 ctermbg=' . a:statusLineColor 'guifg=#87ff00 guibg=' . a:gui_statusLineColor
    "Vertical split divider
    exe 'hi VertSplit term=bold cterm=bold gui=bold ctermfg=118 ctermbg=' a:statusLineColor 'guifg=#87ff00 guibg=' . a:gui_statusLineColor
    "Nonselected tabs
    exe 'hi TabLine ctermfg=118 cterm=none ctermbg=' . a:statusLineColor 
    "Empty space on tab bar
    exe 'hi TabLineFill term=bold cterm=bold gui=bold ctermbg=' . a:statusLineColor
    "Selected tab
    exe 'hi TabLineSel ctermfg=45 ctermbg=' . a:statusLineColor 
    "Folds colorscheme
    hi Folded ctermfg=255 ctermbg=129 guifg=gray100 guibg=#af00ff
    "indentLine plugin
    exe 'let g:indentLine_color_term = ' . a:statusLineColor
    hi Visual ctermbg=247 guibg=#9e9e9e
    "Visual mode selection color 
    hi SpellBad ctermbg=160 guibg=#d70000
    hi SpellCap ctermbg=214 guibg=#ffaf00
    hi SpellRare ctermbg=195 guibg=#dfffff
    "Spell-check highlights
endfunction
call RefreshColors(235, '#262626')

function ReverseColors()
    if &background == "light"
        set background=dark
    else
        set background=light
    endif
    call RefreshColors(235, '#262626')
endfunction
" }}}
" Custom statusline {{{
set statusline=%t      "tail of the filename
set statusline+=%y      "filetype
if winwidth(0) > 85
    set statusline+=[%{strlen(&fenc)?&fenc:'none'}\|  "file encoding
    set statusline+=%{&ff}] "file format
endif
set statusline+=%1*%r%*      "read only flag
set statusline+=%2*%m\%*       "modified flag
set statusline+=%h      "help file flag
set statusline+=\ B:%n "Buffer number
if winwidth(0) > 100
    set statusline+=\ %1*%{gitBranch}%* "Git branch
    set statusline+=%1*%{gitStatus}%* "Git status
endif
set statusline+=%=      "left/right separator
"set statusline+=%3*%F%*\ %4*\|%*\   "file path with full names
set statusline+=%3*%{pathshorten(expand('%:p'))}%*\ %4*\|%*\   "file path with truncated names
set statusline+=C:%c\      "cursor column
set statusline+=R:%l/%L\    "cursor line/total lines
set statusline+=%4*\|%*\ %p   "percent through file
set statusline+=%% " Add percent symbol 
" }}}
" tabline from StackOverflow {{{
set tabline+=%!MyTabLine()
function MyTabLine()
        let s = '' " complete tabline goes here
        " loop through each tab page
        for t in range(tabpagenr('$'))
                " set highlight
                if t + 1 == tabpagenr()
                        let s .= '%#TabLineSel#'
                else
                        let s .= '%#TabLine#'
                endif
                " set the tab page number (for mouse clicks)
                let s .= '%' . (t + 1) . 'T'
                let s .= ' '
                " set page number string
                let s .= t + 1 . ' '
                " get buffer names and statuses
                let n = ''      "temp string for buffer names while we loop and check buftype
                let m = 0       " &modified counter
                let bc = len(tabpagebuflist(t + 1))     "counter to avoid last ' '
                " loop through each buffer in a tab
                for b in tabpagebuflist(t + 1)
                        " buffer types: quickfix gets a [Q], help gets [H]{base fname}
                        " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
                        if getbufvar( b, "&buftype" ) == 'help'
                                let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
                        elseif getbufvar( b, "&buftype" ) == 'quickfix'
                                let n .= '[Q]'
                        else
                                let n .= pathshorten(bufname(b))
                        endif
                        " check and ++ tab's &modified count
                        if getbufvar( b, "&modified" )
                                let m += 1
                        endif
                        " no final ' ' added...formatting looks better done later
                        if bc > 1
                                let n .= ' '
                        endif
                        let bc -= 1
                endfor
                " add modified label [n+] where n pages in tab are modified
                if m > 0
                        let s .= '[' . m . '+]'
                endif
                " select the highlighting for the buffer names
                " my default highlighting only underlines the active tab
                " buffer names.
                if t + 1 == tabpagenr()
                        let s .= '%#TabLineSel#'
                else
                        let s .= '%#TabLine#'
                endif
                " add buffer names
                if n == ''
                        let s.= '[New]'
                else
                        let s .= n
                endif
                " switch to no underlining and add final space to buffer list
                let s .= ' '
        endfor
        " after the last tab fill with TabLineFill and reset tab page nr
        let s .= '%#TabLineFill#%T'
        " right-align the label to close the current tab page
        if tabpagenr('$') > 1
                let s .= '%=%#TabLineFill#%5*%999XClose%*'
        endif
        return s
endfunction
" }}}
" Plugins configuration {{{
call pathogen#infect()
let g:ConqueTerm_Color = 1
let g:ConqueTerm_TERM = 'xterm-256color'
let g:ConqueTerm_PromptRegex = '^\w\+@[0-9A-Za-z_.-]\+:[0-9A-Za-z_./\~,:-]\+\$'
let g:indentLine_char = '┆'
" }}}
" Omnicomplete {{{
set completeopt=longest,menuone
autocmd Filetype java setlocal omnifunc=javacomplete#Complete
autocmd Filetype java setlocal completefunc=javacomplete#CompleteParamsInfo
inoremap <C-O> <C-X><C-O>
" }}}
" TMUX support {{{
" Allow vim to recognize key sequences in screen terminal
if &term =~ '^screen' && exists('$TMUX')
    set mouse+=a
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
    " tmux will send xterm-style keys when xterm-keys is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
    execute "set <xHome>=\e[1;*H"
    execute "set <xEnd>=\e[1;*F"
    execute "set <Insert>=\e[2;*~"
    execute "set <Delete>=\e[3;*~"
    execute "set <PageUp>=\e[5;*~"
    execute "set <PageDown>=\e[6;*~"
    execute "set <xF1>=\e[1;*P"
    execute "set <xF2>=\e[1;*Q"
    execute "set <xF3>=\e[1;*R"
    execute "set <xF4>=\e[1;*S"
    execute "set <F5>=\e[15;*~"
    execute "set <F6>=\e[17;*~"
    execute "set <F7>=\e[18;*~"
    execute "set <F8>=\e[19;*~"
    execute "set <F9>=\e[20;*~"
    execute "set <F10>=\e[21;*~"
    execute "set <F11>=\e[23;*~"
    execute "set <F12>=\e[24;*~"
endif
" }}}
" Custom Functions {{{
let g:current_mode="default"
function WordProcessorMode() 
	if g:current_mode == "default"
		let g:current_mode="wpm"
		" Break line before one-letter words when possible
		setlocal textwidth=80
		setlocal formatoptions=t1 
		setlocal noexpandtab 
		setlocal spell spelllang=en_us 
		set spellcapcheck=""
		" Add dictionary to contextual completion
		set dictionary=/usr/share/dict/words
		set complete+=k
		setlocal wrap 
		setlocal linebreak
	else
		let g:current_mode="default"
		setlocal formatoptions=tcq
		setlocal expandtab
		setlocal nospell
		set complete-=k
		setlocal nowrap
		setlocal nolinebreak
	endif
endfunction 
command WP call WordProcessorMode()
" }}}
