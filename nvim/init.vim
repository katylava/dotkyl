let g:python_host_prog='/usr/local/bin/python2'
let g:python3_host_prog='/usr/local/bin/python3'

call plug#begin('~/.config/nvim/plugged') " https://github.com/junegunn/vim-plug
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " https://github.com/Shougo/deoplete.nvim
Plug 'benekastah/neomake' " https://github.com/benekastah/neomake
Plug 'nikvdp/ejs-syntax', { 'for': 'ejs' } " https://github.com/nikvdp/ejs-syntax
Plug 'chrisbra/csv.vim', { 'for': 'csv' } " https://github.com/chrisbra/csv.cim
" Plug 'davidoc/taskpaper.vim' " https://github.com/davidoc/taskpaper.vim
Plug 'easymotion/vim-easymotion' " https://github.com/easymotion/vim-easymotion
Plug 'elzr/vim-json', { 'for': 'json' } " https://github.com/elzr/vim-json
Plug 'fatih/vim-go', { 'for': 'go' } " https://github.com/fatih/vim-go
Plug 'godlygeek/tabular' " https://github.com/godlygeek/tabular
Plug 'itchyny/lightline.vim' " https://github.com/itchyny/lightline.vim
Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' } " https://github.com/jelera/vim-javascript-syntax
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'  " Distraction-free writing
Plug 'junegunn/limelight.vim'  " Dims all but current block for focus (to use with goyo)
Plug 'kana/vim-textobj-line' " https://github.com/kana/vim-textobj-line
Plug 'kana/vim-textobj-user' " https://github.com/kana/vim-textobj-user
Plug 'kien/ctrlp.vim' " https://github.com/kien/ctrlp.vim
Plug 'kshenoy/vim-signature' " https://github.com/kshenoy/vim-signature
Plug 'kylef/apiblueprint.vim', { 'for': 'apiblueprint' } " https://github.com/kylef/apiblueprint.vim
" Plug 'lambdatoast/elm.vim' " https://github.com/lambdatoast/elm.vim
" Plug 'mattn/emmet-vim', { 'for': ['html', 'htmldjango', 'ejs'] } " https://github.com/mattn/emmet-vim
Plug 'mhinz/vim-signify' " https://github.com/mhinz/vim-signify
Plug 'moll/vim-node', { 'for': 'javascript' } " https://github.com/moll/vim-node
Plug 'mustache/vim-mustache-handlebars' " https://github.com/mustache/vim-mustache-handlebars
Plug 'mxw/vim-jsx', { 'for': 'javascript' } " https://github.com/mxw/vim-jsx
Plug 'myhere/vim-nodejs-complete', { 'for': 'javascript' } " https://github.com/myhere/vim-nodejs-complete
Plug 'nathanaelkane/vim-indent-guides' " https://github.com/nathanaelkane/vim-indent-guides
Plug 'nsf/gocode', { 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' } " https://github.com/pangloss/vim-javascript
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' } " https://github.com/plasticboy/vim-markdown
Plug 'purpleP/python-syntax', { 'for': 'python' } " https://github.com/purpleP/python-syntax
" Plug 'rizzatti/dash.vim' " https://github.com/rizzatti/dash.vim
Plug 'sbdchd/neoformat' " https://github.com/sbdchd/neoformat
Plug 'scrooloose/nerdtree' " https://github.com/scrooloose/nerdtree
Plug 'tpope/vim-rhubarb' " https://github.com/tpope/vim-rhubarb
Plug 'tpope/vim-characterize' " https://github.com/tpope/vim-characterize
Plug 'tpope/vim-commentary' " https://github.com/tpope/vim-commentary
" Plug 'tpope/vim-dotenv' " https://github.com/tpope/vim-dotenv
Plug 'tpope/vim-eunuch' " https://github.com/tpope/vim-eunuch
Plug 'tpope/vim-fugitive' " https://github.com/tpope/vim-fugitive
Plug 'tpope/vim-repeat' " https://github.com/tpope/vim-repeat
Plug 'tpope/vim-surround' " https://github.com/tpope/vim-surround
Plug 'tpope/vim-unimpaired' " https://github.com/tpope/vim-unimpaired
Plug 'tweekmonster/braceless.vim', { 'for': ['python', 'coffee', 'yaml'] } " https://github.com/tweekmonster/braceless.vim
Plug 'vim-scripts/SyntaxAttr.vim' " https://github.com/vim-scripts/SyntaxAttr.vim
Plug 'vim-scripts/swap-parameters' " https://github.com/vim-scripts/swap-parameters
Plug 'zchee/deoplete-jedi' " https://github.com/zchee/deoplete-jedi

" colorschemes
Plug 'NLKNguyen/papercolor-theme'

" This modifies other plugins, so has to come last
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

call plug#end()

filetype on
filetype plugin on
filetype indent on

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

set completeopt=menu,longest,preview
" set cursorline " didn't realize this makes vim slower
set fileencoding=utf-8 ff=unix " don't set encoding=utf-8... nvim sets it by default
" set exrc secure " enable per-directory .vimrc files
set grepprg=ag
set ignorecase smartcase
set iskeyword+=-
set listchars=space:⋅,tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨
set mouse=a
set nobackup dir=~/.tmp/nvim
set noerrorbells visualbell t_vb=
set nofixeol
set nohlsearch incsearch
set nowrap linebreak
set number relativenumber
set pastetoggle=<F8>
set ruler laststatus=2 " one of these ensures each window contains a status line
set scrolloff=3
set showbreak=↪\
set synmaxcol=200 " disable syntax highlight after 200 chars for performance
set termguicolors " probably don't need this since $NVIM_TUI_ENABLE_TRUE_COLOR is set
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
autocmd BufRead .zsh*       set filetype=sh

autocmd BufRead requirements.txt set filetype=text sw=2 ts=2
autocmd BufRead requirements/*.txt set filetype=text sw=2 ts=2

autocmd FileType apex       set ts=4 sw=4 foldmethod=indent commentstring=//\ %s
autocmd FileType cfg        set ts=4 sw=4 tw=0 foldmethod=indent commentstring=#\ %s
autocmd FileType css        set ts=2 sw=2 tw=0 foldmethod=indent
autocmd FileType ejs        set ts=4 sw=4 tw=0 foldmethod=indent
autocmd FileType htmldjango set ts=2 sw=2 foldmethod=indent
autocmd FileType javascript set ts=2 sw=2 tw=120 foldmethod=indent omnifunc=javascriptcomplete#CompleteJS
autocmd FileType javascript.jsx set ts=2 sw=2 tw=120 foldmethod=indent omnifunc=javascriptcomplete#CompleteJS
autocmd FileType json       set foldmethod=syntax
autocmd FileType mkd        set tw=79 ts=2 sw=2
autocmd FileType markdown   set tw=79 ts=2 sw=2
autocmd FileType python     set ts=4 sw=4 foldmethod=indent omnifunc=pythoncomplete#Complete
autocmd FileType sass       set ts=4 sw=4 foldmethod=indent sw=4
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
autocmd BufEnter * let &titlestring = expand("%:t") . ' ∈ ' . FileDir()

" ------------------
" Theme
" ------------------
set background=dark

" these have to be in this order to work, maybe?
let g:PaperColor_Theme = 'default'
source ~/.config/nvim/pcthemes/kyl.vim
colorscheme PaperColor
hi FunctionParameters guifg=#AAC4FF

" disable the annoying HTML link underlining
hi link htmlLink NONE
hi link htmlItalic NONE

" tweak colors
" ...this is a dumb way to do this
" ...i should create my own color scheme
hi htmlH1 ctermfg=225
hi htmlH2 ctermfg=218
hi htmlH3 ctermfg=182
hi htmlH4 ctermfg=139
hi htmlH5 ctermfg=96
hi htmlH6 ctermfg=239
hi mkdCode ctermfg=109
hi mkdLink ctermfg=105
hi mkdURL ctermfg=60
hi IndentGuidesOdd guibg=#233046
hi IndentGuidesEven guibg=#2F3648
hi SignColumn guibg=none ctermbg=none


" -------------
" Mappings
" -------------

:let mapleader='\'

nnoremap ,n :source ~/.config/nvim/init.vim<CR>

inoremap jk <Esc>
inoremap kk <Esc>
inoremap <TAB><TAB> <C-p>
inoremap <C-o> <C-x><C-o>

tnoremap jk <C-\><C-n>

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

" <opt> p o
nnoremap π :tabnext<CR>
nnoremap ø :tabprevious<CR>

" popup window - use Ctrl+j/k instead of Ctrl+n/p
" inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
" inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

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
nnoremap ,tv :vsp term://zsh -f<CR>i
nnoremap ,tx :sp term://zsh -f<CR>i

" folding
nnoremap <Leader>s :SignifyFold<CR>

" background toggle
map <Leader>bg :let &background = ( &background == "dark"? "light" : "dark" )<CR>



" ---------------------
" Plugin configuration
" ---------------------

" vim-go
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1

" vim-easymotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
"let g:EasyMotion_smartcase = 1
nmap ,z <Plug>(easymotion-overwin-f2)
map ,j <Plug>(easymotion-j)
map ,k <Plug>(easymotion-k)

" neoformat
let g:neoformat_enabled_json = []
let g:neoformat_run_all_formatters = 1
" augroup fmt
"     autocmd!
"     autocmd BufWritePre * undojoin | Neoformat
" augroup END

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
      \   'time': 'LightlineTime',
      \   'devicon': 'LightlineDevicon',
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
      \ 'tab_component_function': {
      \   'devicon': 'LightlineDevicon',
      \   'modified': 'lightline#tab#modified',
      \   'readonly': 'lightline#tab#readonly',
      \   'tabnum': 'lightline#tab#tabnum'
      \ },
      \ 'tab': {
      \   'active': [ 'tabnum', 'devicon', 'filename', 'modified' ],
      \   'inactive': [ 'tabnum', 'devicon', 'filename', 'modified' ],
      \ },
      \ }

" python
let g:python_highlight_all = 1
let g:pyflakes_use_quickfix = 0

" CtrlP
map ,f :CtrlP<CR>
map ,m :CtrlPMRU<CR>
map ,g :CtrlPBuffer<CR>
map ,r :CtrlPClearCache<CR>
map ,w :CtrlP<CR><C-\>w
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_dotfiles = 0
let g:ctrlp_map = '<C-q>'
let g:ctrlp_switch_buffer = 'Et'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|coverage'
let g:ctrlp_root_markers = ['.ctrlp']
let g:ctrlp_dont_split = 'NERD'
let g:ctrlp_prompt_mappings = {
    \ 'PrtSelectMove("j")':   ['<c-n>', '<down>'],
    \ 'PrtSelectMove("k")':   ['<c-p>', '<up>'],
    \ 'PrtHistory(-1)':       ['<c-j>'],
    \ 'PrtHistory(1)':        ['<c-k>'],
    \ }

" FZF
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_command_prefix = 'Fzf'

" deoplete
let g:deoplete#enable_at_startup = 1

" indent-guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']

" NERDtree
map ,d :NERDTreeToggle<CR>
map ,e :NERDTreeFind<CR>
let NERDTreeIgnore = ['\.pyc$']
let NERDTreeWinSize = 45
let NERDTreeShowHidden = 1

" Since the following commit, devicons are indented too much in NerdTree
" https://github.com/ryanoasis/vim-devicons/commit/40040ba86e29595cd8c42c1142313793b25d16d9
" ... fix by overriding padding before glyph
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ''

" vim-nerdtree-syntax-highlight
let s:brown = '905532'
let s:aqua =  '3AFFDB'
let s:blue = '689FB6'
let s:darkBlue = '44788E'
let s:purple = '834F79'
let s:lightPurple = '834F79'
let s:red = 'AE403F'
let s:beige = 'F5C06F'
let s:yellow = 'F09F17'
let s:orange = 'D4843E'
let s:darkOrange = 'F16529'
let s:pink = 'CB6F6F'
let s:salmon = 'EE6E73'
let s:green = '8FAA54'
let s:lightGreen = '31B53E'
let s:white = 'FFFFFF'
let s:rspec_red = 'FE405F'
let s:git_orange = 'F54D27'
let g:NERDTreeExtensionHighlightColor = {}
let g:NERDTreeExtensionHighlightColor['py'] = s:green
let g:NERDTreeExtensionHighlightColor['md'] = s:purple
let g:NERDTreeExtensionHighlightColor['yml'] = s:pink
let g:NERDTreeExtensionHighlightColor['ini'] = s:pink

" neomake
autocmd BufWritePost * Neomake
autocmd! QuitPre * let g:neomake_verbose = 0
let g:neomake_go_enabled_makers = ['golint']
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_python_flake8_maker = { 'args': ['--ignore=E501,E731'] }
let g:neomake_python_enabled_makers = ['flake8']

" vim-json
let g:vim_json_syntax_conceal = 0

" goyo/limelight
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
let g:limelight_conceal_guifg = 'DarkGray'
let g:limelight_conceal_guifg = '#777777'
" let g:limelight_default_coefficient = 0.7
function! s:goyo_enter()
    " Remove artifacts for NeoVim on true colors transparent background.
    " guifg is the terminal's background color.
    " hi! VertSplit gui=NONE guifg=#1b202a guibg=NONE
    " hi! StatusLine gui=NONE guifg=#1b202a guibg=NONE
    " hi! StatusLineNC gui=NONE guifg=#1b202a guibg=NONE
    hi! NonText gui=NONE guifg=#1b202a guibg=NONE
endfunction

" -----------
" Functions
" -----------

function! FileDir()
    let filedir = substitute(expand("%:p:h"), '/Users/kyl/', '', 'g')
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

function! LightlineDevicon(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let fname = expand('#'.buflist[winnr - 1].':t')
  return WebDevIconsGetFileTypeSymbol(fname)
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
