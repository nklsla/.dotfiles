" Settings
set number
set relativenumber
set expandtab
set tabstop=2
set shiftwidth=2
:colorscheme murphy
:filetype on

" Save with ctrl-s
nnoremap <c-s> <cmd>:w<CR>
inoremap <c-s> <esc> :w <CR> hi

" Yank from cursor until EOF
nnoremap Y y$

" Paste without overwriting clipboard
vnoremap p "_dp

" Escape insert mode
inoremap jj <esc>

" Speed jump
noremap J 3j
noremap K 3k

" Navigate the split view easier by pressing CTRL+j, CTRL+k, CTRL+h, or CTRL+l.
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Resize split windows using arrow keys by pressing:
" CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT.
noremap <c-up> <c-w>+
noremap <c-down> <c-w>-
noremap <c-left> <c-w>>
noremap <c-right> <c-w><
