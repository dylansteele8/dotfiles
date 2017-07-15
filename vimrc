" Visual
set cursorline
syntax enable
colorscheme onedark

" Pretty vertical split
set fillchars=vert:|   " vertical box-drawing character
set splitright         " Vertical splits use right half of screen
set splitbelow         " Horizontal splits use bottom half of screen
autocmd ColorScheme * highlight VertSplit cterm=NONE ctermbg=NONE guibg=NONE

set nocompatible
filetype plugin indent on
syntax on

" Usability options
set ignorecase
set smartcase
set backspace=indent,eol,start
set autoindent
set nostartofline
set ruler
set laststatus=2
set confirm
set visualbell
set mouse=a
set cmdheight=2
set number
set notimeout ttimeout ttimeoutlen=200
set pastetoggle=<F10>
set ttyfast

" Indentation options
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set shiftwidth=2
set colorcolumn=80

" Enable transparent background
hi Normal guibg=NONE ctermbg=NONE

" Strip whitespace on save
autocmd BufWritePre *  %s/\s\+$//e

" JS prettier formatter
" autocmd FileType javascript set formatprg=prettier\ --stdin

" Vim-plug
call plug#begin()
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-surround'
Plug 'Raimondi/delimitMate'
Plug 'scrooloose/syntastic'
Plug 'jez/vim-better-sml'
Plug 'valloric/youcompleteme'
Plug 'joshdick.onedark.vim'
Plug 'othree/html5.vim'
Plug 'Chielf92/vim-autoformat'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'ervandew/supertab'
Plug 'pangloss/vim-javascript'
Plug 'artoj/qmake-syntax-vim'
call plug#end()
