" General configuration {{{
" vim:fdm=marker
set nocp " Disable Vi-compatibility settings
set hidden " Hides buffers instead of closing them, allows opening new buffers when current has unsaved changes
"set title " Show title in terminal
set number " Show line numbers
set wrap " Wrap lines
set linebreak " Break line on word
set hlsearch " Highlight search term in text
set incsearch " Show search matches as you type
set wrapscan " Automatically wrap search when hitting bottom
set autoindent " Enable autoindenting
set copyindent " Copy indent of previous line when autoindenting
set history=1000 " Command history
set undolevels=500 " Levels of undo
set wildignore=*.class " Ignore .class files
set tabstop=4 " Tab size
set expandtab " Spaces instead of tabs
set softtabstop=4 " Treat n spaces as a tab
set shiftwidth=4 " Tab size for automatic indentation
set shiftround " When using shift identation, round to multiple of shift width
set laststatus=2 " Always show statusline on last window
set pastetoggle=<F3> " Toggle paste mode
set mouse=a " Allow using mouse to change cursor position
set timeoutlen=300 " Timeout for entering key combinations
set t_Co=256 " Enable 256 colors
set tw=80 " Maximum width in characters
set foldmethod=marker " Use vim markers for folding
set foldnestmax=2 " Maximum nested folds
set noshowmatch " Do not temporarily jump to match when inserting an end brace
set cursorline " Highlight current line
set lazyredraw " Conservative redrawing
syntax on " Enable syntax highlighting
filetype indent on " Enable filetype-specific indentation
filetype plugin on " Enable filetype-specific plugins

" Backup settings
set backup " Back up previous versions of files
set backupdir=$HOME/.vim/backup// " Store backups in a central directory
set backupdir+=. " Alternatively, store backups in the same directory as the file
" Create backup directory if it does not exist
if !isdirectory($HOME . '/.vim/backup/')
    call mkdir($HOME . '/.vim/backup/')
endif

" GUI settings
set guioptions-=L "Remove left-hand scrollbar
set guioptions-=r "Remove right-hand scrollbar
set guioptions-=T "Remove toolbar
set guifont=Monaco\ 10 "Set gui font

" Session settings
set ssop-=options    " Do not save global and local values
set ssop-=folds      " Do not save folds

