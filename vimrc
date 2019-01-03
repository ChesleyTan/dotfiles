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
set wildignore=*.class " Ignore .class files
set tabstop=4 " Tab size
set expandtab " Spaces instead of tabs
set softtabstop=4 " Treat n spaces as a tab
set shiftwidth=4 " Tab size for automatic indentation
set shiftround " When using shift identation, round to multiple of shift width
set laststatus=2 " Always show statusline on last window
set pastetoggle=<F3> " Toggle paste mode
set mouse=nvc " Allow using mouse to change cursor position in normal, visual,
              " and command line modes
set timeoutlen=300 " Timeout for completing keymapping
set t_Co=256 " Enable 256 colors
set textwidth=100 " Maximum width in characters
set synmaxcol=150 " Limit syntax highlight parsing to first 150 columns
set foldmethod=marker " Use vim markers for folding
set foldnestmax=4 " Maximum nested folds
set noshowmatch " Do not temporarily jump to match when inserting an end brace
set cursorline " Highlight current line
set lazyredraw " Conservative redrawing
set backspace=indent,eol,start " Allow full functionality of backspace
set scrolloff=2 " Keep cursor 2 rows above the bottom when scrolling
set nofixendofline " Disable automatic adding of EOL
let mapleader = ' '
let maplocalleader = '\'
syntax enable " Enable syntax highlighting
filetype indent on " Enable filetype-specific indentation
filetype plugin on " Enable filetype-specific plugins
colorscheme default " Set default colors
if has('nvim') || has('termguicolors')
    set termguicolors " Enable gui colors in terminal (i.e., 24-bit color)
endif

" List/listchars
set list
execute "set listchars=tab:\u2592\u2592,trail:\u2591"

" Autocompletion settings
set completeopt=longest,menuone,preview
set pumheight=10 " Maximum height of pop-up menu window

" Command line completion settings
set wildmode=longest,list,full
set wildmenu

" Create ~/.vim directory if it does not exist
if !isdirectory($HOME . '/.vim/')
    call mkdir($HOME . '/.vim/')
endif

" Backup settings
set directory=. "Store swapfiles in the same directory as the file
set backup " Back up previous versions of files
set backupdir=$HOME/.vim/backup// " Store backups in a central directory
set backupdir+=. " Alternatively, store backups in the same directory as the file
" Create backup directory if it does not exist
if !isdirectory($HOME . '/.vim/backup/')
    call mkdir($HOME . '/.vim/backup/')
endif

" Persistent undo settings
set undofile " Save undo history
set undodir=$HOME/.vim/backup/undo// " Store undo history in a central directory
set undodir+=. " Alternatively, store undo history in the same directory as the file
set undolevels=1000 " Save a maximum of 1000 undos
set undoreload=10000 " Save undo history when reloading a file
" Create undo history directory if it does not exist
if !isdirectory($HOME . '/.vim/backup/undo')
    call mkdir($HOME . '/.vim/backup/undo')
endif

" Spell settings
set spellfile=$HOME/T/vim/spell/en.utf-8.add

" GUI settings
set guioptions-=L "Remove left-hand scrollbar
set guioptions-=r "Remove right-hand scrollbar
set guioptions-=T "Remove toolbar
set guioptions-=e "Remove GUI-style tabline
set guifont=Source\ Code\ Pro\ 12 "Set gui font
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
    " Regenerate statusline to truncate intelligently
    autocmd VimResized * call SetStatusline()
    autocmd WinEnter * call SetStatusline()
    autocmd BufEnter * call SetStatusline()
    " Refresh git information when file is changed
    autocmd BufWritePost * call RefreshGitInfo()
    " Change statusline color when entering insert mode
    autocmd InsertEnter * call RefreshColors(g:insertModeStatusLineColor_ctermfg, g:insertModeStatusLineColor_guifg, g:insertModeStatusLineColor_ctermbg, g:insertModeStatusLineColor_guibg)
    autocmd InsertLeave * call ToggleStatuslineColor()
