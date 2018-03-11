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
set timeoutlen=300 " Timeout for entering key combinations
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
if has('nvim')
    set termguicolors " Enable gui colors in terminal (i.e., 24-bit color)
endif

" Autocompletion settings
set completeopt=longest,menuone,preview

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
set spellfile=$HOME/Dropbox/vim/spell/en.utf-8.add

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
    autocmd InsertEnter * call RefreshColors(g:insertModeStatuslineColor_cterm, g:insertModeStatuslineColor_gui)
    autocmd InsertLeave * call ToggleStatuslineColor()
    " Detect true-color terminal
    autocmd VimEnter * call DetectTrueColor()
augroup END

" List/listchars
set list
execute "set listchars=tab:\u2592\u2592,trail:\u2591"
" }}}
" Constants/Global variables {{{
let g:defaultStatuslineColor_cterm = 235
let g:defaultStatuslineColor_gui = '#262626'
let g:insertModeStatuslineColor_cterm = 23
let g:insertModeStatuslineColor_gui = '#005F5F'
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
    cmap w!! w !sudo tee > /dev/null %
    " Easy toggle for paste
    nnoremap <Leader>tp :set paste!<CR>:echo "Paste mode: " . &paste<CR>
    " Easy page up/down
    nnoremap <C-Up> <C-u>
    nnoremap <C-Down> <C-d>
    nnoremap <C-k> 3k
    nnoremap <C-j> 3j
    vnoremap <C-k> 3k
    vnoremap <C-j> 3j

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
    nnoremap > <C-w>>:call SetStatusline()<CR>
    nnoremap < <C-w><:call SetStatusline()<CR>
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
    inoremap <C-p> <Left><C-o>"+p
    " Delete to first character on line
    inoremap <C-u> <C-o>d^
    " Mapping for autoformat
    nnoremap <C-f> mkgggqG'k
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
    " Navigation mappings
    " Jump to beginning of tag
    nnoremap {{ vat<Esc>'<
    " Jump to end of tag
    nnoremap }} vat<Esc>'>
    nnoremap <Tab> gt
    nnoremap <S-Tab> gT
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
    " Easy delete to black hole register
    nnoremap D "_dd
    " Goto commands
    command! GotoWindow normal <C-w>f
    command! GotoTab normal <C-w>gf
    " Center selected text with surrounding whitespace
    vnoremap . :call CenterSelection()<CR>
    " Quick toggle terminal background transparency
    nnoremap <Leader>tt :call ToggleTransparentTerminalBackground()<CR>
    " Quick toggle fold method
    nnoremap <Leader>tf :call ToggleFoldMethod()<CR>
    " Quick toggle syntax highlighting
    nnoremap <Leader>ts :call SyntaxToggle()<CR>
    " Quick toggle line numbers
    nnoremap <Leader>tn :set number!<CR>
    " Quick toggle for color column at 80 characters
    nnoremap <Leader>t8 :call ColorColumnToggle()<CR>
    " Quick toggle for automatic newline insertion at end of line
    nnoremap <Leader>tl :call EOLToggle()<CR>
endfunction
" }}}
" Custom functions {{{

" This function is called by autocmd when vim starts
function! PluginConfig()
    " Javacomplete config {{{
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
function! Molokai()
    if !has("gui_running")
        let g:rehash256 = 1
    endif
    colorscheme molokai
    call ToggleStatuslineColor()
endfunction
command! Molokai call Molokai()
function! Solarized()
    set background=dark
    colorscheme NeoSolarized
    highlight Folded term=NONE cterm=NONE gui=NONE
    call ToggleStatuslineColor()
endfunction
command! Solarized call Solarized()
function! ToggleStatuslineColor()
    call RefreshColors(g:defaultStatuslineColor_cterm, g:defaultStatuslineColor_gui)
endfunction
command! ToggleStatuslineColor call ToggleStatuslineColor()
function! Custom()
    call ColorschemeInit()
    call ToggleStatuslineColor()
