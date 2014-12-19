" General configuration {{{
" vim:fdm=marker
set nocompatible " Disable Vi-compatibility settings
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
set textwidth=80 " Maximum width in characters
set foldmethod=marker " Use vim markers for folding
set foldnestmax=2 " Maximum nested folds
set noshowmatch " Do not temporarily jump to match when inserting an end brace
set cursorline " Highlight current line
set lazyredraw " Conservative redrawing
syntax on " Enable syntax highlighting
filetype indent on " Enable filetype-specific indentation
filetype plugin on " Enable filetype-specific plugins

" Autocompletion settings
set completeopt=menuone,preview

" Command line completion settings
set wildmode=longest,list,full
set wildmenu

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
set winaltkeys=no "Disable use of alt key to access menu

" Session settings
set sessionoptions-=options    " Do not save global and local values
set sessionoptions-=folds      " Do not save folds

" Autocommands
augroup defaults
    " Clear augroup
    autocmd!
    " Execute runtime configurations for plugins
    autocmd VimEnter * call PluginConfig()
    autocmd BufWritePost * call RefreshGitInfo()
    " Change statusline color when entering insert mode
    autocmd InsertEnter * call RefreshColors(g:insertModeStatuslineColor_cterm, g:insertModeStatuslineColor_gui)
    autocmd InsertLeave * call ToggleStatuslineColor()
augroup END

" List/listchars
set list
execute "set listchars=tab:\u2592\u2592,trail:\u2591"
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
inoremap <C-k> <Up>
inoremap <C-j> <Down>
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
vnoremap <C-k> <C-u>
vnoremap <C-j> <C-d>

" Allow window commands in insert mode (currently overridden by omnicomplete binding)
" imap <C-w> <C-o><C-w>
" Easy split navigation using alt key
nnoremap <A-Up> <C-w><Up>
nnoremap <A-Down> <C-w><Down>
nnoremap <A-Left> <C-w><Left>
nnoremap <A-Right> <C-w><Right>
nnoremap <A-k> <C-w><Up>
nnoremap <A-j> <C-w><Down>
nnoremap <A-h> <C-w><Left>
nnoremap <A-l> <C-w><Right>
" Mapping alt+(hjkl) doesn't work in terminal, so we use escape codes instead
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
" Autocompletion bindings
inoremap <C-O> <C-X><C-O>
inoremap <C-U> <C-X><C-U>
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
" Custom functions {{{