" Autocommands 
" Execute runtime configurations for plugins
autocmd VimEnter * call PluginConfig()
" Change statusline color when entering insert mode: (23 is a greenish-blue #005f5f, #073642 is solarized bluish)
autocmd InsertEnter * call RefreshColors(23, '#073642')
autocmd InsertLeave * call RefreshColors(235, '#262626')
" }}}
" Custom mappings {{{
:command Q q
:command W w
cmap Q! q!
" Prevent Ex Mode
map Q <Nop>
" Use jj to exit insert mode, rather than <Esc>
inoremap jj <Esc>
" Use Control + (hjkl) to mimic arrow keys for navigating menus in insert mode
inoremap <C-j> <Up>
inoremap <C-k> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
" Smart indent when entering insert mode
nnoremap <expr> i SmartInsertModeEnter()
" Easy buffer switching
:command B call feedkeys("\<F5>") "Use the <F5> mapping
nmap <F5> :buffers<CR>:buffer<Space>
nnoremap t :tabnew
"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>
" Allow saving when forgetting to start vim with sudo
cmap w!! w !sudo tee > /dev/null %
" Easy toggle for paste
nnoremap <C-p> :set paste!<CR>:echo "Paste mode: " . &paste<CR>
" Easy page up/down
nnoremap <C-Up> <C-u>
nnoremap <C-Down> <C-d>
nnoremap <C-k> <C-u>
nnoremap <C-j> <C-d>
" Allow window commands in insert mode (currently overridden by omnicomplete binding)
" imap <C-w> <C-o><C-w>
nnoremap <A-Up> <C-w><Up>
nnoremap <A-Down> <C-w><Down>
nnoremap <A-Left> <C-w><Left>
nnoremap <A-Right> <C-w><Right>
" Mapping alt+(hjkl) doesn't work, so we use escape codes instead
nnoremap k <C-w><Up>
nnoremap j <C-w><Down>
nnoremap h <C-w><Left>
nnoremap l <C-w><Right>
" Note: <bar> denotes |
" Shortcuts for window commands
nnoremap <bar> <C-w>v
nnoremap <bar><bar> :vnew<CR><C-w>L
nnoremap _ <C-w>s
nnoremap __ <C-w>n
nnoremap - <C-w>-
nnoremap + <C-w>+
nnoremap > <C-w>>
nnoremap < <C-w><
" Mappings to move window splits
nnoremap <Space><Left> <C-w>H
nnoremap <Space><Right> <C-w>L
nnoremap <Space><Up> <C-w>K
nnoremap <Space><Down> <C-w>J
nnoremap <Space>h <C-w>H
nnoremap <Space>l <C-w>L
nnoremap <Space>k <C-w>K
nnoremap <Space>j <C-w>J
" Easy system clipboard copy/paste
vnoremap <C-c> "+y
vnoremap <C-x> "+x
inoremap <C-S-v> <Esc>"+pi
iunmap <C-V>
" Mapping for autoformat
nnoremap <C-f> gq
nnoremap <C-S-f> mkggVGgq'k
" Spell ignore commands
command SpellIgnoreOnce normal zG
command SpellIgnore normal zg
" Navigation mappings
" Jump to beginning of tag
nnoremap {{ vat<Esc>'<
" Jump to end of tag
nnoremap }} vat<Esc>'>
nnoremap <Tab> ==
vnoremap <Tab> =
" Easy delete to black hole register
nnoremap D "_dd
" Quick change syntax highlighting color for dark background
nnoremap <S-i> :call ReverseColors()<CR>
" Quick toggle terminal background transparency
nnoremap <S-t> :call ToggleTransparentTerminalBackground()<CR>
" Quick toggle fold method
nnoremap <S-f> :call ToggleFoldMethod()<CR>
" }}}
" Plugins configuration {{{
call pathogen#infect()
let g:ConqueTerm_Color = 1
let g:ConqueTerm_TERM = 'xterm-256color'
let g:ConqueTerm_PromptRegex = '^\w\+@[0-9A-Za-z_.-]\+:[0-9A-Za-z_./\~,:-]\+\$'
let g:indentLine_char = '┆'
command Tree NERDTreeTabsToggle
let g:SuperTabDefaultCompletionType = 'context'
" Disable easytag's warning about vim's updatetime being too low
let g:easytags_updatetime_warn = 0
let g:nerdtree_tabs_open_on_gui_startup = 1
let g:nerdtree_tabs_open_on_console_startup = 1
let g:nerdtree_tabs_no_startup_for_diff = 1
let g:nerdtree_tabs_smart_startup_focus = 1
let g:nerdtree_tabs_open_on_new_tab = 1
let g:nerdtree_tabs_meaningful_tab_names = 1
let g:nerdtree_tabs_autoclose = 1
let g:nerdtree_tabs_synchronize_view = 1
let g:nerdtree_tabs_synchronize_focus = 1
let g:gundo_width = 30
let g:gundo_preview_height = 20
let g:gundo_right = 1
let g:gundo_preview_bottom = 1
let g:notes_directories = ['~/Dropbox/Shared Notes']
command DiffTree GundoToggle
" }}}
" Functions for generating statusline {{{
function GitBranch()
    let output=system("git branch | grep '*' | grep -o '\\([A-Za-z0-9]\\+\\s\\?\\)\\+'")
    if output=="" " git branch returns NOTHING i.e '' if not in a git repo, not an error message as expected...
        return ""
    else
        return "[Git][" . output[0 : strlen(output)-2] . " " " Strip newline ^@
    endif
