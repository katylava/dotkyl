call plug#begin('~/.config/nvim/plugged') " https://github.com/junegunn/vim-plug
" Plug 'edkolev/promptline.vim' " https://github.com/edkolev/promptline.vim
" Plug 'scrooloose/syntastic' " https://github.com/scrooloose/syntastic
Plug 'Shougo/deoplete.nvim' " https://github.com/Shougo/deoplete.nvim
Plug 'benekastah/neomake' " https://github.com/benekastah/neomake
" Plug 'bling/vim-airline' " https://github.com/bling/vim-airline
" Plug 'briancollins/vim-jst', { 'for': 'ejs' } " https://github.com/briancollins/vim-jst
Plug 'nikvdp/ejs-syntax', { 'for': 'ejs' } " https://github.com/nikvdp/ejs-syntax
Plug 'chrisbra/csv.vim', { 'for': 'csv' } " https://github.com/chrisbra/csv.cim
Plug 'davidoc/taskpaper.vim' " https://github.com/davidoc/taskpaper.vim
Plug 'easymotion/vim-easymotion' " https://github.com/easymotion/vim-easymotion
Plug 'elzr/vim-json', { 'for': 'json' } " https://github.com/elzr/vim-json
Plug 'godlygeek/tabular' " https://github.com/godlygeek/tabular
Plug 'itchyny/lightline.vim' " https://github.com/itchyny/lightline.vim
Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' } " https://github.com/jelera/vim-javascript-syntax
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-textobj-line' " https://github.com/kana/vim-textobj-line
Plug 'kana/vim-textobj-user' " https://github.com/kana/vim-textobj-user
Plug 'kien/ctrlp.vim' " https://github.com/kien/ctrlp.vim
Plug 'kshenoy/vim-signature' " https://github.com/kshenoy/vim-signature
Plug 'lambdatoast/elm.vim' " https://github.com/lambdatoast/elm.vim
Plug 'mattn/emmet-vim', { 'for': ['html', 'htmldjango', 'ejs'] } " https://github.com/mattn/emmet-vim
Plug 'mhinz/vim-signify' " https://github.com/mhinz/vim-signify
Plug 'moll/vim-node', { 'for': 'javascript' } " https://github.com/moll/vim-node
Plug 'mxw/vim-jsx', { 'for': 'javascript' } " https://github.com/mxw/vim-jsx
Plug 'myhere/vim-nodejs-complete', { 'for': 'javascript' } " https://github.com/myhere/vim-nodejs-complete
Plug 'nathanaelkane/vim-indent-guides' " https://github.com/nathanaelkane/vim-indent-guides
Plug 'pangloss/vim-javascript', { 'for': 'javascript' } " https://github.com/pangloss/vim-javascript
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' } " https://github.com/plasticboy/vim-markdown
Plug 'rizzatti/dash.vim' " https://github.com/rizzatti/dash.vim
Plug 'scrooloose/nerdtree' " https://github.com/scrooloose/nerdtree
Plug 'tpope/vim-rhubarb' " https://github.com/tpope/vim-rhubarb
Plug 'tpope/vim-characterize' " https://github.com/tpope/vim-characterize
Plug 'tpope/vim-commentary' " https://github.com/tpope/vim-commentary
Plug 'tpope/vim-dotenv' " https://github.com/tpope/vim-dotenv
Plug 'tpope/vim-eunuch' " https://github.com/tpope/vim-eunuch
Plug 'tpope/vim-fugitive' " https://github.com/tpope/vim-fugitive
Plug 'tpope/vim-repeat' " https://github.com/tpope/vim-repeat
Plug 'tpope/vim-surround' " https://github.com/tpope/vim-surround
Plug 'tpope/vim-unimpaired' " https://github.com/tpope/vim-unimpaired
Plug 'tweekmonster/braceless.vim', { 'for': ['python', 'coffee', 'yaml'] } " https://github.com/tweekmonster/braceless.vim
Plug 'vim-scripts/SyntaxAttr.vim' " https://github.com/vim-scripts/SyntaxAttr.vim
Plug 'vim-scripts/swap-parameters' " https://github.com/vim-scripts/swap-parameters
" This modifies other plugins, so has to come last
Plug 'ryanoasis/vim-devicons'
" colorschemes
Plug 'crusoexia/vim-monokai' " https://github.com/crusoexia/vim-monokai
Plug 'NLKNguyen/papercolor-theme' " https://github.com/NLKNguyen/papercolor-theme
" Plug 'dracula/vim' " https://github.com/dracula/vim
" Plug 'goatslacker/mango.vim'
call plug#end()