endfunction
command! Custom call Custom()
" Store default bg color
let g:original_bg_color = synIDattr(synIDtrans(hlID('Normal')), 'bg')
function! ToggleTransparentTerminalBackground()
    if (synIDattr(synIDtrans(hlID('Normal')), 'bg')) == ""
        if g:original_bg_color == ""
            execute "highlight Normal ctermbg=NONE"
        else
            execute "highlight Normal ctermbg=" . g:original_bg_color
        endif
    else
        let g:original_bg_color = synIDattr(synIDtrans(hlID('Normal')), 'bg')
        highlight Normal ctermbg=NONE
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
function! SyntaxToggle()
    if exists('g:syntax_on')
        syntax off
        echo "Syntax: Disabled"
    else
        syntax enable
        echo "Syntax: Enabled"
        call ColorschemeInit()
    endif
endfunction
command! SyntaxToggle call SyntaxToggle()
function! ColorColumnToggle()
    if exists('b:current_mode') && b:current_mode == "wpm" && &colorcolumn != 120
        set colorcolumn=120
    elseif (!exists('b:current_mode') || b:current_mode == "default") && &colorcolumn != 100
        set colorcolumn=100
    else
        set colorcolumn=""
    endif
endfunction
command! ColorColumnToggle call ColorColumnToggle()
function! EOLToggle()
    if &endofline == 1
        set noendofline
        echo "Disabled eol"
    else
        set endofline
        echo "Enabled eol"
    endif
endfunction
command! EOLToggle call EOLToggle()
function! OpenInExternalProgram()
    call system('xdg-open "' . expand('%') . '" &')
endfunction
let g:original_conceallevel=&conceallevel
function! ConcealToggle()
    if &conceallevel == 0
        let &conceallevel=g:original_conceallevel
    else
        let g:original_conceallevel=&conceallevel
        set conceallevel=0
    endif
endfunction
command! ConcealToggle call ConcealToggle()
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
function DetectTrueColor()
    " Automatically apply Solarized colorscheme if true-color is available
    if &termguicolors == 1
        call Solarized()
    endif
