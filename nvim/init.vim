let g:python_host_prog='/Users/kyl/.pyenv/shims/python'

let g:python3_host_prog='/Users/kyl/.pyenv/shims/python'

call plug#begin('~/.config/nvim/plugged')

Plug 'chrisbra/csv.vim', { 'for': 'csv' } " CSV utilities
Plug 'editorconfig/editorconfig-vim' " supoport for .editorconfig files
Plug 'github/copilot.vim' " AI programmer
Plug 'godlygeek/tabular' " Align text :help tabular
Plug 'itchyny/lightline.vim' " cool status line, good performance
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-textobj-user' " create your own text objects
Plug 'kien/ctrlp.vim' " https://github.com/kien/ctrlp.vim
Plug 'kshenoy/vim-signature' " show marks in the sign column
Plug 'luochen1990/rainbow' " color-code matching brackets
Plug 'mhinz/vim-signify' " VCS signs
Plug 'nathanaelkane/vim-indent-guides' " color column by indent level
Plug 'neoclide/coc.nvim', {'branch': 'release'} " completion, LSP
Plug 'scrooloose/nerdtree' " shows current directory in a buffer
Plug 'sainnhe/everforest' " colorscheme
Plug 'sheerun/vim-polyglot' " syntax highlighting for everything
Plug 'tpope/vim-characterize' " `ga` for unicode name, digraphs, emoji codes, and html entities
Plug 'tpope/vim-commentary' " `gcc` for comments
Plug 'tpope/vim-eunuch' " shell commands as vim commands (i only use :Rename)
Plug 'tpope/vim-fugitive' " :Git, :Gvdiffsplit, :GBrowse, etc
Plug 'tpope/vim-repeat' " makes `.` work better
Plug 'tpope/vim-rhubarb' " makes :GBrowse actually work
Plug 'tpope/vim-surround' " add/remove brackets, quotes, and tags
" Plug 'tweekmonster/braceless.vim', { 'for': ['python', 'yaml'] } " better text objects, indentation, folds for indented languages
Plug 'vim-scripts/SyntaxAttr.vim' " get syntax group for highlighting

" These modify other plugins, so have to come last
Plug 'ryanoasis/vim-devicons' " icons for filetypes
Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " highlighting for nerdtree

call plug#end()

filetype on
filetype plugin on
filetype indent on

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

set cmdheight=2 " more space for displaying messages, recommended by coc
set completeopt=menu,longest,preview
" set cursorline " this makes vim slower
set cursorcolumn " highlight current column
set fileencoding=utf-8 ff=unix " don't set encoding=utf-8... nvim sets it by default
" set exrc secure " enable per-directory .vimrc files
set foldmethod=indent
set grepprg=ag
set ignorecase smartcase
set iskeyword+=-
set hidden " recommended by coc
set listchars=space:⋅,tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨
set mouse=a
set nobackup nowritebackup dir=~/.tmp/nvim
set noerrorbells visualbell t_vb=
set nofixeol
set nohlsearch incsearch
set nowrap linebreak
set number
set pastetoggle=<F8>
set ruler laststatus=2 " one of these ensures each window contains a status line
set scrolloff=3
set shortmess+=c " recommended by coc
set showbreak=↪\
set signcolumn=yes " recommended by coc
" set synmaxcol=200 " disable syntax highlight after 200 chars for performance
set termguicolors " do i need this if $NVIM_TUI_ENABLE_TRUE_COLOR is set?
set title
set ts=4 sw=4 ai expandtab
set ttyfast
set tw=79 colorcolumn=80,100
set updatetime=300 " recommended by coc
set wildignore=.svn,.git,.env,*.bak,*.pyc,*.DS_Store,*.db,venv
set wildmenu wildmode=list:longest

autocmd BufRead *.gs        set filetype=javascript
autocmd BufRead *.md        set filetype=markdown
autocmd BufRead *.sql       set filetype=sql
autocmd BufRead *.txt       set filetype=markdown
autocmd BufRead .zsh*       set filetype=sh
autocmd BufRead .npmrc      set commentstring=#\ %s

