set tabstop=4
set shiftwidth=4
colorscheme default
:command Q q
:command W w
" Allow saving when forgetting to start vim with sudo
cmap w!! w !sudo tee > /dev/null %
