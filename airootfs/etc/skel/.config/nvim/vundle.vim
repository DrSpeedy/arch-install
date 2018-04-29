set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=$HOME/.config/nvim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
call vundle#begin("$HOME/.config/nvim/bundle")

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'


" Utilities
Plugin 'scrooloose/syntastic'
Plugin 'ervandew/supertab'
Plugin 'ap/vim-buftabline'
Plugin 'vimlab/split-term.vim'

" Files
Plugin 'rbgrouleff/bclose.vim'
Plugin 'francoiscabrol/ranger.vim'

" Documentation
Plugin 'euclio/vim-markdown-composer'

" Web Development
Plugin 'tobyS/vmustache'
Plugin 'tobyS/pdv'                      " PHP Documentor
Plugin 'jwalton512/vim-blade'
Plugin 'pangloss/vim-javascript'

" Syntax
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'PotatoesMaster/i3-vim-syntax'

" Appearance
Plugin 'morhetz/gruvbox'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tyrannicaltoucan/vim-quantum'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
