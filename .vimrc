" disable compatibility with vi
set nocompatible

set shell=zsh\ -i

" set encoding
set encoding=utf-8

" enable line number
set number

" enable type file detection
filetype off " TODO

" load an indent file for the detected file type
filetype indent on

" enable syntaxt highlighting
syntax on

" set shift width
set shiftwidth=2

" set tab width
set tabstop=2

" use space for indent
set expandtab

" disable line warp
set nowrap

" highlight matching characters
set incsearch
set showmatch
set hlsearch

" disable highlight after press ESC
nnoremap <CR> :nohlsearch<CR><CR>

" enable auto completion menu (press TAB)
set wildmenu

" make wildmenu behave like similar to Bash completion
set wildmode=list:longest

" disable sound effect
set noerrorbells
set visualbell

" copy indent from current line when starting a new line
set autoindent

" even better autoindent (e.g. add indent after '{')
set smartindent

" autoreload the file in Vim if it has been changed outside of Vim
set autoread

" status linei
set laststatus=2
set statusline=\ %F
set statusline+=%=
set statusline+=\ %M\ %Y\ 

" disable backup (It's very simple, always save!)
set nobackup
set nowritebackup
set noswapfile

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

set t_Co=256

" Required for Vundel (https://github.com/VundleVim/Vundle.vim#quick-start)
set nocompatible

" Set paste mode key.
set pastetoggle=<C-p>

" line warp for markdown
augroup Markdown
  autocmd!
  autocmd FileType markdown set wrap
augroup END

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'dracula/vim', { 'name': 'dracula' }
Plugin 'vim-airline/vim-airline'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'
Plugin 'editorconfig/editorconfig-vim'

call vundle#end()

" enable plugins and load plugin for the detected file type
filetype plugin on

" Theme
colorscheme dracula
let g:airline_theme='dracula'