filetype on
filetype plugin on
filetype indent on

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

set completeopt=menu,longest,preview
" set cursorline " didn't realize this makes vim slower
set fileencoding=utf-8 ff=unix " don't set encoding=utf-8... nvim sets it by default
set exrc secure " enable per-directory .vimrc files
set grepprg=ag
set ignorecase smartcase
set iskeyword+=-
set nobackup dir=~/.tmp/nvim
set noerrorbells visualbell t_vb=
set nofixeol
set nohlsearch incsearch
set nowrap linebreak
set number
set pastetoggle=<F8>
set ruler laststatus=2 " one of these ensures each window contains a status line
set scrolloff=3
set synmaxcol=200
set t_Co=256
set title
set ts=4 sw=4 ai expandtab
set ttyfast
set tw=79 colorcolumn=80,100
set wildignore=.svn,.git,.env,*.bak,*.pyc,*.DS_Store,*.db,venv
set wildmenu wildmode=list:longest

autocmd BufRead .bash*      set filetype=sh
autocmd BufRead *.cls       set filetype=apex
autocmd BufRead *.ejs       set filetype=ejs
autocmd BufRead *.htm*      set filetype=htmldjango omnifunc=htmlcomplete#CompleteTags
autocmd BufRead *.md        set filetype=markdown
autocmd BufRead *.page      set filetype=visualforce
autocmd BufRead *.py        set filetype=python commentstring=#\ %s
autocmd BufRead *.scss      set filetype=sass
autocmd BufRead *.sql       set filetype=sql commentstring=--\ %s
autocmd BufRead *.txt       set filetype=markdown
autocmd BufRead .zsh*      set filetype=sh

