"""""""""""""
""" Shell """
"""""""""""""

set shell=/bin/zsh


"""""""""""""""
""" Leaders """
"""""""""""""""

let mapleader = ","
let maplocalleader = "\\"


"""""""""""""""
""" Plugins """
"""""""""""""""

call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

Plug 'fatih/vim-go'
Plug 'hashivim/vim-terraform'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'sjl/vitality.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'uarun/vim-protobuf'

call plug#end()


""""""""""""""""""""""""
""" General Settings """
""""""""""""""""""""""""

set nocompatible
set number
set splitright
set splitbelow
set belloff=all
set ruler
set showtabline=2
set laststatus=2
set termguicolors
set showcmd
set lazyredraw


""""""""""""""""""
""" Whitespace """
""""""""""""""""""

set shiftwidth=4
set shiftround
set tabstop=4
set softtabstop=0
set expandtab
set smarttab
set autoindent


""""""""""""""""""""
""" Text Editing """
""""""""""""""""""""

set wrap
set linebreak
set textwidth=0
set showmatch
set virtualedit=onemore
set backspace=indent,eol,start
set completeopt=menu,menuone
set pumheight=10
set clipboard=unnamed


"""""""""""""""""""""
""" File Settings """
"""""""""""""""""""""

set encoding=utf-8
set autoread
set autowrite
set noswapfile
set nobackup
set hidden


""""""""""""""
""" Search """
""""""""""""""

set hlsearch
set ignorecase
set smartcase
set incsearch


"""""""""""""""""""
""" Status Line """
"""""""""""""""""""

set statusline=%f\          " Path to the file
set statusline+=%h%w%m%r\   " Buffer status flags
set statusline+=%=          " Switch to the right side
set statusline+=\ %y\       " File type
set statusline+=%l:%c%V     " Current line and column(s)


""""""""""""
""" Undo """
""""""""""""

set undolevels=1000
if has('persistent_undo')
    set undofile
    set undodir=~/.config/vim/tmp/undo//
endif


""""""""""""""""
""" Mappings """
""""""""""""""""

" move lines up and down
nnoremap <leader>- ddp
nnoremap <leader>= ddkP

" edit/source vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" typos
iabbrev adn and
iabbrev hte the

" wrap text objects in quotes
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>
vnoremap <leader>' <esc>`>a'<esc>`<i'<esc>

" jump to beginning/end of line
nnoremap H ^
onoremap H ^
nnoremap L $
onoremap L $

" movements to paren groups
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F)vi(<cr>
onoremap an( :<c-u>normal! f(va(<cr>
onoremap al( :<c-u>normal! F)va(<cr>

" search
nnoremap n nzz
nnoremap N Nzz
nnoremap <leader>/ :let @/ = ""<cr>
nnoremap / /\v
nnoremap ? ?\v

" NERDTree
nnoremap <leader>n :NERDTreeFocus<cr>
nnoremap <c-n> :NERDTree<cr>
nnoremap <c-t> :NERDTreeToggle<cr>
nnoremap <c-f> :NERDTreeFind<cr>

" FZF
nnoremap <leader>o :Files<cr>
nnoremap <leader>f :Rg<cr>

" matching brackets
" inoremap {<cr> {<cr>}<esc>ko<tab>
" inoremap [<cr> [<cr>]<esc>ko<tab>
" inoremap (<cr> (<cr>)<esc>ko<tab>


"""""""""""""""""""""
""" Muscle Memory """
"""""""""""""""""""""

nnoremap <left> <nop>
nnoremap <down> <nop>
nnoremap <up> <nop>
nnoremap <right> <nop>
inoremap <left> <nop>
inoremap <down> <nop>
inoremap <up> <nop>
inoremap <right> <nop>
vnoremap <left> <nop>
vnoremap <down> <nop>
vnoremap <up> <nop>
vnoremap <right> <nop>


"""""""""""""""
""" NERDTree """
""""""""""""""""

augroup nerdtree
    autocmd!
    autocmd StdInReadPre * let s:std_in = 1
    autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
    autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
augroup END


""""""""""""""""""""""""""""""""""
""" FileType-specific Settings """
""""""""""""""""""""""""""""""""""

filetype off
filetype plugin indent on

augroup comments
    autocmd!
    autocmd FileType c,go,proto,rust,javascript nnoremap <buffer> <localleader>c I//<space><esc>
    autocmd FileType python nnoremap <buffer> <localleader>c I#<space><esc>
    autocmd FileType sql nnoremap <buffer> <localleader>c I--<space><esc>
    autocmd FileType vim nnoremap <buffer> <localleader>c I"<space><esc>
augroup END

augroup snippets
    autocmd!
    autocmd FileType c,go,rust,javascript :iabbrev <buffer> ret return
augroup END


"""""""""""""""""""""""
""" Syntax Settings """
"""""""""""""""""""""""

if !exists("g:syntax_on")
    syntax enable
endif

set background=dark
let g:oceanic_material_background = 'deep'
colorscheme oceanic_material


""""""""""""""
""" vim-go """
""""""""""""""

let g:go_fmt_command = "goimports"
let g:go_metalinter_autosave = 1
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"
let g:go_auto_sameids = 1
let g:go_auto_type_info = 1

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