augroup END
" }}}
" Constants/Global variables {{{
let g:scriptsDirectory = expand("$HOME/.vim/scripts/")
let g:showGitInfo = 1 " This determines whether to show git info in statusline
let g:inGitRepo = 0
let g:gitInfo = "" " Placeholder value to initialize variable
" }}}
" Custom mappings {{{
function! s:SetMappings()
    command! Q q
    command! W w
    cmap Q! q!
    " Prevent Ex Mode
    map Q <Nop>
    " Use jj to exit insert mode, rather than <Esc>
    inoremap jj <Esc>
    " Use jk to exit insert mode, rather than <Esc>
    inoremap jk <Esc>
    " Map ; to : in normal mode
    nnoremap ; :
    " Map : to ; in normal mode
    nnoremap : ;
    " Use <LocalLeader>k to insert digraph
    inoremap <LocalLeader>k <C-k>
    " Use Control + (hjkl) to mimic arrow keys for navigating menus in insert mode
    inoremap <C-k> <Up>
    inoremap <C-j> <Down>
    inoremap <C-h> <Left>
    inoremap <C-l> <Right>
    inoremap <expr> <Tab> pumvisible() ? "\<C-N>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-P>" : "\<S-Tab>"
    " Smart indent when entering insert mode
    nnoremap <expr> i SmartInsertModeEnter()
    " Easy buffer switching
    nnoremap <Leader>b :buffers<CR>:buffer<Space>
    nnoremap t :tabnew 
    " Clear hlsearch using Return/Enter
    nnoremap <CR> :noh<CR><CR>
    " Allow saving when forgetting to start vim with sudo
    if has('nvim')
        " Use suda.vim plugin if neovim
        cmap w!! w suda://%
    else
        cmap w!! w !sudo tee > /dev/null %
    endif
    " Easy delete to black hole register
    nnoremap D "_dd
    " Center selected text with surrounding whitespace
    vnoremap . :call CenterSelection()<CR>
    " Easy page up/down
    nnoremap <C-Up> <C-u>
    nnoremap <C-Down> <C-d>
    nnoremap <C-k> 3k
    nnoremap <C-j> 3j
    vnoremap <C-k> 3k
    vnoremap <C-j> 3j
    " Allow window commands in insert mode (currently overridden by omnicomplete binding)
    " Easy split navigation using alt key
    nnoremap <A-Up> <C-w><Up>
    nnoremap <A-Down> <C-w><Down>
    nnoremap <A-Left> <C-w><Left>
    nnoremap <A-Right> <C-w><Right>
    nnoremap <A-k> <C-w><Up>
    nnoremap <A-j> <C-w><Down>
    nnoremap <A-h> <C-w><Left>
    nnoremap <A-l> <C-w><Right>
    " Note: <bar> denotes |
    " Shortcuts for window commands
    nnoremap <bar> <C-w>v
    nnoremap <bar><bar> :vnew<CR><C-w>L
    nnoremap _ <C-w>s
    nnoremap __ <C-w>n
    nnoremap - <C-w>-
    nnoremap + <C-w>+
    nnoremap > <C-w>>:call SetStatusline()<CR>
    nnoremap < <C-w><:call SetStatusline()<CR>
    " Mappings to move window splits
    nnoremap <A-S-Left> <C-w>H
    nnoremap <A-S-Right> <C-w>L
    nnoremap <A-S-Up> <C-w>K
    nnoremap <A-S-Down> <C-w>J
    nnoremap <A-H> <C-w>H
    nnoremap <A-L> <C-w>L
    nnoremap <A-K> <C-w>K
    nnoremap <A-J> <C-w>J
    " Goto commands
    command! GotoWindow normal <C-w>f
    command! GotoTab normal <C-w>gf
    " Navigation mappings
    nnoremap <Tab> gt
    nnoremap <S-Tab> gT
    " Easy system clipboard copy/paste
    vnoremap <C-c> "+y
    vnoremap <C-x> "+x
    inoremap <C-p> <Left><C-o>"+p
    " Select last pasted text
    nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
    " Delete to first character on line
    inoremap <C-u> <C-o>d^
    " Spell ignore commands
    command! SpellIgnore normal zg
    command! SpellIgnoreRemove normal zug
    command! SpellIgnoreOnce normal zG
    command! SpellIgnoreOnceRemove normal zuG
    command! SpellWrong normal zw
    command! SpellWrongRemove normal zuw
    command! SpellWrongOnce normal zW
    command! SpellWrongOnceRemove normal zuW
    command! SpellSuggest normal z=
    " Search forwards for selected text
    vnoremap <silent> * :<C-u>
    \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    \gvy/<C-r><C-r>=substitute(
    \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    \gV:call setreg('"', old_reg, old_regtype)<CR>
    " Search backwards for selected text
    vnoremap <silent> # :<C-u>
    \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    \gvy?<C-r><C-r>=substitute(
    \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    \gV:call setreg('"', old_reg, old_regtype)<CR>
    " Easy toggle for paste
    nnoremap <Leader>tp :set paste!<CR>:echo "Paste mode: " . &paste<CR>
    " Quick toggle terminal background transparency
    nnoremap <Leader>tt :call ToggleTransparentTerminalBackground()<CR>
    " Quick toggle fold method
    nnoremap <Leader>tf :call ToggleFoldMethod()<CR>
    " Quick toggle syntax highlighting
    nnoremap <Leader>ts :call ToggleSyntax()<CR>
    " Quick toggle for color column at 80 characters
    nnoremap <Leader>t8 :call ToggleColorColumn()<CR>
    " Quick toggle for automatic newline insertion at end of line
    nnoremap <Leader>te :call ToggleEOL()<CR>
    " Quick toggle for quickfix window
    nnoremap <Leader>tc :cwindow<CR><C-w>p
    " Quick toggle for location window
    nnoremap <Leader>tl :lwindow<CR><C-w>p
endfunction
" }}}
" Custom functions {{{

" This function is called by autocmd when vim starts
function! PluginConfig()
    " Javacomplete {{{
    function! s:InitJavaComplete()
        setlocal omnifunc=javacomplete#Complete
    endfunction
    augroup javacomplete
        autocmd Filetype java call s:InitJavaComplete()
    augroup END
    if &filetype ==? 'java'
        call s:InitJavaComplete()
    endif
    "}}}
    " vim-gutentags {{{
    if exists('g:gutentags_project_info')
        call add(g:gutentags_project_info, { 'type': 'rust', 'file': 'Cargo.toml' })
    endif
    " }}}
endfunction

function! WordProcessorMode()
    if !exists('b:current_mode')
        let b:current_mode="default"
    endif
    if b:current_mode ==# "default"
        let b:current_mode="wpm"
        " Break line before one-letter words when possible
        setlocal textwidth=120
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
        let b:current_mode="default"
        setlocal formatoptions=tcq
        setlocal expandtab
        setlocal nospell
        setlocal complete-=k
    endif
endfunction
command! WPM call WordProcessorMode()

function! s:DiffWithSaved()
    let filetype=&filetype
    diffthis
    vnew | r # | normal! 1Gdd
    diffthis
    execute "setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile readonly filetype=" . filetype
endfunction
command! DiffSaved call s:DiffWithSaved()
" Close the diff and return to last modified buffer
command! DiffQuit diffoff | b#

function! Solarized()
    set background=dark
    colorscheme NeoSolarized
    highlight NormalNC guibg=#00202A
    highlight ErrorMsg term=NONE cterm=NONE gui=NONE
    highlight Conceal ctermfg=239 guifg=#4E4E4E
    highlight SpellBad guifg=#DC322F
    highlight SpellCap guifg=#6C71C4
    highlight SpellLocal guifg=#B58900
    highlight SpellRare guifg=#2AA198
    highlight Underlined term=underline cterm=underline gui=underline
    call SetDefaultStatusLineColors()
    let g:defaultStatusLineColor_ctermbg = 8
    let g:defaultStatusLineColor_guibg = '#073642'
    let g:insertModeStatusLineColor_ctermbg = 30
    let g:insertModeStatusLineColor_guibg = '#005F5F'
    call ToggleStatuslineColor()
endfunction
command! Solarized call Solarized()

function! OneDark()
    set background=dark
    colorscheme onedark
    call SetDefaultStatusLineColors()
    let g:defaultStatusLineColor_ctermbg = 235
    let g:defaultStatusLineColor_guibg = '#262626'
    let g:insertModeStatusLineColor_ctermbg = 23
    let g:insertModeStatusLineColor_guibg = '#005F5F'
    call ToggleStatuslineColor()
endfunction
command! OneDark call OneDark()

function! ToggleStatuslineColor()
    call RefreshColors(g:defaultStatusLineColor_ctermfg, g:defaultStatusLineColor_guifg, g:defaultStatusLineColor_ctermbg, g:defaultStatusLineColor_guibg)
endfunction
command! ToggleStatuslineColor call ToggleStatuslineColor()

function! SetDefaultStatusLineColors()
    let g:defaultStatusLineColor_ctermfg = 118
    let g:defaultStatusLineColor_guifg = '#87FF00'
    let g:defaultStatusLineColor_ctermbg = 235
    let g:defaultStatusLineColor_guibg = '#262626'
    let g:insertModeStatusLineColor_ctermfg = 118
    let g:insertModeStatusLineColor_guifg = '#87FF00'
    let g:insertModeStatusLineColor_ctermbg = 23
    let g:insertModeStatusLineColor_guibg = '#005F5F'
endfunction

" Store default bg color
let g:original_bg_color = synIDattr(synIDtrans(hlID('Normal')), 'bg')
let g:original_nc_bg_color = synIDattr(synIDtrans(hlID('NormalNC')), 'bg')
function! ToggleTransparentTerminalBackground()
    if (synIDattr(synIDtrans(hlID('Normal')), 'bg')) == ""
        if g:original_bg_color == ""
            if (has('termguicolors') && &termguicolors == 1) || has('gui_running')
                execute "highlight Normal guibg=NONE"
                execute "highlight NormalNC guibg=NONE"
            else
                execute "highlight Normal ctermbg=NONE"
                execute "highlight NormalNC ctermbg=NONE"
            endif
        else
            if (has('termguicolors') && &termguicolors == 1) || has('gui_running')
                execute "highlight Normal guibg=" . g:original_bg_color
                execute "highlight NormalNC guibg=" . g:original_nc_bg_color
            else
                execute "highlight Normal ctermbg=" . g:original_bg_color
                execute "highlight NormalNC ctermbg=" . g:original_nc_bg_color
            endif
        endif
    else
        let g:original_bg_color = synIDattr(synIDtrans(hlID('Normal')), 'bg')
        let g:original_nc_bg_color = synIDattr(synIDtrans(hlID('NormalNC')), 'bg')
        if (has('termguicolors') && &termguicolors == 1) || has('gui_running')
            highlight Normal guibg=NONE
            highlight NormalNC guibg=NONE
        else
            highlight Normal ctermbg=NONE
            highlight NormalNC ctermbg=NONE
        endif
    endif
endfunction

function! ToggleFoldMethod()
    if &foldmethod ==? "manual"
        setlocal foldmethod=indent
    elseif &foldmethod ==? "indent"
        setlocal foldmethod=expr
    elseif &foldmethod ==? "expr"
        setlocal foldmethod=marker
    elseif &foldmethod ==? "marker"
        setlocal foldmethod=syntax
    elseif &foldmethod ==? "syntax"
        setlocal foldmethod=diff
    elseif &foldmethod ==? "diff"
        setlocal foldmethod=manual
    endif
    echo "Fold method set to: " . &foldmethod
endfunction

function! Rot13()
    normal mkggg?G'k
endfunction
command! Rot13 call Rot13()

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

function! ShowWhitespace()
    /\s\+$
endfunction
command! ShowWhitespace call ShowWhitespace()

function! RemoveWhitespace() range
    execute "silent!" . a:firstline . ',' . a:lastline . "s/\\s\\+$"
endfunction
command! -range=% RemoveWhitespace <line1>,<line2>call RemoveWhitespace()

function! ToggleSyntax()
    if exists('g:syntax_on')
        syntax off
        echo "Syntax: Disabled"
    else
        syntax enable
        echo "Syntax: Enabled"
        call ColorschemeInit()
    endif
endfunction
command! ToggleSyntax call ToggleSyntax()

function! ToggleColorColumn()
    if exists('b:current_mode') && b:current_mode == "wpm" && &colorcolumn != 120
        set colorcolumn=120
    elseif (!exists('b:current_mode') || b:current_mode == "default") && &colorcolumn != 100
        set colorcolumn=100
    else
        set colorcolumn=""
    endif
endfunction
command! ToggleColorColumn call ToggleColorColumn()

function! ToggleEOL()
    if &endofline == 1
        set noendofline
        echo "Disabled eol"
    else
        set endofline
        echo "Enabled eol"
    endif
endfunction
command! ToggleEOL call ToggleEOL()

let g:original_conceallevel=&conceallevel
function! ToggleConceal()
    if &conceallevel == 0
        let &conceallevel=g:original_conceallevel
    else
        let g:original_conceallevel=&conceallevel
        set conceallevel=0
    endif
endfunction
command! ToggleConceal call ToggleConceal()

function! OpenInExternalProgram()
    call system('xdg-open "' . expand('%') . '" &')
endfunction
command! OpenInExternalProgram call OpenInExternalProgram()

function! GetVisualSelection()
    try
        " Save old v register contents
        let v_save = @v
        " Yank visual selection to v register
        normal! gv"vy
        " Return register contents
        return @v
    finally
        " Restore old register contents
        let @v = v_save
    endtry
endfunction

" Adapted from: http://stackoverflow.com/a/26140622
function! CenterSelection()
    let v = GetVisualSelection()
    " \zs and \ze to start and end match respectively
    " \s* to match any whitespace
    let lregex = '^\zs\s*\ze\S'
    let rregex = '\s*$'
    let whitespace = matchstr(v, lregex)
    let whitespace .= matchstr(v, rregex)
    " Replace tabs with 4 spaces
    let whitespace = substitute(whitespace, '\t', '    ', '')
    let length = len(whitespace)
    " Split whitespace evenly between the beginning and end of line
    let v = substitute(v, lregex, whitespace[length/2:], '')
    let v = substitute(v, rregex, whitespace[:length/2-1], '')
    " Remove redundant newline
    let v = substitute(v, '\n', '', '')
    " Save virtualedit setting
    let ve_save = &virtualedit
    " Save old v register contents
    let v_save = @v
    " Change virtualedit to all to allow editing in all modes
    let &virtualedit = 'all'
    " Set contents of v register to centered text
    call setreg('v', v, visualmode())
    " Replace the selected text with the centered version
    if line('.') == line('$') " Special case when cursor is on the last line
        " When the cursor on the last line, the cursor moves up one line after
        " the current line is deleted, so we paste after the current line
        normal! gvx"vp
    else
        " Otherwise, we paste before the current line
        normal! gvx"vP
    endif
    " Restore old v register contents
    let @v = v_save
    " Restore virtualedit setting
    let &virtualedit = ve_save
endfunction

command! MarkdownToPDF execute "!(pandoc --latex-engine=xelatex " . shellescape(expand('%:p')) . " -o /tmp/" . shellescape(expand('%:t:r')) . ".pdf --variable mainfont='DejaVu Serif'" . " && xdg-open /tmp/" . shellescape(expand('%:t:r')) . ".pdf) &"
command! MarkdownToPDFSync execute "!(pandoc --latex-engine=xelatex " . shellescape(expand('%:p')) . " -o /tmp/" . shellescape(expand('%:t:r')) . ".pdf --variable mainfont='DejaVu Serif'" . " && xdg-open /tmp/" . shellescape(expand('%:t:r')) . ".pdf)"

" }}}
" Custom colorscheme {{{
" Note that these highlight commands have to be formed with concatenation and then
" be evaluated with :execute because :highlight does not accept variables as arguments
function! s:Highlight(group, term, cterm, ctermfg, ctermbg, gui, guifg, guibg, guisp, font)
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
    silent execute cmd
endfunction
function! ColorschemeInit()
    call s:Highlight('Red_196', 'bold', 'bold', '196', '235', 'bold', '#FF0000', '#262626', '', '')
    call s:Highlight('Orange_202', 'bold', 'bold', '202', '235', 'bold', '#FF5F00', '#262626', '', '')
    call s:Highlight('Green_34', 'bold', 'bold', '34', '235', 'bold', '#00AF00', '#262626', '', '')
    call s:Highlight('Green_41', 'bold', 'bold', '41', '235', 'bold', '#00D75F', '#262626', '', '')
    call s:Highlight('Blue_37', 'bold', 'bold', '37', '235', 'bold', '#00AFAF', '#262626', '', '')
    call s:Highlight('Blue_39', 'bold', 'bold', '39', '235', 'bold', '#00AFFF', '#262626', '', '')
    call s:Highlight('Blue_51', 'bold', 'bold', '51', '235', 'bold', '#00FFFF', '#262626', '', '')
endfunction

" }}}
" Statusline {{{
" Functions for generating statusline {{{
" Uses an external python script to fetch and display the git info asynchronously
" (using neovim msgpack-rpc)
function! Git()
    if exists('$NVIM_LISTEN_ADDRESS')
        call system('python ' . g:scriptsDirectory . 'git.py $NVIM_LISTEN_ADDRESS $PWD &')
    endif
endfunction
function! GitBranch()
    let output=system("git branch | grep '*' | grep -o '[^* ]*'")
    if output=="" || output=~?"fatal"
        return ""
    else
        let g:inGitRepo=1
        return "[Git][" . output[0 : strlen(output)-2] . " " " Strip newline ^@
    endif
endfunction
function! GitStatus()
    if g:inGitRepo == 0
        return ""
    endif
    let output=system('git status')
    let retStr=""
    if output=~?"Changes to be committed"
        let retStr.="\u2718"
    else
        let retStr.="\u2714"
    endif
    if output=~?"modified"
        let retStr.=" \u0394"
    endif
    let retStr.=GitStashLength() . "]"
    return retStr
endfunction
function! GitRemote(branch) " Note: this function takes a while to execute
    if g:inGitRepo == 0
        return ""
    endif
    let remotes=split(system("git remote")) " Get names of remotes
    if remotes==[] " End if no remotes found or error
        return ""
    else
        let remotename=remotes[0] " Get name of first remote
    endif
    let output=system("git remote show " . remotename . " | grep \"" . a:branch . "\"")
    if output =~? "local out of date"
        return " (!)Local repo out of date"
    else
        return ""
    endif
endfunction
function! GitStashLength()
    if g:inGitRepo == 0
        return ""
    endif
    let stashLength=system("git stash list | wc -l")
    if stashLength=="0\n" || stashLength=="" || stashLength=~?"fatal"
        return ""
    else
        return " \u26c1 " . stashLength[0 : strlen(stashLength)-2] " Strip trailing newline
    endif
endfunction
function! RefreshGitInfo()
    if g:showGitInfo == 1
        " If nvim, use asynchronous msgpack-rpc method
        if has('nvim')
            call Git()
        " Otherwise, use standard synchronous method
        else
            let gitBranch=GitBranch()
            let g:gitInfo=gitBranch . GitStatus() . GitRemote(gitBranch)
        endif
    else
        let g:gitInfo = "" " Clear old git info
    endif
endfunction
function! ToggleGitInfo()
    if g:showGitInfo == 1
        let g:showGitInfo = 0
    else
        let g:showGitInfo = 1
    endif
endfunction
command! ToggleGitInfo call ToggleGitInfo()
call RefreshGitInfo()
" }}}
" Custom statusline {{{
function! SetStatusline()
    let bufName = bufname('%')
    " Do not modify the statusline for plugin-handled windows
    if &buftype ==# "quickfix" || bufName =~# "NERD" || bufName =~# "Gundo" || bufName =~# "__Tagbar__"
        return
    endif
    let winWidth = winwidth(0)
    setlocal statusline=""
    if winWidth > 50
        setlocal statusline+=%t " Tail of the filename
    endif
    if winWidth > 40
        setlocal statusline+=%y " Filetype
    endif
    if winWidth > 80
        setlocal statusline+=[%{strlen(&fenc)?&fenc:'none'}\|  " File encoding
        setlocal statusline+=%{&ff}]                           " File format
    endif
    setlocal statusline+=%#Orange_202#%r%##      " Read only flag
    setlocal statusline+=%#Blue_51#%m\%##        " Modified flag
    setlocal statusline+=%h                      " Help file flag
    setlocal statusline+=\ %#Blue_37#[B:%n/%{bufnr('$')}%##                  " Buffer number
    setlocal statusline+=\ %#Blue_37#T:%{tabpagenr()}/%{tabpagenr('$')}]%##  " Tab number
    if winWidth > 100
        setlocal statusline+=\ %#Green_34#%{g:gitInfo}%## " Git info
    endif
    setlocal statusline+=%=                      " Left/right separator
    setlocal statusline+=%#Blue_39#             " File path begin
    if &buftype ==# "terminal"
        setlocal statusline+=%{expand('%:p')}     " Full path
    else
        setlocal statusline+=%{pathshorten(expand('%:p:~:h'))} " File path with truncated names
    endif
    setlocal statusline+=%##%#Green_41#\|%##     " File path end
    setlocal statusline+=C:%2c\                  " Cursor column, reserve 2 spaces
    setlocal statusline+=R:%3l/%3L               " Cursor line/total lines, reserve 3 spaces for each
    setlocal statusline+=%#Green_41#\|%##%3p     " Percent through file, reserve 3 spaces
    setlocal statusline+=%%                      " Percent symbol
endfunction
call SetStatusline()
" }}}
" Statusline color changing function {{{
function! RefreshColors(ctermfg, guifg, ctermbg, guibg)
    let l:isEnteringInsertMode = 0
    if a:ctermbg == g:insertModeStatusLineColor_ctermbg
        let l:isEnteringInsertMode = 1
    endif
    call s:Highlight('Red_196', 'bold', 'bold', '196', a:ctermbg, 'bold', '#FF0000', a:guibg, '', '')
    call s:Highlight('Orange_202', 'bold', 'bold', '202', a:ctermbg, 'bold', '#FF5F00', a:guibg, '', '')
    call s:Highlight('Green_34', 'bold', 'bold', '34', a:ctermbg, 'bold', '#00AF00', a:guibg, '', '')
    call s:Highlight('Green_41', 'bold', 'bold', '41', a:ctermbg, 'bold', '#00D75F', a:guibg, '', '')
    call s:Highlight('Blue_37', 'bold', 'bold', '37', a:ctermbg, 'bold', '#00AFAF', a:guibg, '', '')
    call s:Highlight('Blue_39', 'bold', 'bold', '39', a:ctermbg, 'bold', '#00AFFF', a:guibg, '', '')
    call s:Highlight('Blue_51', 'bold', 'bold', '51', a:ctermbg, 'bold', '#00FFFF', a:guibg, '', '')
    "Status line of current window
    call s:Highlight('StatusLine', 'bold', 'bold', a:ctermfg, a:ctermbg, 'bold', a:guifg, a:guibg, '', '')
    "Status line color for noncurrent window
    call s:Highlight('StatusLineNC', 'bold', 'bold', '255', a:ctermbg, 'bold', '#EEEEEE', a:guibg, '', '')
    "Line numbers
    call s:Highlight('LineNr', '', '', a:ctermfg, a:ctermbg, '', a:guifg, a:guibg, '', '')
    call s:Highlight('SignColumn', '', '', '', a:ctermbg, '', '', a:guibg, '', '')
    call s:Highlight('ALEErrorSign', '', '', '', a:ctermbg, '', '', a:guibg, '', '')
    call s:Highlight('ALEInfoSign', '', '', '', a:ctermbg, '', '', a:guibg, '', '')
    call s:Highlight('ALEWarningSign', '', '', '', a:ctermbg, '', '', a:guibg, '', '')
    "Vertical split divider
    call s:Highlight('VertSplit', 'bold', 'bold', '43', a:ctermbg, 'bold', '#00D7AF', a:guibg, '', '')
    "Nonselected tabs
    call s:Highlight('TabLine', '', '', a:ctermfg, a:ctermbg, '', a:guifg, a:guibg, '', '')
    "Empty space on tab bar
    call s:Highlight('TabLineFill', '', '', '', a:ctermbg, '', '', a:guibg, '', '')
    "Selected tab
    if l:isEnteringInsertMode == 1
        call s:Highlight('TabLineSel', '', '', '45', a:ctermbg, '', '#00D7FF', a:guibg, '', '')
    else
        call s:Highlight('TabLineSel', '', '', '255', '23', '', '#EEEEEE', '#005F5F', '', '')
    endif
    "Current line highlighting
    if l:isEnteringInsertMode == 1
        call s:Highlight('CursorLineNr', 'bold', 'bold', '45', '26', 'bold', '#00D7FF', '#173762', '', '')
    else
        call s:Highlight('CursorLineNr', 'bold', 'bold', '255', '23', 'bold', '#EEEEEE', '#005F5F', '', '')
    endif
endfunction

function! ReverseColors()
    if &background == "light"
        set background=dark
    else
        set background=light
    endif
    call ToggleStatuslineColor()
endfunction
command! ReverseColors call ReverseColors()
" }}}
" }}}
" Plugins configuration/constants {{{
try
    " Add locally installed bundles to runtimepath
    " Plugin Scripts {{{

    call plug#begin(expand('$HOME/.vim/plugged'))

    Plug 'Yggdroot/indentLine'
    Plug 'Raimondi/delimitMate'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'xolox/vim-misc'
    Plug 'xolox/vim-notes'
    Plug 'plasticboy/vim-markdown', {
        \'for': 'markdown'
    \}
    Plug 'JamshedVesuna/vim-markdown-preview', {
        \'for': 'markdown'
    \}
    Plug 'scrooloose/nerdtree', {
        \'on': ['NERDTreeToggle']
    \}
    Plug 'Shougo/denite.nvim'
    Plug 'junegunn/fzf'
    Plug 'sjl/gundo.vim', {
        \'on': 'GundoToggle'
    \}
    Plug 'majutsushi/tagbar', {
        \'on': 'TagbarToggle'
    \}

    "Plug 'Valloric/YouCompleteMe', {
    "    \'do': './install.py --clang-completer'
    "\}
    "Plug 'rdnetto/YCM-Generator', {
    "    \'branch': 'stable',
    "    \'for': 'YcmGenerateConfig'
    "\}
    if has('nvim')
        Plug 'Shougo/deoplete.nvim', {
            \'do': ':UpdateRemotePlugins'
        \}
    else
        Plug 'Shougo/deoplete.nvim'
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
    endif

    Plug 'autozimu/LanguageClient-neovim', {
        \'branch': 'next',
        \'do': 'bash install.sh',
    \}
    Plug 'w0rp/ale'

    Plug 'zchee/deoplete-jedi', {
        \'for': 'python'
    \}
    Plug 'eagletmt/neco-ghc', {
        \'for': 'haskell'
    \}
    Plug 'artur-shaik/vim-javacomplete2', {
        \'for': 'java'
    \}
    Plug 'rust-lang/rust.vim', {
        \'for': 'rust'
    \}

    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'

    Plug 'sheerun/vim-polyglot'
    Plug 'luochen1990/rainbow'
    Plug 'chrisbra/Colorizer', {
        \'on': 'ColorToggle'
    \}
    Plug 'iCyMind/NeoSolarized'
    Plug 'joshdick/onedark.vim'

    Plug 'chrisbra/unicode.vim', {
        \'on': ['Digraphs',
               \'UnicodeTable',
               \'UnicodeName',
               \'SearchUnicode',
               \'DownloadUnicode']
    \}
    Plug 'KabbAmine/zeavim.vim'
    Plug 'lambdalisue/suda.vim'
    Plug 'ChesleyTan/wordCount.vim', {
        \'on': 'WordCount'
    \}
    Plug 'liuchengxu/vim-which-key', {
        \'on': ['WhichKey', 'WhichKey!', 'WhichKeyVisual', 'WhichKeyVisual!']
    \}

    " Initialize plugin system
    call plug#end()

    " indentLine settings {{{
    let g:indentLine_char = '┆'
    let g:indentLine_setColors = 0
    " }}}
    " vim-notes settings {{{
    let g:notes_directories = ['~/T/vim/Shared Notes']
    let g:notes_word_boundaries = 1
    nnoremap <Leader>n :Note 
    " }}}
    " Markdown settings {{{
    let g:vim_markdown_math = 1
    let g:vim_markdown_preview_toggle = 1
    let g:vim_markdown_preview_browser = 'firefox'
    let g:vim_markdown_preview_pandoc = 1
    command! MarkdownPreview call Vim_Markdown_Preview()
    nnoremap <Leader>mp :call Vim_Markdown_Preview()<CR>
    " }}}
    " ALE settings {{{
    " Quick leader toggle for ALE checking
    nnoremap <Leader>ta :ALEToggle<CR>
    nnoremap <Leader>an :ALENextWrap<CR>
    nnoremap <Leader>ap :ALEPreviousWrap<CR>
    let g:ale_sign_error = '✖ '
    let g:ale_sign_warning = '⚠ '
    " }}}
    " NERDTree settings {{{
    command! Tree NERDTreeToggle
    nnoremap <LocalLeader>t :Tree<CR>
    " }}}
    " Denite settings {{{
    nnoremap <Leader>u :Denite 
    nnoremap <Leader>ur :Denite file buffer file_rec<CR>
    nnoremap <Leader>uo :Denite output:
    nnoremap <Leader>ug :Denite grep<CR>
    nnoremap <Leader>ul :Denite line<CR>
    nnoremap <Leader>umru :Denite output:ol<CR>
    " }}}
    " Gundo settings {{{
    let g:gundo_width = 30
    let g:gundo_preview_height = 20
    let g:gundo_right = 1
    let g:gundo_preview_bottom = 1
    command! DiffTree GundoToggle
    " }}}
    " Tagbar settings {{{
    nnoremap <F8> :TagbarToggle<CR>
    " }}}
    " Deoplete settings {{{
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#max_list = 50
    " Quick leader toggle for autocompletion
    nnoremap <Leader>td :call deoplete#toggle()<CR>
    " }}}
    " LanguageClient settings {{{
    let g:LanguageClient_serverCommands = {
        \'python': ['pyls'],
        \'javascript': ['javascript-typescript-stdio'],
        \'javascript.jsx': ['javascript-typescript-stdio'],
        \'c': ['clangd-6.0'],
        \'cpp': ['clangd-6.0'],
        \'ocaml': ['ocaml-language-server', '--stdio'],
        \'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \}
    nnoremap <silent> <Leader>lk :call LanguageClient#textDocument_hover()<CR>
    nnoremap <silent> <Leader>ld :call LanguageClient#textDocument_definition()<CR>
    nnoremap <silent> <Leader>lr :call LanguageClient#textDocument_references()<CR>
    nnoremap <silent> <Leader>la :call LanguageClient#textDocument_codeAction()<CR>
    nnoremap <silent> <Leader>lR :call LanguageClient#textDocument_rename()<CR>
    nnoremap <silent> <Leader>lf :call LanguageClient#textDocument_formatting()<CR>
    nnoremap <silent> <Leader>lm :call LanguageClient_contextMenu()<CR>
    nnoremap <silent> <Leader>lh :call LanguageClient#textDocument_documentHighlight()<CR>
    nnoremap <silent> <Leader>lH :call LanguageClient_clearDocumentHighlight()<CR>
    vnoremap <silent> <Leader>lf :call LanguageClient#textDocument_rangeFormatting()<CR>
    nnoremap <silent> <Leader>lt :LanguageClientStop<CR>:LanguageClientStart<CR>
    " }}}
    " FZF settings {{{
    nnoremap <Leader>f :FZF 
    " }}}
    " Ultisnips settings {{{
    let g:UltiSnipsExpandTrigger = "<LocalLeader><Tab>"
    let g:UltiSnipsListSnippets = "<LocalLeader><LocalLeader>"
    let g:UltiSnipsJumpForwardTrigger = "<Tab>"
    let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
    let g:UltiSnipsEditSplit = "vertical"
    " }}}
    " vim-polyglot settings {{{
    " python-syntax configuration
    let g:python_highlight_all = 1
    let g:polyglot_disabled = ['rust']
    " }}}
" vim-which-key settings {{{
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  '\\'<CR>
vnoremap <silent> <leader>      :<c-u>WhichKeyVisual '<Space>'<CR>
vnoremap <silent> <localleader> :<c-u>WhichKeyVisual '\\'<CR>
" Hide vim-which-key statusline
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
" }}}
    " zeavim settings {{{
    nmap <Leader>z <Plug>Zeavim
    vmap <Leader>z <Plug>ZVVisSelection
    nmap <Leader><Leader>z <Plug>ZVKeyDocset
    " }}}
    " Rainbow settings {{{
    let g:rainbow_active = 1
    let g:rainbow_conf = {
        \'guifgs': ['#DFFFFF', '#0087FF', '#DFAF00', '#5F87FF'],
        \'ctermfgs': ['195', '33', '178', '69']
    \}
    " }}}
    " Neosolarized settings {{{
    let g:neosolarized_contrast = "high"
    let g:neosolarized_bold = 1
    let g:neosolarized_underline = 1
    let g:neosolarized_italic = 1
    " }}}
    " Onedark settings {{{
    let g:onedark_terminal_italics = 1
    " }}}
    " }}}
catch /:E117:/
    echom "Error initializing plugins -- plugin manager not installed?"
    echom v:exception
endtry

" }}}
" tabline from StackOverflow (with auto-resizing modifications) {{{
set tabline+=%!MyTabLine()
function! MyTabLine()
    let tabline = ''
    " Iterate through each tab page
    let numTabs = tabpagenr('$')
    let currentTab = tabpagenr()
    let winWidth = &columns
    let maxTabsDisplayed = winWidth / 20
    let LRPadding = maxTabsDisplayed / 2
    let evenOddOffset = (maxTabsDisplayed % 2 == 0) ? 0 : 1
    for tabIndex in range(numTabs)
        let tabIndex += 1
        let upperBound = (currentTab < LRPadding) ? LRPadding + (LRPadding - currentTab) : LRPadding
        let upperBound += evenOddOffset
        if numTabs > maxTabsDisplayed && maxTabsDisplayed > 1
            " Lower (left) bound for tab listing
            if tabIndex < currentTab - LRPadding + 1
                continue
            " Upper (right) bound for tab listing
            elseif tabIndex > currentTab + upperBound
                continue
            endif
        " If maxTabsDisplayed is 0, then only show the current tab
        elseif maxTabsDisplayed <= 1 && tabIndex != currentTab
            continue
        endif
        " Set highlight for tab
        if tabIndex == currentTab
            let tabline .= '%#TabLineSel#'
        else
            let tabline .= '%#TabLine#'
        endif
        " Set the tab page number (for mouse clicks)
        let tabline .= '%' . (tabIndex) . 'T'
        let tabline .= ' '
        " Set page number string
        let tabline .= tabIndex . ' '
        " Get buffer names and statuses
        let tmp = '' " Temp string for buffer names while we loop and check buftype
        let numModified = 0 " &modified counter
        let bufsRemaining = len(tabpagebuflist(tabIndex)) " Counter to avoid last ' '
        " Iterate through each buffer in the tab
        for bufIndex in tabpagebuflist(tabIndex)
            let currentBufName = bufname(bufIndex)
            " Use a variable to keep track of whether a new name was added
            let newBufNameAdded = 1
            " Special buffer types: [Q] for quickfix, [H]{base fname} for help
            if getbufvar(bufIndex, "&buftype") == 'help'
                let tmp .= '[H]' . fnamemodify(currentBufName, ':t:s/.txt$//')
            elseif getbufvar(bufIndex, "&buftype") == 'quickfix'
                let tmp .= '[Q]'
            elseif getbufvar(bufIndex, "&buftype") == 'terminal'
                let tmp .= '[T]' . fnamemodify(currentBufName, ':t')
            else
                " Do not show plugin-handled windows in the bufferlist
                if (currentBufName =~# "NERD"
                \|| currentBufName =~# "Gundo"
                \|| currentBufName =~# "__Tagbar__")
                    let newBufNameAdded = 0
                else
                    let tmp .= pathshorten(fnamemodify(currentBufName, ':~:.'))
                endif
            endif
            " Check and increment tab's &modified count
            if getbufvar(bufIndex, "&modified")
                let numModified += 1
            endif
            " Add trailing ' ' if necessary
            if bufsRemaining > 1 && newBufNameAdded == 1
                let tmp .= ' '
            endif
            let bufsRemaining -= 1
        endfor
        " Add modified label [n+] where n pages in tab are modified
        if numModified > 0
            let tabline .= '[' . numModified . '+]'
        endif
        " Select the highlighting for the buffer names
        if tabIndex == currentTab
            let tabline .= '%#TabLineSel#'
        else
            let tabline .= '%#TabLine#'
        endif
        " Add buffer names
        if tmp == ''
            let tabline .= '[New]'
        else
            let tabline .= tmp
        endif
        " Add trailing ' ' for tab
        let tabline .= ' '
    endfor
    " Remove excess whitespace
    let tabline = DeflateWhitespace(tabline)
    " After the last tab fill with TabLineFill, and reset tab page number to
    " support mouse clicks
    let tabline .= '%#TabLineFill#%T'
    " Add close button
    if numTabs > 1
        " Right-align the label to close the current tab page
        let tabline .= '%=%#TabLineFill#%999X%#Red_196#Close%##'
    endif
    return tabline
endfunction
" }}}
" Filetype-specific settings/abbreviations {{{
" Java {{{
augroup ft_java
    autocmd Filetype java call s:FileType_Java()
augroup END
function! s:FileType_Java()
    " Use Ctrl-] to expand abbreviation
    inoreabbrev psvm public static void main(String[] args) {}<esc>i<CR><esc>ko
    inoreabbrev sysout System.out.println("");<esc>2hi
    inoreabbrev syserr System.err.println("");<esc>2hi
endfunction
" }}}
" C {{{
augroup ft_c
    autocmd Filetype c call s:FileType_C()
augroup END
function! s:FileType_C()
    inoreabbrev #<defaults> #include <stdio.h><CR>#include <stdlib.h>
endfunction
" }}}
" Notes {{{
augroup ft_notes
    autocmd Filetype notes setlocal foldtext=CustomNotesFoldText()
augroup END
function! CustomNotesFoldText()
    " Show number of lines in fold
    return xolox#notes#foldtext() . '(' . (v:foldend - v:foldstart) . ')'
endfunction
" }}}
" Haskell {{{
augroup ft_haskell
    " Disable haskell-vim omnifunc
    let g:haskellmode_completion_ghc = 0
    autocmd Filetype haskell setlocal omnifunc=necoghc#omnifunc
    let g:necoghc_enable_detailed_browse = 1
augroup END
" }}}
" Ocaml {{{
augroup ft_ocaml
    autocmd Filetype ocaml set tabstop=2
    autocmd Filetype ocaml set softtabstop=2
    autocmd Filetype ocaml set shiftwidth=2
augroup END
" }}}
" }}}
" Pre-start function calls (non-autocommand) {{{
if has("gui_running")
    call Solarized()
elseif empty($DISPLAY) " Check if running in a tty
    call OneDark()
" Automatically apply Solarized colorscheme if true-color is available
elseif exists('&termguicolors') && &termguicolors == 1
    call Solarized()
else
    call Solarized()
endif
call s:SetMappings()
" }}}
" Neovim {{{
if has('nvim')
    tnoremap <Esc> <C-\><C-n>   " Escape to exit terminal insert mode
    tnoremap jj <C-\><C-n>      " jj to exit terminal insert mode
    tnoremap jk <C-\><C-n>      " jk to exit terminal insert mode
    " Use :terminal to execute shell command
    nnoremap <Leader>c :terminal 
    nnoremap <Leader>cc :below split \| terminal<CR>
    autocmd TermOpen * call SetStatusline()
endif
" }}}