autocmd BufRead requirements.txt set filetype=text sw=2 ts=2
autocmd BufRead requirements/*.txt set filetype=text sw=2 ts=2

autocmd FileType apex       set foldmethod=indent commentstring=//\ %s
autocmd FileType ejs        set tw=0 foldmethod=indent
autocmd FileType htmldjango set foldmethod=indent
autocmd FileType javascript set tw=120 colorcolumn=120 foldmethod=indent omnifunc=javascriptcomplete#CompleteJS
autocmd FileType javascript.jsx set tw=120 colorcolumn=120 foldmethod=indent omnifunc=javascriptcomplete#CompleteJS
autocmd FileType json       set foldmethod=syntax
autocmd FileType mkd        set ts=2 sw=2
autocmd FileType python     set foldmethod=indent omnifunc=pythoncomplete#Complete
autocmd FileType sass       set foldmethod=indent sw=4
autocmd FileType yaml       set foldmethod=indent sw=2 ts=2

" To avoid error 'crontab: temp file must be edited in place'
autocmd filetype crontab setlocal nobackup nowritebackup

" tabs in python are bad!
autocmd FileType python	highlight Tabs ctermbg=red guibg=red
autocmd FileType python match Tabs /^\t+/

" Automatically chmod +x Shell scripts
autocmd BufWritePost *.sh silent !chmod +x %

" Open file at last edited location
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" Title string
autocmd BufEnter * let &titlestring = 'δ ' . expand("%:t") . ' ∈ ' . FileDir()

" ------------------
" Theme
" ------------------

set background=dark
colorscheme PaperColor

" disable the annoying HTML link underlining
hi link htmlLink NONE
hi link htmlItalic NONE

hi mkdCode ctermfg=109
hi mkdListItemLine ctermfg=139
hi mkdLink ctermfg=105
hi mkdURL ctermfg=60
hi htmlH1 ctermfg=225
hi htmlH2 ctermfg=218
hi htmlH3 ctermfg=182
hi htmlH4 ctermfg=139
hi htmlH5 ctermfg=96
hi htmlH6 ctermfg=239


" -------------
" Mappings
" -------------

:let mapleader='\'

nnoremap ,n :source ~/.config/nvim/init.vim<CR>

inoremap jk <Esc>
inoremap <TAB><TAB> <C-p>

tnoremap jk <C-\><C-n>

" i'm not sure why i have these, can't remember when i needed them
nnoremap [[ [{
nnoremap ]] ]}

nnoremap <C-j> :wincmd j<CR>
nnoremap <C-k> :wincmd k<CR>
nnoremap <C-h> :wincmd h<CR>
nnoremap <C-l> :wincmd l<CR>
tnoremap <C-j> <C-\><C-n><C-w>h
tnoremap <C-k> <C-\><C-n><C-w>j
tnoremap <C-h> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

 " <opt> = - . ,
nnoremap ≠ 10<C-W>+
nnoremap – 10<C-W>-
nnoremap ≥ 10<C-W>>
nnoremap ≤ 10<C-W><

" <opt> b f k j
nnoremap ∫ <C-W>H
nnoremap ƒ <C-W>L
nnoremap ˚ <C-W>K
nnoremap ∆ <C-W>J

" <opt> 0 9 p o
nnoremap º :tabnext<CR>
nnoremap ª :tabprevious<CR>
nnoremap π :tabnext<CR>
nnoremap ø :tabprevious<CR>

" popup window - use Ctrl+j/k instead of Ctrl+n/p
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

" _ does the same as ^, as far as i can tell, so may as well remap it
nnoremap _ g_
vnoremap _ g_

" select just-pasted lines
nnoremap gp `[v`]

" insert space or newline and get back to normal mode
nnoremap <silent> gj o<Esc>
nnoremap <silent> gk O<Esc>
nnoremap <silent> gh i<Space><Esc>
nnoremap <silent> gl a<Space><Esc>
nnoremap <silent> gn i<CR><Esc>

" center search result
nnoremap N Nzz
nnoremap n nzz

" easier system clipboard access
noremap ,y "+y
noremap ,p "+p

" Common Command Typos
command! Q  quit    " converts ... :Q  => :q
command! W  write   " converts ... :W  => :w
command! Wq wq      " converts ... :Wq => :wq
command! Wn wn      " converts ... :Wn => :wn
command! WN wN      " converts ... :WN => :wN

" don't show help when F1 is pressed
map <F1> <ESC>

" Remove trailing space without overwriting current search
nnoremap <silent> ,s :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" getting into terminal mode
nnoremap ,tv :vsp term://bash<CR>i
nnoremap ,tx :sp term://bash<CR>i

" folding
nnoremap fs :SignifyFold<CR>
nnoremap fi :set foldmethod=indent<CR>

" background toggle
map <Leader>bg :let &background = ( &background == "dark"? "light" : "dark" )<CR>



" ---------------------
" Plugin configuration
" ---------------------

" vim-easymotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
"let g:EasyMotion_smartcase = 1
nmap ,z <Plug>(easymotion-overwin-f2)
map ,j <Plug>(easymotion-j)
map ,k <Plug>(easymotion-k)

"  vim-jsx
let g:jsx_ext_required = 0

" vim-airline
let g:airline_theme = 'dark'
let g:airline_powerline_fonts = 1

" vim-signify
let g:signify_vcs_list = [ 'git' ]

" lightline
let g:lightline = {
      \ 'colorscheme': 'PaperColor',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'filedir', 'filename' ] ],
      \   'right': [ [ 'percent', 'lineinfo' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ],
      \              [ 'time'] ],
      \ },
      \ 'component': {
      \   'lineinfo': ' %2v:%-3l',
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightlineFugitive',
      \   'readonly': 'LightlineReadonly',
      \   'modified': 'LightlineModified',
      \   'filedir': 'FileDir',
      \   'filename': 'LightlineFilename',
      \   'time': 'LightlineTime'
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
      \ }

" PaperColor
let g:PaperColor_Theme_Options = {
      \   'theme': {
      \     'default': {
      \       'allow_bold': 1,
      \       'allow_italic': 1,
      \       'transparent_background': 1
      \     }
      \   },
      \   'language': {
      \     'python': {
      \       'highlight_builtins' : 1
      \     }
      \   }
      \ }

" python
let python_highlight_all = 1
let g:pyflakes_use_quickfix = 0

" CtrlP
map ,f :CtrlP<CR>
map ,m :CtrlPMRU<CR>
map ,g :CtrlPBuffer<CR>
map ,r :CtrlPClearCache<CR>
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_dotfiles = 0
let g:ctrlp_map = '<C-q>'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|env'

" FZF
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_command_prefix = 'Fzf'

" deoplete
let g:deoplete#enable_at_startup = 1

" indent-guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']

" NERDtree
map ,d :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$']
let NERDTreeWinSize = 45

" syntastic
" let g:syntastic_javascript_checkers = ['eslint']

" neomake
autocmd BufWritePost * Neomake
autocmd! QuitPre * let g:neomake_verbose = 0
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_python_flake8_maker = { 'args': ['--ignore=E501,E731'] }
let g:neomake_python_enabled_makers = ['flake8']

" vim-json
let g:vim_json_syntax_conceal = 0


" promptline
" let g:promptline_preset = {
"         \'a' : [ promptline#slices#cwd() ],
"         \'b' : [ promptline#slices#python_virtualenv() ],
"         \'c' : [ '⛵️' ],
"         \'x' : [ '%*' ],
"         \'y' : [ promptline#slices#vcs_branch() ],
"         \'z' : [ promptline#slices#git_status() ],
"         \'warn' : [ promptline#slices#last_exit_code() ]}



" -----------
" Functions
" -----------

function! FileDir()
    let filedir = substitute(expand("%:p:h"), '/Users/kyl/', '', 'g')
    let filedir = substitute(expand("%:p:h"), '/Users/kathleenlavalle/', '', 'g')
    " Don't show common parent directories
    let filedir = substitute(l:filedir, 'Code/', '', 'g')
    let filedir = substitute(l:filedir, 'Work/', '', 'g')
    " Shorten these a lot
    let filedir = substitute(l:filedir, '.dotkyl/', '…', 'g')
    " Shorten everything else a little by removing vowels
    " (unless that vowel is the beginning of a word)
    let filedir = substitute(l:filedir, '\(\<\)\@<![aeiou]', '', 'g')
    " Then remove double letters
    let filedir = substitute(l:filedir, '\([a-zA-Z]\)\1', '\1', 'g')
    " Except these are better with vowels
    let filedir = substitute(l:filedir, '\.rg/', '.org/', 'g')
    return filedir
endfunction

function! LightlineModified()
  if &filetype == "help"
    return ""
  elseif &modified
    return "+"
  elseif &modifiable
    return ""
  else
    return ""
  endif
endfunction

function! LightlineReadonly()
  if &filetype == "help"
    return ""
  elseif &readonly
    return "\ue0a2"
  else
    return ""
  endif
endfunction

function! LightlineFugitive()
  if exists("*fugitive#head")
    let branch = fugitive#head()
    return branch !=# '' ? ' '.branch : ''
  endif
  return ''
endfunction

function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
       \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
       \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineTime()
    return strftime('%H:%M')
endfunction


" ------------------------------
" Highlight trailing whitespace
" ------------------------------

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
