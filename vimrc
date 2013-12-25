set nocp
set hidden " Hides buffers instead of closing them, allows opening new buffers when current has unsaved changes
set title " Show title in terminal
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
set statusline=%t       "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
hi StatusLine ctermfg=239
hi StatusLine ctermbg=118
