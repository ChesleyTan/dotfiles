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
syntax on
filetype indent on
filetype plugin on
colorscheme default
:command Q q
:command W w
" Allow saving when forgetting to start vim with sudo
cmap w!! w !sudo tee > /dev/null %
