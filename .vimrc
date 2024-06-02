" Settings
set number
set relativenumber
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set scrolloff=8
:colorscheme murphy
:filetype on
let g:netrw_altv=1
let g:netrw_liststyle=3
let g:netrw_winsize=80

" Unmap Help shortcut
map <F1> <nop>
imap <F1> <nop>

" Toggle file explorer
noremap <silent> <F2> <CMD>:Lexplore \| vertical resize 35<CR>
noremap <silent> <C-E> <CMD>:Lexplore \| vertical resize 35<CR>

" Save with ctrl-s
nnoremap <c-s> <cmd>:w<CR>
inoremap <c-s> <esc> :w <CR> hi

" Yank from cursor until EOL
nnoremap Y y$

" Paste without overwriting clipboard
vnoremap p "_dp

" Escape insert mode
inoremap jj <esc>

" Reverse-indent, dent?
inoremap <S-Tab> <C-d>

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