endfunction

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
    " Colors inspired by flatcolor colorscheme created by Max St
    call s:Highlight('Normal', '', '', '15', '234', '', '#ECF0F1', '#1C1C1C', '', '')
    call s:Highlight('Statement', 'bold', 'bold', '197', '', 'bold', '#FF0033', '', '', '')
    call s:Highlight('Conditional', 'bold', 'bold', '197', '', 'bold', '#FF0033', '', '', '')
    call s:Highlight('Operator', '', '', '197', '', '', '#FF0033', '', '', '')
    call s:Highlight('Label', '', '', '197', '', '', '#FF0033', '', '', '')
    call s:Highlight('Repeat', 'bold', 'bold', '197', '', 'bold', '#FF0033', '', '', '')
    call s:Highlight('Type', '', '', '196', '', '', '#FF0000', '', '', '')
    call s:Highlight('StorageClass', '', '', '197', '', '', '#FF0033', '', '', '')
    call s:Highlight('Structure', '', '', '197', '', '', '#FF0033', '', '', '')
    call s:Highlight('TypeDef', 'bold', 'bold', '197', '', 'bold', '#FF0033', '', '', '')
    call s:Highlight('Exception', 'bold', 'bold', '37', '', 'bold', '#1ABC9C', '', '', '')
    call s:Highlight('Include', 'bold', 'bold', '37', '', 'bold', '#1ABC9C', '', '', '')
    call s:Highlight('PreProc', '', '', '37', '', '', '#1ABC9C', '', '', '')
    call s:Highlight('Macro', '', '', '37', '', '', '#1ABC9C', '', '', '')
    call s:Highlight('Define', '', '', '37', '', '', '#1ABC9C', '', '', '')
    call s:Highlight('Delimiter', '', '', '37', '', '', '#1ABC9C', '', '', '')
    call s:Highlight('Ignore', '', '', '37', '', '', '#1ABC9C', '', '', '')
    call s:Highlight('PreCondit', 'bold', 'bold', '37', '', 'bold', '#1ABC9C', '', '', '')
    call s:Highlight('Debug', 'bold', 'bold', '37', '', 'bold', '#1ABC9C', '', '', '')
    call s:Highlight('Function', '', '', '202', '', '', '#FF5F00', '', '', '')
    call s:Highlight('Identifier', '', '', '202', '', '', '#FF5F00', '', '', '')
    call s:Highlight('Comment', '', '', '41', '', '', '#2ECC71', '', '', '')
    call s:Highlight('CommentEmail', 'underline', 'underline', '41', '', 'underline', '#2ECC71', '', '', '')
    call s:Highlight('CommentUrl', 'underline', 'underline', '41', '', 'underline', '#2ECC71', '', '', '')
    call s:Highlight('SpecialComment', 'bold', 'bold', '41', '', 'bold', '#2ECC71', '', '', '')
    call s:Highlight('Todo', 'bold', 'bold', '41', '', 'bold', '#2ECC71', '', '', '')
    call s:Highlight('String', '', '', '220', '', '', '#FFD700', '', '', '')
    call s:Highlight('SpecialKey', 'bold', 'bold', '236', '', 'bold', '#303030', '', '', '')
    call s:Highlight('Special', 'bold', 'bold', '68', '', 'bold', '#3498DB', '', '', '')
    call s:Highlight('SpecialChar', 'bold', 'bold', '68', '', 'bold', '#3498DB', '', '', '')
    call s:Highlight('Boolean', 'bold', 'bold', '68', '', 'bold', '#3498DB', '', '', '')
    call s:Highlight('Character', 'bold', 'bold', '68', '', 'bold', '#3498DB', '', '', '')
    call s:Highlight('Number', 'bold', 'bold', '68', '', 'bold', '#3498DB', '', '', '')
    call s:Highlight('Constant', 'bold', 'bold', '68', '', 'bold', '#3498DB', '', '', '')
    call s:Highlight('Float', 'bold', 'bold', '68', '', 'bold', '#3498DB', '', '', '')
    call s:Highlight('MatchParen', 'bold', 'bold', '202', '0', 'bold', '#FF5F00', '#000000', '', '')
    call s:Highlight('NonText', '', '', '', '', '', '', '', '', '')
    call s:Highlight('Cursor', '', '', '235', '15', '', '#262626', '#FFFFFF', '', '')
    call s:Highlight('vCursor', '', '', '235', '15', '', '#262626', '#FFFFFF', '', '')
    call s:Highlight('iCursor', '', '', '235', '15', '', '#262626', '#FFFFFF', '', '')
    call s:Highlight('CursorColumn', '', '', '', '235', '', '', '#262626', '', '')
    call s:Highlight('CursorLine', '', '', '', '235', '', '', '#262626', '', '')
    call s:Highlight('SignColumn', '', '', '', '235', '', '', '#262626', '', '')
    call s:Highlight('ColorColumn', '', '', '', '235', '', '', '#262626', '', '')
    call s:Highlight('Error', 'bold', 'bold', '196', '', 'bold', '#FF0000', '', '', '')
    call s:Highlight('ErrorMsg', 'bold', 'bold', '196', '', 'bold', '#FF0000', '', '', '')
    call s:Highlight('WarningMsg', 'bold', 'bold', '220', '', 'bold', '#FFD700', '', '', '')
    call s:Highlight('Title', 'bold', 'bold', '166', '', 'bold', '#EF5939', '', '', '')
    call s:Highlight('Tag', 'bold', 'bold', '', '', 'bold', '', '', '', '')
    call s:Highlight('Visual', '', '', '', '237', '', '', '#3A3A3A', '', '')
    call s:Highlight('VisualNOS', '', '', '', '237', '', '', '#3A3A3A', '', '')
    call s:Highlight('Search', '', '', '235', '70', '', '#262626', '#5FAF00', '', '')
    call s:Highlight('IncSearch', '', '', '234', '37', '', '#1C1C1C', '#1ABC9C', '', '')
    call s:Highlight('QuickFixLine', '', '', '', '232', '', '', '#080808', '', '')
    call s:Highlight('StatusLine', 'bold', 'bold', '118', '235', 'bold', '#87FF00', '#262626', '', '')
    call s:Highlight('StatusLineNC', 'bold', 'bold', '255', '235', 'bold', '#EEEEEE', '#262626', '', '')
    call s:Highlight('LineNr', '', '', '118', '235', '', '#87FF00', '#262626', '', '')
    call s:Highlight('VertSplit', 'bold', 'bold', '43', '235', 'bold', '#00D7AF', '#262626', '', '')
    call s:Highlight('TabLine', '', '', '118', '235', '', '#87FF00', '#262626', '', '')
    call s:Highlight('TabLineFill', '', '', '', '235', '', '', '#262626', '', '')
    call s:Highlight('TabLineSel', '', '', '255', '23', '', '#EEEEEE', '#005F5F', '', '')
    call s:Highlight('CursorLineNr', 'bold', 'bold', '255', '23', 'bold', '#EEEEEE', '#005F5F', '', '')
    call s:Highlight('FoldColumn', '', '', '39', '235', '', '#00afff', '#262626', '', '')
    call s:Highlight('Folded', '', '', '39', '235', '', '#00afff', '#262626', '', '')
    call s:Highlight('SpellBad', '', 'underline,bold', '160', '', 'undercurl', '', '', '#D70000', '')
    call s:Highlight('SpellCap', '', 'underline,bold', '214', '', 'undercurl', '', '', '#FFAF00', '')
    call s:Highlight('SpellLocal', '', 'underline,bold', '51', '', 'undercurl', '', '', '#5FFFFF', '')
    call s:Highlight('SpellRare', '', 'underline,bold', '195', '', 'undercurl', '', '', '#DFFFFF', '')
    call s:Highlight('Conceal', '', '', '235', '', '', '#262626', '', '', '')
    call s:Highlight('ModeMsg', 'bold', 'bold', '220', '', 'bold', '#FFD700', '', '', '')
    call s:Highlight('Pmenu', '', '', '76', '233', '', '#5FD700', '#121212', '', '')
    call s:Highlight('PmenuSel', 'bold', 'bold', '252', '235', 'bold', '#D0D0D0', '#262626', '', '')
    call s:Highlight('PmenuSbar', 'bold', 'bold', '', '233', 'bold', '', '#121212', '', '')
    call s:Highlight('PmenuThumb', 'bold', 'bold', '', '235', 'bold', '', '#262626', '', '')
    call s:Highlight('DiffDelete', '', '', '255', '196', '', '#EEEEEE', '#FF0000', '', '')
    call s:Highlight('DiffText', '', '', '240', '', '', '#545454', '', '', '')
    call s:Highlight('DiffChange', '', '', '236', '', '', '#343434', '', '', '')
    call s:Highlight('DiffAdd', '', '', '22', '', '', '#004225', '', '', '')
    call s:Highlight('Underlined', 'underline', 'underline', '', '', 'underline', '', '', '', '')
    call s:Highlight('Directory', '', '', '37', '', '', '#1ABC9C', '', '', '')
    call s:Highlight('Question', '', '', '37', '', '', '#1ABC9C', '', '', '')
    call s:Highlight('MoreMsg', '', '', '37', '', '', '#1ABC9C', '', '', '')
    call s:Highlight('WildMenu', 'bold', 'bold', '255', '23', 'bold', '#EEEEEE', '#005F5F', '', '')
    call s:Highlight('Red_196', 'bold', 'bold', '196', '235', 'bold', '#FF0000', '#262626', '', '')
    call s:Highlight('Orange_202', 'bold', 'bold', '202', '235', 'bold', '#FF5F00', '#262626', '', '')
    call s:Highlight('Green_34', 'bold', 'bold', '34', '235', 'bold', '#00AF00', '#262626', '', '')
    call s:Highlight('Green_41', 'bold', 'bold', '41', '235', 'bold', '#2ECC71', '#262626', '', '')
    call s:Highlight('Blue_37', 'bold', 'bold', '37', '235', 'bold', '#1ABC9C', '#262626', '', '')
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
    if bufName =~# "NERD" || bufName =~# "Gundo" || bufName =~# "__Tagbar__"
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
    setlocal statusline+=%=                                        " Left/right separator
    "setlocal statusline+=%3*%F%*\ %4*\|%*\                        " File path with full names
    setlocal statusline+=%#Blue_39#%{pathshorten(fnamemodify(expand('%:p'),':~:h'))}%##%#Green_41#\|%##  " File path with truncated names
    setlocal statusline+=C:%2c\                  " Cursor column, reserve 2 spaces
    setlocal statusline+=R:%3l/%3L               " Cursor line/total lines, reserve 3 spaces for each
    setlocal statusline+=%#Green_41#\|%##%3p     " Percent through file, reserve 3 spaces
    setlocal statusline+=%%                      " Percent symbol
