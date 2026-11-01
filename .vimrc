" Settings
set number
set relativenumber
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set scrolloff=8
set timeoutlen=100

" Filetype aware syntax coloring
filetype plugin indent on
syntax enable

:colorscheme desert
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

" Alt+Backspace deletes the previous word (Konsole sends Alt as ESC + key,
" so map both the true-Meta form and the ESC-prefixed form)
inoremap <M-BS> <C-w>
inoremap <Esc><BS> <C-w>

" Reverse-indent, dent?
inoremap <S-Tab> <C-d>

" Speed jump
noremap J 3j
noremap K 3k

" Alt+j / Alt+k jump 7 lines
" (Konsole sends Alt as ESC + key, so both forms are mapped)
noremap <M-j> 7j
noremap <M-k> 7k
noremap <Esc>j 7j
noremap <Esc>k 7k

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

" Search word under cursor & replace it, then . repeats on next match
" (mirrors the <C-d> binding in VSCode settings.json)
" NOTE: visual version omits "iw" — "dy already yanks the selection;
" the "iw" would be executed after the yank and type itself into the buffer.
nnoremap <C-d> "dyiw/<C-r>d<CR>Ncgn
vnoremap <C-d> "dy/<C-r>d<CR>Ncgn

" Use the system clipboard for yanked text (vim package is built
" -clipboard, so sync to the clipboard via xclip instead)
if executable('xclip')
    set clipboard=unnamedplus
    function! s:SyncClipboard() abort
        " only mirror copies to the unnamed/default register, like VSCode
        if v:event.operator ==# 'y' && v:event.regname ==# ''
            call system('xclip -selection clipboard -i', getreg('"'))
        endif
    endfunction
endif

" Highlight yanked text briefly (like vim.highlightedyank, 350ms)
highlight! link HighlightedyankRegion IncSearch
function! s:ClearYankHl() abort
    if exists('s:yank_hl_id')
        silent! call matchdelete(s:yank_hl_id)
        unlet s:yank_hl_id
    endif
endfunction
function! s:HighlightYank() abort
    call s:ClearYankHl()
    if v:event.operator !=# 'y'
        return
    endif
    let l:s = getpos("'[")
    let l:e = getpos("']")
    let l:p = []
    if l:s[1] ==# l:e[1]
        let l:p += [[l:s[1], l:s[2], l:e[2] - l:s[2] + 1]]
    else
        let l:p += [[l:s[1], l:s[2], col([l:s[1], '$']) - l:s[2] + 1]]
        for l:n in range(l:s[1] + 1, l:e[1] - 1)
            let l:p += [[l:n, 1, col([l:n, '$'])]]
        endfor
        let l:p += [[l:e[1], 1, l:e[2]]]
    endif
    let l:p = filter(l:p, 'v:val[2] > 0')
    if !empty(l:p)
        let s:yank_hl_id = matchaddpos('HighlightedyankRegion', l:p, 10)
        call timer_start(350, {-> s:ClearYankHl()})
    endif
endfunction
augroup HighlightedYank
    autocmd!
    autocmd TextYankPost * call s:HighlightYank()
    if executable('xclip')
        autocmd TextYankPost * call s:SyncClipboard()
    endif
augroup END

