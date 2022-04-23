let g:python_host_prog='/Users/kyl/.pyenv/shims/python'

let g:python3_host_prog='/Users/kyl/.pyenv/shims/python'

call plug#begin('~/.config/nvim/plugged')

Plug 'chrisbra/csv.vim', { 'for': 'csv' } " CSV utilities
Plug 'editorconfig/editorconfig-vim' " supoport for .editorconfig files
Plug 'github/copilot.vim' " AI programmer
Plug 'godlygeek/tabular' " Align text :help tabular
Plug 'itchyny/lightline.vim' " cool status line, good performance
Plug 'jacoborus/tender.vim' " color scheme for dark background
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-textobj-user' " create your own text objects
Plug 'kien/ctrlp.vim' " https://github.com/kien/ctrlp.vim
Plug 'kshenoy/vim-signature' " show marks in the sign column
Plug 'luochen1990/rainbow' " color-code matching brackets
Plug 'mhinz/vim-signify' " VCS signs
Plug 'nathanaelkane/vim-indent-guides' " color column by indent level
Plug 'scrooloose/nerdtree' " shows current directory in a buffer
Plug 'sheerun/vim-polyglot' " syntax highlighting for everything
Plug 'sonph/onehalf', {'rtp': 'vim'} " color scheme for light background
Plug 'tpope/vim-characterize' " `ga` for unicode name, digraphs, emoji codes, and html entities
Plug 'tpope/vim-commentary' " `gcc` for comments
Plug 'tpope/vim-eunuch' " shell commands as vim commands (i only use :Rename)
Plug 'tpope/vim-fugitive' " :Git, :Gvdiffsplit, :GBrowse, etc
Plug 'tpope/vim-repeat' " makes `.` work better
Plug 'tpope/vim-surround' " add/remove brackets, quotes, and tags
Plug 'tweekmonster/braceless.vim', { 'for': ['python', 'yaml'] } " better text objects, indentation, folds for indented languages
Plug 'vim-scripts/SyntaxAttr.vim' " get syntax group for highlighting

" These modify other plugins, so have to come last
Plug 'ryanoasis/vim-devicons' " icons for filetypes
Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " highlighting for nerdtree

call plug#end()

filetype on
filetype plugin on
filetype indent on

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

set completeopt=menu,longest,preview
" set cursorline " this makes vim slower
set cursorcolumn " highlight current column
set fileencoding=utf-8 ff=unix " don't set encoding=utf-8... nvim sets it by default
" set exrc secure " enable per-directory .vimrc files
set foldmethod=indent
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
set number
set pastetoggle=<F8>
set ruler laststatus=2 " one of these ensures each window contains a status line
set scrolloff=3
set showbreak=↪\
" set synmaxcol=200 " disable syntax highlight after 200 chars for performance
set termguicolors " probably don't need this since $NVIM_TUI_ENABLE_TRUE_COLOR is set
set title
set ts=4 sw=4 ai expandtab
set ttyfast
set tw=79 colorcolumn=80,100
set wildignore=.svn,.git,.env,*.bak,*.pyc,*.DS_Store,*.db,venv
set wildmenu wildmode=list:longest

autocmd BufRead *.gs        set filetype=javascript
autocmd BufRead *.md        set filetype=markdown
autocmd BufRead *.sql       set filetype=sql
autocmd BufRead *.txt       set filetype=markdown
autocmd BufRead .zsh*       set filetype=sh

autocmd BufRead requirements.txt set filetype=text sw=2 ts=2
autocmd BufRead requirements/*.txt set filetype=text sw=2 ts=2

autocmd FileType cfg        set ts=4 sw=4 tw=0 commentstring=#\ %s
autocmd FileType css        set ts=2 sw=2 tw=0
autocmd FileType javascript set ts=2 sw=2 tw=120
autocmd FileType javascript.jsx set ts=2 sw=2 tw=120
autocmd FileType json       set foldmethod=syntax
autocmd FileType markdown   set tw=79 ts=2 sw=2 comments=n:>
autocmd FileType python     set ts=4 sw=4 commentstring=#\ %s
autocmd FileType sql        set commentstring=--\ %s
autocmd FileType yaml       set sw=2 ts=2

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

colorscheme tender
set background=light
hi Normal guibg=NONE ctermbg=NONE

" colorscheme onehalflight
" set background=light

" disable the annoying HTML link underlining
hi link htmlLink NONE
hi link htmlItalic NONE


" -------------
" Mappings
" -------------

:let mapleader='\'

inoremap jk <Esc>
inoremap kk <Esc>
inoremap <TAB><TAB> <C-p>
" inoremap <C-o> <C-x><C-o>

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

" rainbow
let g:rainbow_active = 1
let g:rainbow_conf = {
\	'separately': {
\		'nerdtree': 0,
\	}
\}

" vim-signify
let g:signify_vcs_list = [ 'git' ]

" lightline
let g:lightline = {
      \ 'colorscheme': 'tender',
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

" CtrlP
map ,f :CtrlP<CR>
map ,m :CtrlPMRU<CR>
map ,g :CtrlPBuffer<CR>
map ,r :CtrlPClearCache<CR>
map ,w :CtrlP<CR><C-\>w
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
" let g:ctrlp_dotfiles = 0
let g:ctrlp_show_hidden = 1
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

" indent-guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd guibg=#233046
hi IndentGuidesEven guibg=#2F3648

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
let g:NERDTreeExtensionHighlightColor = {}
let g:NERDTreeExtensionHighlightColor['py'] = '8FAA54'
let g:NERDTreeExtensionHighlightColor['md'] = '834F79'
let g:NERDTreeExtensionHighlightColor['yml'] = 'CB6F6F'
let g:NERDTreeExtensionHighlightColor['ini'] = 'CB6F6F'

" " vim-json
" let g:vim_json_syntax_conceal = 0

" do <C-w>m in one split, then in another split and they will be swapped
nnoremap <C-w>m :call WindowSwapping()<CR>

" copilot
imap <silent><script><expr> <C-p> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

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

function! ConflictsHighlight() abort
    syn region conflictStart start=/^<<<<<<< .*$/ end=/^\ze\(=======$\||||||||\)/
    syn region conflictMiddle start=/^||||||| .*$/ end=/^\ze=======$/
    syn region conflictEnd start=/^\(=======$\||||||| |\)/ end=/^>>>>>>> .*$/

    highlight conflictStart ctermbg=red ctermfg=black
    highlight conflictMiddle ctermbg=blue ctermfg=black
    highlight conflictEnd ctermbg=green cterm=bold ctermfg=black
endfunction

" swapping splits
" from https://stackoverflow.com/a/15508593/111362
let s:markedWinNum = -1
function! DoWindowSwap()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe s:markedWinNum . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf
endfunction
function! WindowSwapping()
    if s:markedWinNum == -1
        let s:markedWinNum = winnr()
    else
        call DoWindowSwap()
        let s:markedWinNum = -1
    endif
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