endfunction
call SetStatusline()
" }}}
" Statusline color changing function {{{
function! RefreshColors(statusLineColor, guiStatusLineColor)
    let l:isEnteringInsertMode = 0
    if a:statusLineColor == g:insertModeStatuslineColor_cterm
        let l:isEnteringInsertMode = 1
    endif
    call s:Highlight('Red_196', 'bold', 'bold', '196', a:statusLineColor, 'bold', '#FF0000', a:guiStatusLineColor, '', '')
    call s:Highlight('Orange_202', 'bold', 'bold', '202', a:statusLineColor, 'bold', '#FF5F00', a:guiStatusLineColor, '', '')
    call s:Highlight('Green_34', 'bold', 'bold', '34', a:statusLineColor, 'bold', '#00AF00', a:guiStatusLineColor, '', '')
    call s:Highlight('Green_41', 'bold', 'bold', '41', a:statusLineColor, 'bold', '#2ECC71', a:guiStatusLineColor, '', '')
    call s:Highlight('Blue_37', 'bold', 'bold', '37', a:statusLineColor, 'bold', '#1ABC9C', a:guiStatusLineColor, '', '')
    call s:Highlight('Blue_39', 'bold', 'bold', '39', a:statusLineColor, 'bold', '#00AFFF', a:guiStatusLineColor, '', '')
    call s:Highlight('Blue_51', 'bold', 'bold', '51', a:statusLineColor, 'bold', '#00FFFF', a:guiStatusLineColor, '', '')
    "Status line of current window
    call s:Highlight('StatusLine', 'bold', 'bold', '118', a:statusLineColor, 'bold', '#87FF00', a:guiStatusLineColor, '', '')
    "Status line color for noncurrent window
    call s:Highlight('StatusLineNC', 'bold', 'bold', '255', a:statusLineColor, 'bold', '#EEEEEE', a:guiStatusLineColor, '', '')
    "Line numbers
    call s:Highlight('LineNr', '', '', '118', a:statusLineColor, '', '#87FF00', a:guiStatusLineColor, '', '')
    "Vertical split divider
    call s:Highlight('VertSplit', 'bold', 'bold', '43', a:statusLineColor, 'bold', '#00D7AF', a:guiStatusLineColor, '', '')
    "Nonselected tabs
    call s:Highlight('TabLine', '', '', '118', a:statusLineColor, '', '#87FF00', a:guiStatusLineColor, '', '')
    "Empty space on tab bar
    call s:Highlight('TabLineFill', '', '', '', a:statusLineColor, '', '', a:guiStatusLineColor, '', '')
    "Selected tab
    if l:isEnteringInsertMode == 1
        call s:Highlight('TabLineSel', '', '', '45', a:statusLineColor, '', '#00D7FF', a:guiStatusLineColor, '', '')
    else
        call s:Highlight('TabLineSel', '', '', '255', '23', '', '#EEEEEE', '#005F5F', '', '')
    endif
    "Current line highlighting
    if l:isEnteringInsertMode == 1
        call s:Highlight('CursorLineNr', 'bold', 'bold', '45', '26', 'bold', '#00D7FF', '#173762', '', '')
    else
        call s:Highlight('CursorLineNr', 'bold', 'bold', '255', '23', 'bold', '#EEEEEE', '#005F5F', '', '')
    endif

    "PLUGINS HIGHLIGHTING
    "indentLine plugin
    execute 'let g:indentLine_color_term = ' . a:statusLineColor