" This function is called by autocmd when vim starts
function! PluginConfig()
    if exists(":PingEclim") && !(eclim#PingEclim(0))
        echom "Eclimd not started"
    endif
    if !exists(":PingEclim") || (!(eclim#PingEclim(0)) && isdirectory(expand("$HOME/.vim/bundle/javacomplete")))
        echom "Enabling javacomplete for java files because eclimd is not started"
        autocmd Filetype java setlocal omnifunc=javacomplete#Complete
        autocmd Filetype java setlocal completefunc=javacomplete#CompleteParamsInfo
        if &filetype ==? 'java'
            setlocal omnifunc=javacomplete#Complete
            setlocal completefunc=javacomplete#CompleteParamsInfo
        endif
    else
        echom "Eclim enabled"
    endif
endfunction
let g:current_mode="default"
function! WordProcessorMode()
    if g:current_mode ==# "default"
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
  execute "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
command! DiffSaved call s:DiffWithSaved()
" Close the diff and return to last modified buffer
command! DiffQuit diffoff | b#
function! Molokai()
    if !has("gui_running")
        let g:rehash256 = 1
    endif
    colorscheme molokai
    call ToggleStatuslineColor()
endfunction
command Molokai call Molokai()
function! Default()
    colorscheme default
    "Visual mode selection color
    highlight Visual ctermbg=241 guibg=#626262
    highlight CursorLine ctermbg=236 guibg=#303030
    call ToggleStatuslineColor()
endfunction
command Default call Default()
function! Solarized()
    syntax enable
    set background=dark
    colorscheme solarized
    highlight Folded term=NONE cterm=NONE gui=NONE
    call ToggleStatuslineColor()
endfunction
command Solarized call Solarized()
function! ToggleStatuslineColor()
    call RefreshColors(g:defaultStatuslineColor_cterm, g:defaultStatuslineColor_gui)
endfunction
command ToggleStatuslineColor call ToggleStatuslineColor()
function! FlatColor()
    colorscheme flatcolor-transparent
    call ToggleStatuslineColor()
    " No harsh white cursorlines
    hi CursorLine ctermbg=235 guibg=#262626
    " No underlines in NERDTree, red Titles
    hi Title cterm=NONE gui=bold ctermfg=166 guifg=#ef5939
    hi Visual ctermbg=237 guibg=#3a3a3a
    hi Search ctermbg=37 guibg=#1ABC9C
    hi IncSearch ctermbg=37 guibg=#1ABC9C
    hi NonText ctermbg=NONE
endfunction
command FlatColor call FlatColor()
" Store default bg color
let g:original_bg_color = synIDattr(synIDtrans(hlID('Normal')), 'bg')
function! ToggleTransparentTerminalBackground()
    if (synIDattr(synIDtrans(hlID('Normal')), 'bg')) == -1
        if (g:original_bg_color == -1)
            execute "highlight Normal ctermbg=NONE"
        else
            execute "highlight Normal ctermbg=" . g:original_bg_color
        endif
        let g:original_bg_color = -1
    else
        let g:original_bg_color = synIDattr(synIDtrans(hlID('Normal')), 'bg')
        highlight Normal ctermbg=NONE
    endif
endfunction
function! ToggleFoldMethod()
    if &foldmethod ==? "marker"
        setlocal foldmethod=syntax
    elseif &foldmethod ==? "syntax"
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
function! LAG()
    set cursorline! " Toggle cursorline
    set number! " Toggle line numbers
    if &laststatus == 2
        set laststatus=0 " Disable statusline
    else
        set laststatus=2 " Enable statusline
    endif
endfunction
command LAG call LAG()
function! RemoveWhitespace()
    % !sed 's/[ \t]*$//'
endfunction
command RemoveWhitespace call RemoveWhitespace()

" }}}
" Custom colorscheme {{{
" Note that these highlight commands have to be formed with concatenation and then
" be evaluated with :execute because :highlight does not accept variables as arguments
function s:Highlight(group, term, cterm, ctermfg, ctermbg, gui, guifg, guibg, guisp, font)
    execute 'highlight clear ' . a:group
    let cmd = 'highlight '
    let cmd .= a:group
    if !empty(a:term)
        let cmd .= ' term=' . a:term
    endif
    if !empty(a:cterm)
        let cmd .= ' cterm=' . a:cterm
    endif
    if !empty(a:ctermfg)
        let cmd .= ' ctermfg=' . a:ctermfg
    endif
    if !empty(a:ctermbg)
        let cmd .= ' ctermbg='. a:ctermbg
    endif
    if !empty(a:gui)
        let cmd .= ' gui=' . a:gui
    endif
    if !empty(a:guifg)
        let cmd .= ' guifg=' . a:guifg
    endif
    if !empty(a:guibg)
        let cmd .= ' guibg='. a:guibg
    endif
    if !empty(a:guisp)
        let cmd .= ' guisp=' . a:guisp
    endif
    if !empty(a:font)
        let cmd .= ' font=' . a:font
    endif
    execute cmd
endfunction
function s:ColorschemeInit()
    "Folds colorscheme
    call s:Highlight('Folded', '', '', '39', '235', '', '#00afff', '#262626', '', '')
    "Spell-check highlights
    call s:Highlight('SpellBad', '', 'underline,bold', '160', '', 'undercurl', '', '', '#D70000', '')
    call s:Highlight('SpellCap', '', 'underline,bold', '214', '', 'undercurl', '', '', '#FFAF00', '')
    call s:Highlight('SpellLocal', '', 'underline,bold', '51', '', 'undercurl', '', '', '#5FFFFF', '')
    call s:Highlight('SpellRare', '', 'underline,bold', '195', '', 'undercurl', '', '', '#DFFFFF', '')
endfunction

" }}}
" Statusline {{{
" Functions for generating statusline {{{
function GitBranch()
    let output=system("git branch | grep '*' | grep -o '\\([A-Za-z0-9]\\+\\s\\?\\)\\+'")
    if output=="" || output=~"fatal" " git branch returns NOTHING i.e '' if not in a git repo, not an error message as expected...
        return ""
    else
        return "[Git][" . output[0 : strlen(output)-2] . " " " Strip newline ^@
    endif
endfunction
function GitStatus()
    let output=system('git status')
    let retStr=""
    if output=="" || output=~"fatal"
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
    if output=="" || output=~"fatal" " Checkpoint for error
        return ""
    elseif output =~ "local out of date"
        return "(!)Local repo out of date: Use git pull"
    else
        return ""
    endif
endfunction
function! RefreshGitInfo()
    let g:gitBranch=GitBranch()
    let g:gitStatus=GitStatus() . " " . GitRemote(g:gitBranch)
endfunction
call RefreshGitInfo()
" }}}
" Custom statusline {{{
set statusline=%t       "tail of the filename
set statusline+=%y      "filetype
if winwidth(0) > 85
    set statusline+=[%{strlen(&fenc)?&fenc:'none'}\|  "file encoding
    set statusline+=%{&ff}]                           "file format
endif
set statusline+=%#Orange_202#%r%##      "read only flag
set statusline+=%#Blue_51#%m\%##        "modified flag
set statusline+=%h                      "help file flag
set statusline+=\ B:%n                  "buffer number
if winwidth(0) > 100
    set statusline+=\ %#Green_34#%{gitBranch}%## "Git branch
    set statusline+=%#Green_34#%{gitStatus}%##   "Git status
endif
set statusline+=%=                                        "left/right separator
set statusline+=%#Red_196#%{SyntasticStatuslineFlag()}%## "Syntastic plugin flag
"set statusline+=%3*%F%*\ %4*\|%*\                        "file path with full names
set statusline+=%#Blue_39#%{pathshorten(expand('%:p'))}%##%#Green_41#\|%##  "file path with truncated names
set statusline+=C:%2c\                  "cursor column, reserve 2 spaces
set statusline+=R:%3l/%3L               "cursor line/total lines, reserve 3 spaces for each
set statusline+=%#Green_41#\|%##%3p     "percent through file, reserve 3 spaces
set statusline+=%%                      "percent symbol
" }}}
" Statusline color changing function {{{
function RefreshColors(statusLineColor, gui_statusLineColor)
    let l:isEnteringInsertMode = 0
    if a:statusLineColor == g:insertModeStatuslineColor_cterm
        let l:isEnteringInsertMode = 1
    endif
    call s:Highlight('Orange_202', 'bold', 'bold', '202', a:statusLineColor, 'bold', '#FF5F00', a:gui_statusLineColor, '', '')
    call s:Highlight('Blue_51', 'bold', 'bold', '51', a:statusLineColor, 'bold', '#00FFFF', a:gui_statusLineColor, '', '')
    call s:Highlight('Blue_39', 'bold', 'bold', '39', a:statusLineColor, 'bold', '#00AFFF', a:gui_statusLineColor, '', '')
    call s:Highlight('Green_41', 'bold', 'bold', '41', a:statusLineColor, 'bold', '#2ECC71', a:gui_statusLineColor, '', '')
    call s:Highlight('Red_196', 'bold', 'bold', '196', a:statusLineColor, 'bold', '#FF0000', a:gui_statusLineColor, '', '')
    call s:Highlight('Green_34', 'bold', 'bold', '34', a:statusLineColor, 'bold', '#00AF00', a:gui_statusLineColor, '', '')
    "Status line of current window
    call s:Highlight('StatusLine', 'bold', 'bold', '118', a:statusLineColor, 'bold', '#87FF00', a:gui_statusLineColor, '', '')
    "Status line color for noncurrent window
    call s:Highlight('StatusLineNC', 'bold', 'bold', '255', a:statusLineColor, 'bold', '#FFFFFF', a:gui_statusLineColor, '', '')
    "Line numbers
    call s:Highlight('LineNr', '', '', '118', a:statusLineColor, '', '#87FF00', a:gui_statusLineColor, '', '')
    "Vertical split divider
    call s:Highlight('VertSplit', 'bold', 'bold', '43', a:statusLineColor, 'bold', '#00D7AF', a:gui_statusLineColor, '', '')
    "Nonselected tabs
    call s:Highlight('TabLine', '', '', '118', a:statusLineColor, '', '#87FF00', a:gui_statusLineColor, '', '')
    "Empty space on tab bar
    call s:Highlight('TabLineFill', '', '', '', a:statusLineColor, '', '', a:gui_statusLineColor, '', '')
    "Selected tab
    if l:isEnteringInsertMode == 1
        call s:Highlight('TabLineSel', '', '', '45', a:statusLineColor, '', '#00D7FF', a:gui_statusLineColor, '', '')
    else
        call s:Highlight('TabLineSel', '', '', '255', '23', '', '#FFFFFF', '#005F5F', '', '')
    endif
    "Current line highlighting
    if l:isEnteringInsertMode == 1
        call s:Highlight('CursorLineNr', 'bold', 'bold', '45', '23', 'bold', '#00D7FF', '#005F5F', '', '')
    else
        call s:Highlight('CursorLineNr', 'bold', 'bold', '255', '23', 'bold', '#FFFFFF', '#005F5F', '', '')
    endif

    "PLUGINS HIGHLIGHTING
    "indentLine plugin
    execute 'let g:indentLine_color_term = ' . a:statusLineColor
endfunction

function ReverseColors()
    if &background == "light"
        set background=dark
    else
        set background=light
    endif
    call ToggleStatuslineColor()
endfunction
" }}}
" }}}
" {{{ Constants
let g:defaultStatuslineColor_cterm = 235
let g:defaultStatuslineColor_gui = '#262626'
let g:insertModeStatuslineColor_cterm = 23
let g:insertModeStatuslineColor_gui = '#073642'
" }}}
" Plugins configuration/constants {{{
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
command DiffTree GundoToggle
let g:notes_directories = ['~/Dropbox/Shared Notes']
let g:EclimCompletionMethod = 'omnifunc'
let g:calendar_google_calendar = 0
let g:calendar_google_task = 0
let g:calendar_cache_directory = expand('~/Dropbox/Shared Notes/calendar.vim')

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
                if bufname(b) =~# "NERD" || bufname(b) =~# "Gundo"
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
        " Add close button
        let s .= '%=%#TabLineFill#%999X%#Red_196#Close%##'
    endif
    return s
endfunction
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
" Filetype-specific settings/abbreviations {{{
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
" Pre-start function calls (non-autocommand) {{{
if has("gui_running")
    call FlatColor()
else
    call FlatColor()
endif
call s:ColorschemeInit()
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

