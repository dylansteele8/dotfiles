set nocompatible

" Basic commands
set backspace=indent,eol,start

set ruler
set showcmd
syntax enable
set nu
highlight LineNr ctermfg=lightgrey
set mouse=a
set lazyredraw
set showmatch
set smartcase

" Search settings
set incsearch
set hlsearch
nnoremap <C-L> :nohlsearch<CR><C-L>

" StripWhiteSpace
autocmd BufWritePre *  %s/\s\+$//e

" JS prettier formatter
autocmd FileType javascript set formatprg=prettier\ --stdin

" Vim-plug
call plug#begin()
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-surround'
Plug 'Raimondi/delimitMate'
Plug 'scrooloose/syntastic'
Plug 'jez/vim-better-sml'
" Plug 'valloric/youcompleteme'
Plug 'rust-lang/rust.vim'
Plug 'joshdick.onedark.vim'
Plug 'othree/html5.vim'
Plug 'Chielf92/vim-autoformat'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'ervandew/supertab'
Plug 'pangloss/vim-javascript'
Plug 'artoj/qmake-syntax-vim'
call plug#end()

" Tab settings
set tabstop=2
set shiftwidth=2
set laststatus=2
set colorcolumn=80
set expandtab

autocmd FileType cpp,hpp setlocal tabstop=4 shiftwidth=4

set splitright         "   Vertical splits  use   right half  of screen
set splitbelow         " Horizontal splits  use  bottom half  of screen

colorscheme onedark

let g:syntastic_javascript_checkers = ['eslint']