endfunction

function! ReverseColors()
    if &background == "light"
        set background=dark
    else
        set background=light
    endif
    call ToggleStatuslineColor()
endfunction
" }}}
" }}}
" Plugins configuration/constants {{{
try
    " Add locally installed bundles to runtimepath
    " Plugin Scripts {{{

    call plug#begin(expand('$HOME/.vim/plugged'))

    Plug 'ChesleyTan/wordCount.vim', {
        \'on': 'WordCount'
    \}
    Plug 'Yggdroot/indentLine'
    Plug 'xolox/vim-easytags'
    Plug 'xolox/vim-misc'
    Plug 'xolox/vim-notes'
    Plug 'itchyny/calendar.vim', {
        \'on': 'Calendar'
    \}
    Plug 'Raimondi/delimitMate'
    Plug 'benekastah/neomake'
    Plug 'scrooloose/nerdtree', {
        \'on': ['NERDTreeToggle', 'NERDTreeTabsToggle']
    \}
    Plug 'jistr/vim-nerdtree-tabs', {
        \'on': 'NERDTreeTabsToggle'
    \}
    Plug 'Shougo/unite.vim', {
        \'on': 'Unite'
    \}
    Plug 'davidhalter/jedi-vim', {
        \'for': 'python'
    \}
    Plug 'zchee/deoplete-jedi', {
        \'for': 'python'
    \}
    Plug 'vim-python/python-syntax', {
        \'for': 'python',
        \'do': 'mkdir -p $HOME/.vim/syntax; cp syntax/python.vim $HOME/.vim/syntax'
    \}
    Plug 'eagletmt/neco-ghc', {
        \'for': 'haskell'
    \}
    Plug 'artur-shaik/vim-javacomplete2', {
        \'for': 'java'
    \}

    "Plug 'Valloric/YouCompleteMe', {
    "    \'do': './install.py --clang-completer'
    "\}
    "Plug 'rdnetto/YCM-Generator', {
    "    \'branch': 'stable',
    "    \'for': 'YcmGenerateConfig'
    "\}

    if has('nvim')
        Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    else
        Plug 'Shougo/deoplete.nvim'
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
    endif
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'sjl/gundo.vim', {
        \'on': 'GundoToggle'
    \}
    Plug 'luochen1990/rainbow', {
        \'on': 'RainbowToggle'
    \}
    Plug 'gorodinskiy/vim-coloresque'
    Plug 'iCyMind/NeoSolarized'
    Plug 'chrisbra/unicode.vim', {
        \'on': ['Digraphs',
               \'UnicodeTable',
               \'UnicodeName',
               \'SearchUnicode',
               \'DownloadUnicode']
    \}
    Plug 'KabbAmine/zeavim.vim'
    Plug 'majutsushi/tagbar', {
        \'on': 'TagbarToggle'
    \}

    " Initialize plugin system
    call plug#end()

    " }}}
    let g:indentLine_char = '┆'
    " Neomake settings {{{
    " Quick leader toggle for Neomake checking
    nnoremap <Leader>tc :NeomakeToggle<CR>
    nnoremap <Leader>m :Neomake
    " Automatically run neomake when writing a buffer
    call neomake#configure#automake('w')
    " }}}
    " Deoplete settings {{{
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#sources#jedi#show_docstring = 1
    " Quick leader toggle for autocompletion
    nnoremap <Leader>ta :call deoplete#toggle()<CR>
    " }}}
    " Disable easytag's warning about vim's updatetime being too low
    let g:easytags_updatetime_warn = 0
    let g:easytags_async = 1
    " NERDTree settings {{{
    command! Tree NERDTreeTabsToggle
    nnoremap <Leader>t :Tree<CR>
    let g:nerdtree_tabs_open_on_gui_startup = 0
    let g:nerdtree_tabs_open_on_console_startup = 0
    let g:nerdtree_tabs_no_startup_for_diff = 1
    let g:nerdtree_tabs_smart_startup_focus = 1
    let g:nerdtree_tabs_open_on_new_tab = 1
    let g:nerdtree_tabs_meaningful_tab_names = 1
    let g:nerdtree_tabs_autoclose = 1
    let g:nerdtree_tabs_synchronize_view = 1
    let g:nerdtree_tabs_synchronize_focus = 1
    " }}}
    let g:gundo_width = 30
    let g:gundo_preview_height = 20
    let g:gundo_right = 1
    let g:gundo_preview_bottom = 1
    command! DiffTree GundoToggle
    let g:notes_directories = ['~/Dropbox/Shared Notes']
    let g:notes_word_boundaries = 1
    nnoremap <Leader>n :Note 
    let g:calendar_google_calendar = 1
    let g:calendar_google_task = 0
    let g:calendar_cache_directory = expand('~/Dropbox/vim/calendar.vim')
    let g:ycm_semantic_triggers = {'haskell' : ['.']}
    let g:jedi#popup_on_dot = 1
    let g:jedi#popup_select_first = 0
    let g:jedi#show_call_signatures = "1"
    let g:jedi#completions_command = "<A-Space>"
    let g:jedi#goto_assignments_command = "<Leader>G"
    let g:jedi#goto_definitions_command = "<Leader>D"
    let g:jedi#usages_command = "<Leader>N"
    let g:jedi#rename_command = "<Leader>R"
    let g:python_highlight_all = 1
    let g:UltiSnipsExpandTrigger = "<LocalLeader><Tab>"
    let g:UltiSnipsListSnippets = "<LocalLeader><LocalLeader>"
    let g:UltiSnipsJumpForwardTrigger = "<Tab>"
    let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
    let g:UltiSnipsEditSplit = "vertical"
    let g:rainbow_active = 0
    let g:rainbow_conf = {
        \'guifgs': ['195', '33', '178', '69'],
        \'ctermfgs': ['195', '33', '178', '69']
    \}
    let g:neosolarized_contrast = "high"
    nnoremap <Leader>u :Unite file buffer<CR>
    nnoremap <Leader>ur :Unite file buffer file_rec<CR>
    nnoremap <Leader>uo :Unite output:
    nnoremap <Leader>umru :Unite output:ol<CR>
    nnoremap <F8> :TagbarToggle<CR>
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
    let winWidth = 0
    for winNr in range(winnr('$'))
        let w = winwidth(winNr + 1)
        if w > winWidth
            let winWidth = w
        endif
    endfor
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
augroup ft_java
    autocmd Filetype java call s:FileType_Java()
