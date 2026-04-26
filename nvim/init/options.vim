let mapleader='\'

let g:python3_host_prog = exepath('python')

" File handling
set binary
set fileencoding=utf-8 ff=unix
set fixeol
set modeline
set hidden

" UI
set number
set ruler laststatus=2
set cmdheight=2
set cursorcolumn
set signcolumn=yes
set termguicolors
set title
set showbreak=↪\
set colorcolumn=80,100

" Scrolling / wrapping
set nowrap linebreak
set scrolloff=3

" Indentation
set ts=4 sw=4 ai expandtab

" Search
set ignorecase smartcase
set nohlsearch incsearch

" Folding
set foldmethod=indent

" Completion
set completeopt=menu,longest,preview
set shortmess+=c
set updatetime=300

" Whitespace display
set listchars=space:⋅,tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨

" Bell
set noerrorbells visualbell

" Backup
set nobackup nowritebackup dir=~/.tmp/nvim

" Grep
set grepprg=ag

" Text width
set tw=79

" Keywords
set iskeyword+=-

" Mouse
set mouse=a

" Wildmenu
set wildignore=.svn,.git,.env,*.bak,*.pyc,*.DS_Store,*.db,venv
set wildmenu wildmode=list:longest
