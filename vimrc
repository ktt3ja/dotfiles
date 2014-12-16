set nocompatible

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Autoinstall NeoBundle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let iCanHaveNeoBundle=1
let neobundle_readme=expand($HOME.'/.vim/bundle/neobundle.vim/README.md')
if !filereadable(neobundle_readme)
    echo "Installing NeoBundle.."
    echo ""
    silent !mkdir -p $HOME/.vim/bundle
    silent !git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
    let iCanHaveNeoBundle=0
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NeoBundle settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('vim_starting')
    set rtp+=$HOME/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand($HOME.'/.vim/bundle'))

NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimproc.vim', {
    \ 'build' : {
    \     'windows' : 'tools\\update-dll-mingw',
    \     'cygwin' : 'make -f make_cygwin.mak',
    \     'mac' : 'make -f make_mac.mak',
    \     'unix' : 'make -f make_unix.mak',
    \    },
    \ }
NeoBundle 'tpope/vim-commentary'

call neobundle#end()
filetype plugin indent on

NeoBundleCheck

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Unite
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <Space> [unite]
nnoremap [unite] <NOP>

let g:unite_source_history_yank_enable = 1
if executable('ag')
    let g:unite_source_rec_async_command = 'ag --follow --nocolor --nogroup --hidden -g ""'
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nocolor --nogroup -S -C3'
    let g:unite_source_grep_recursive_opt = ''
elseif executable('ack')
    let g:unite_source_rec_async_command = 'ack --follow --nocolor --nogroup -g'
    let g:unite_source_grep_command = 'ack'
    let g:unite_source_grep_default_opts = '--nocolor --nogroup -C3'
    let g:unite_source_grep_recursive_opt = ''
endif
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])

nnoremap [unite]f :<C-u>Unite -no-split -start-insert -buffer-name=files file_rec/async<CR>
nnoremap [unite]m :<C-u>Unite -no-split -buffer-name=mru -start-insert file_mru<cr>
nnoremap [unite]/ :<C-u>Unite -no-split grep:.<cr>
nnoremap [unite]y :<C-u>Unite -no-split -buffer-name=yank -start-insert history/yank<cr>
nnoremap [unite]b :<C-u>Unite -no-split -buffer-name=buffer -quick-match buffer<cr>

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
    " Play nice with supertab
    let b:SuperTabDisabled=1
    " Enable navigation with control-j and control-k in insert mode
    imap <buffer> <C-j> <Plug>(unite_select_next_line)
    imap <buffer> <C-k> <Plug>(unite_select_previous_line)
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Neocomplete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:neocomplete#enable_at_startup = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntax, color, indentation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set background=light
colorscheme Tomorrow-Night-Eighties

set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4
set shiftround
set autoindent

autocmd FileType make setlocal noexpandtab
autocmd FileType html,javascript,ruby setlocal ts=2 sts=2 sw=2 expandtab

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => No backup files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nobackup
set nowritebackup
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Search and highlight
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set ignorecase
set smartcase
set incsearch
set hlsearch
set showmatch

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Column display
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set ruler
set colorcolumn=81

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Miscellaneous
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set hidden
set showcmd
set number
set listchars=tab:▸\ ,eol:¬
set backspace=indent,eol,start

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction
" autocmd BufWritePre * call TrimWhiteSpace()

" source the vimrc file after saving it
augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC source %
augroup END