augroup END
function! s:FileType_Java()
    " Use Ctrl-] to expand abbreviation
    inoreabbrev psvm public static void main(String[] args) {}<esc>i<CR><esc>ko
    inoreabbrev sysout System.out.println("");<esc>2hi
    inoreabbrev syserr System.err.println("");<esc>2hi
endfunction
augroup ft_c
    autocmd Filetype c call s:FileType_C()
augroup END
function! s:FileType_C()
    inoreabbrev #<defaults> #include <stdio.h><CR>#include <stdlib.h>
endfunction
function! CustomNotesFoldText()
    " Show number of lines in fold
    return xolox#notes#foldtext() . '(' . (v:foldend - v:foldstart) . ')'
endfunction
augroup ft_notes
    autocmd Filetype notes setlocal foldtext=CustomNotesFoldText()
augroup END
augroup ft_haskell
    " Disable haskell-vim omnifunc
    let g:haskellmode_completion_ghc = 0
    autocmd Filetype haskell setlocal omnifunc=necoghc#omnifunc
    let g:necoghc_enable_detailed_browse = 1
augroup END
" }}}
" Pre-start function calls (non-autocommand) {{{
if has("gui_running")
    call Custom()
elseif empty($DISPLAY) "If running in a tty, use solarized theme for better colors
    call Solarized()
else
    call Custom()
endif
call s:SetMappings()
" }}}
" Neovim {{{
if has('nvim')
    tnoremap <Esc> <C-\><C-n>   " Escape to exit terminal insert mode
    " Use :terminal to execute shell command
    nnoremap <Leader>c :terminal 
endif
" }}}