endfunction
function GitStatus()
    let output=system('git status')
    let retStr=""
    if output=="" 
        return ""
    endif
    if output=~"Changes to be committed"
        let retStr.="\u2718"
    else
        let retStr.="\u2714"
    endif
    if output=~"modified"
        let retStr.=" \u0394"
    endif
    let retStr.="]"
    return retStr
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
    "Green
    exe 'hi User6 ctermfg=34 ctermbg=' . a:statusLineColor 'cterm=bold term=bold gui=bold guifg=#00af00 guibg=' . a:gui_statusLineColor
    "Status line of current window
    exe 'hi StatusLine term=bold cterm=bold gui=bold ctermfg=118 ctermbg=' . a:statusLineColor 'guifg=#87ff00 guibg=' . a:gui_statusLineColor
    "Status line color for noncurrent window
    exe 'hi StatusLineNC term=bold cterm=bold gui=bold ctermfg=255 ctermbg=' . a:statusLineColor 'guifg=#eeeeee guibg=' . a:gui_statusLineColor
    "Line numbers
    exe 'hi LineNr ctermfg=118 ctermbg=' . a:statusLineColor 'guifg=#87ff00 guibg=' . a:gui_statusLineColor
    "Vertical split divider
    exe 'hi VertSplit term=bold cterm=bold gui=bold ctermfg=43 ctermbg=' a:statusLineColor 'guifg=#00d7af guibg=' . a:gui_statusLineColor
    "Nonselected tabs
    exe 'hi TabLine ctermfg=118 cterm=none ctermbg=' . a:statusLineColor 
    "Empty space on tab bar
    exe 'hi TabLineFill term=bold cterm=bold gui=bold ctermbg=' . a:statusLineColor
    "Selected tab
    exe 'hi TabLineSel ctermfg=45 ctermbg=' . a:statusLineColor 
    "Folds colorscheme
    hi Folded ctermfg=39 ctermbg=235 guifg=#00afff guibg=#262626
    "Visual mode selection color 
    hi Visual ctermbg=241 guibg=#626262
    "Spell-check highlights
    hi SpellBad    ctermbg=NONE ctermfg=160 cterm=underline,bold guisp=#FF0000 gui=undercurl
    hi SpellCap    ctermbg=NONE ctermfg=214 cterm=underline,bold guisp=#7070F0 gui=undercurl
    hi SpellLocal  ctermbg=NONE ctermfg=51 cterm=underline,bold guisp=#70F0F0 gui=undercurl
    hi SpellRare   ctermbg=NONE ctermfg=195 cterm=underline,bold guisp=#FFFFFF gui=undercurl
    "Current line highlighting
    hi CursorLineNr cterm=bold gui=bold ctermbg=238 guibg=#444444 ctermfg=43 guifg=#00d7af
    hi CursorLine cterm=NONE gui=NONE 
    "PLUGINS
    "indentLine plugin
    exe 'let g:indentLine_color_term = ' . a:statusLineColor
endfunction

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
    set statusline+=\ %6*%{gitBranch}%* "Git branch
    set statusline+=%6*%{gitStatus}%* "Git status
endif
set statusline+=%=      "left/right separator
"set statusline+=%3*%F%*\ %4*\|%*\   "file path with full names
set statusline+=%5*%{SyntasticStatuslineFlag()}%*\ 
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
                            " Do not show NERDTree or Gundo in the bufferlist
                            " Use a variable to keep track of whether a new name
                            " was added
                            let newBufNameAdded = 1 
                            if bufname(b) =~ "NERD" || bufname(b) =~ "Gundo"
                                let newBufNameAdded = 0
                            else
                                let n .= pathshorten(bufname(b))
                            endif
                        endif
                        " check and ++ tab's &modified count
                        if getbufvar( b, "&modified" )
                                let m += 1
                        endif
                        " no final ' ' added...formatting looks better done later
                        if bc > 1 && newBufNameAdded == 1
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
                " Remove excess whitespace
                let s = DeflateWhitespace(s)
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
" Autocompletion {{{
set completeopt=longest,menuone
inoremap <C-O> <C-X><C-O>
inoremap <C-U> <C-X><C-U>
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

