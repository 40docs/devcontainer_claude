" Neovim configuration
syntax on
filetype plugin indent on
set nocompatible
set number
set ruler
set cmdheight=1
set foldcolumn=1
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set ignorecase
set hlsearch
set incsearch
set showmatch
set mat=2
set noerrorbells
set novisualbell
set t_vb=
set tm=500
syntax enable
set encoding=utf8
set ffs=unix,dos,mac
set t_Co=256
set t_ut=
set termguicolors
set background=dark
colorscheme catppuccin-mocha
set laststatus=2
set noshowmode
set autoindent expandtab tabstop=2 shiftwidth=2
set backup
set backupdir=/tmp
set dir=/tmp

" Return to last edit position when opening files
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif
