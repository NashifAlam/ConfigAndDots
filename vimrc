"VIMRC Configuration file 

"ADDTIONAL"
"use s "
"habamax light one"
":marks"


if !has('gui_running')
	set t_Co=256
endif

set termguicolors
colorscheme lunaperche

filetype on
filetype indent on
syntax on

set shiftwidth=4
set softtabstop=4
set tabstop=4

set cursorline
set cursorcolumn
set autoindent

set number relativenumber
set splitright splitbelow
set hlsearch
set incsearch
set clipboard=unnamedplus

noremap <C-S-c> "+y
noremap <C-S-v> "+p
noremap y "+y
noremap p "+p

noremap <c-up> <c-w>+
noremap <c-down> <c-w>-
noremap <c-left> <c-w>>
noremap <c-right> <c-w><
noremap s :%s//g<Left><Left>

inoremap jj <Esc>


autocmd InsertEnter * set nocursorline
autocmd InsertLeave * set cursorline
autocmd InsertEnter * set nocursorcolumn
autocmd InsertLeave * set cursorcolumn



highlight Cursorline cterm=bold ctermbg=Yellow guibg=#2b2b2b