" This function is called by autocmd when vim starts
function! PluginConfig()
    if exists(":PingEclim") && !(eclim#PingEclim(0))
        echom "Eclimd not started"
    endif
    if !exists(":PingEclim") || (!(eclim#PingEclim(0)) && isdirectory(expand("$HOME/.vim/bundle/javacomplete")))
        echom "Enabling javacomplete for java files because eclimd is not started"
        autocmd Filetype java setlocal omnifunc=javacomplete#Complete
        autocmd Filetype java setlocal completefunc=javacomplete#CompleteParamsInfo
        if &filetype == 'java'
            setlocal omnifunc=javacomplete#Complete
            setlocal completefunc=javacomplete#CompleteParamsInfo
        endif
    else
        echom "Eclim enabled"
        let g:EclimCompletionMethod = 'omnifunc'
    endif
endfunction
let g:current_mode="default"
function! WordProcessorMode() 
	if g:current_mode == "default"
		let g:current_mode="wpm"
		" Break line before one-letter words when possible
		setlocal textwidth=80
		setlocal formatoptions=t1 
		setlocal noexpandtab 
		setlocal spell spelllang=en_us 
		setlocal spellcapcheck=""
		" Add dictionary to contextual completion
		setlocal dictionary=/usr/share/dict/words
		setlocal complete+=k
		setlocal wrap 
		setlocal linebreak
	else
		let g:current_mode="default"
		setlocal formatoptions=tcq
		setlocal expandtab
		setlocal nospell
		setlocal complete-=k
	endif
endfunction 
command WPM call WordProcessorMode()
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
command! DiffSaved call s:DiffWithSaved()
" Close the diff and return to last modified buffer
command! DiffQuit diffoff | b#
function! Molokai()
    if !has("gui_running")
        let g:rehash256 = 1
    endif
    colorscheme molokai
    call RefreshColors(235, '#262626')
endfunction
command Molokai call Molokai()
function! Default()
    colorscheme default
    hi Normal ctermbg=235
    call RefreshColors(235, '#262626')
endfunction
command Default call Default()
function! Solarized()
    syntax enable
    set background=dark
    colorscheme solarized
    call RefreshColors(235, '#262626')
endfunction
command Solarized call Solarized()
" Store default bg color
let g:original_bg_color = synIDattr(synIDtrans(hlID('Normal')), 'bg')
function! ToggleTransparentTerminalBackground()
    if (synIDattr(synIDtrans(hlID('Normal')), 'bg')) == -1
        if (g:original_bg_color == -1)
            exe "hi Normal ctermbg=NONE"
        else
            exe "hi Normal ctermbg=" . g:original_bg_color
        endif
        let g:original_bg_color = -1
    else
        let g:original_bg_color = synIDattr(synIDtrans(hlID('Normal')), 'bg')
        hi Normal ctermbg=NONE
    endif
endfunction
function! ToggleFoldMethod()
    if &foldmethod == "marker"
        setlocal foldmethod=syntax
    elseif &foldmethod == "syntax"
        setlocal foldmethod=marker
    endif
    echo "Fold method set to: " . &foldmethod
endfunction
function! Rot13()
    normal mkggVGg?'k
endfunction
command Rot13 call Rot13()
function! DeflateWhitespace(string)
    let i = 0
    let newString = ""
    while i < len(a:string)
        if a:string[i] == " "
            let newString .= " "
            while a:string[i] == " "
                let i += 1
            endwhile
        endif
        let newString .= a:string[i]
        let i += 1
    endwhile
    return newString
endfunction
function! SmartInsertModeEnter()
    if len(getline('.')) == 0
        return "cc"
    else
        return "i"
    endif
endfunction


" }}}
" Abbreviations {{{
" }}}
" Filetype-specific settings {{{
autocmd filetype java call s:FileType_Java()
function s:FileType_Java()
    iabbrev psvm public static void main(String[] args)
    iabbrev sysout System.out.println("");<esc>2hi
    iabbrev syserr System.err.println("");<esc>2hi
endfunction
autocmd filetype c call s:FileType_C()
function s:FileType_C()
    iabbrev #<defaults> #include <stdio.h><CR>#include <stdlib.h>
endfunction
" }}}
" Pre-start function calls {{{
if has("gui_running")
    call Molokai()
else
    call Molokai() | call ToggleTransparentTerminalBackground()
endif

" }}}
" Add the virtualenv's site-packages to vim path
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