autocmd BufRead requirements.txt set filetype=text sw=2 ts=2
autocmd BufRead requirements/*.txt set filetype=text sw=2 ts=2

autocmd FileType cfg        set ts=4 sw=4 tw=0 commentstring=#\ %s
autocmd FileType css        set ts=2 sw=2 tw=0
autocmd FileType javascript set ts=2 sw=2 tw=120
autocmd FileType javascript.jsx set ts=2 sw=2 tw=120
autocmd FileType json       set ts=2 sw=2 foldmethod=syntax
autocmd FileType markdown   set tw=79 ts=2 sw=2 comments=n:>
autocmd FileType python     set ts=4 sw=4 commentstring=#\ %s foldmethod=indent
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
"
" DARK
set background=dark
let everforest_transparent_background=1
hi lineNr guibg=#282828
let g:indent_guides_odd_color='#233046'
let g:indent_guides_even_color='#2F3648'
"
" LIGHT
" set background=light " Still have to do this in command mode for some reason
" let g:everforest_transparent_background=0 " for light background
" hi lineNr guibg=#C8C8A8 guifg=#282828
" let g:indent_guides_odd_color='#C3D0C6'
" let g:indent_guides_even_color='#CFD6C8'

let g:everforest_background='hard'
let g:everforest_enable_italic=1
colorscheme everforest
hi Normal guibg=NONE ctermbg=NONE

" disable the annoying HTML link underlining
hi link htmlLink NONE
hi link htmlItalic NONE

hi SignColumn guibg=NONE ctermbg=NONE


" -------------
" Mappings
" -------------

:let mapleader='\'

inoremap jk <Esc>
inoremap kk <Esc>

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

" select just-pasted lines
nnoremap gp `[v`]

" insert space or newline and get back to normal mode
nnoremap <silent> gj o<Esc>
nnoremap <silent> gk O<Esc>
nnoremap <silent> gh i<Space><Esc>
nnoremap <silent> gl a<Space><Esc>
nnoremap <silent> gn i<Cr><Esc>

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

" ---------------------
" CoC configuration
" ---------------------

" Use tab for trigger completion with suggested characters ahead. Also use tab
" for navigating suggestions.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! s:CheckBackSpace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Formatting whole file
nmap ,n  <Plug>(coc-format)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


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
      \ 'colorscheme': 'everforest',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch' ],
      \             ['filedir', 'filename' ] ],
      \   'right': [ [ 'percent', 'lineinfo' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ],
      \              [ 'time'] ],
      \ },
      \ 'inactive': {
      \   'left': [ [ 'mode' ],
      \             ['filedir', 'filename' ] ],
      \   'right': [ [ 'percent', 'lineinfo' ]]
      \ },
      \ 'component': {
      \   'lineinfo': ' %2v:%-3l',
      \ },
      \ 'component_function': {
      \   'gitbranch': 'LightlineFugitive',
      \   'readonly': 'LightlineReadonly',
      \   'modified': 'LightlineModified',
      \   'filedir': 'FileDir',
      \   'filename': 'LightlineFilename',
      \   'time': 'LightlineTime',
      \   'devicon': 'LightlineDevicon',
      \   'fileformat': 'LightlineFileformat',
      \   'fileencoding': 'LightlineFileencoding',
      \   'filetype': 'LightlineFiletype',
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
execute 'hi IndentGuidesOdd guibg=' . g:indent_guides_odd_color
execute 'hi IndentGuidesEven guibg=' . g:indent_guides_even_color

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

" do <C-w>m in one split, then in another split and they will be swapped
nnoremap <C-w>m :call WindowSwapping()<CR>

" copilot
imap <silent><script><expr> <C-n> copilot#Accept("\<CR>")
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
  if exists("*FugitiveHead")
    let branch = FugitiveHead()
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

function! LightlineFileformat()
  return winwidth(0) > 120 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 120 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 120 ? &fileencoding : ''
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
