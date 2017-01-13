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
:command StripWhiteSpace %s/\s\+$//

" JS prettier formatter
autocmd FileType javascript set formatprg=prettier\ --stdin

" Vim-plug
call plug#begin()
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-surround'
Plug 'Raimondi/delimitMate'
Plug 'scrooloose/syntastic'
Plug 'vim-scripts/a.vim'
Plug 'jez/vim-better-sml'
Plug 'valloric/youcompleteme'
Plug 'rust-lang/rust.vim'
call plug#end()

" Tab settings
set tabstop=2
set shiftwidth=2
set laststatus=2
set colorcolumn=80
set expandtab

set splitright         "   Vertical splits  use   right half  of screen
set splitbelow         " Horizontal splits  use  bottom half  of screen
