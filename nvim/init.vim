call plug#begin('~/.config/nvim/plugged')

Plug 'catppuccin/nvim', { 'as': 'catppuccin' } " colorscheme
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
Plug 'sheerun/vim-polyglot' " syntax highlighting for everything
Plug 'tpope/vim-characterize' " `ga` for unicode name, digraphs, emoji codes, and html entities
Plug 'tpope/vim-commentary' " `gcc` for comments
Plug 'tpope/vim-eunuch' " shell commands as vim commands (i only use :Rename)
Plug 'tpope/vim-fugitive' " :Git, :Gvdiffsplit, :GBrowse, etc
Plug 'tpope/vim-repeat' " makes `.` work better
Plug 'tpope/vim-rhubarb' " makes :GBrowse actually work
Plug 'tpope/vim-surround' " add/remove brackets, quotes, and tags
Plug 'vim-scripts/SyntaxAttr.vim' " get syntax group for highlighting

" These modify other plugins, so have to come last
Plug 'ryanoasis/vim-devicons' " icons for filetypes

call plug#end()

" ------------------
" Theme
" ------------------

lua << EOF
require("catppuccin").setup({
    flavour = "auto",
    background = { light = "latte", dark = "frappe" },
    transparent_background = false,
    dim_inactive = { enabled = false },
})
EOF
colorscheme catppuccin

function! ApplyDark()
    set background=dark
    hi lineNr guibg=#282828
    let g:indent_guides_odd_color='#233046'
    let g:indent_guides_even_color='#2F3648'
    execute 'hi IndentGuidesOdd guibg=' . g:indent_guides_odd_color
    execute 'hi IndentGuidesEven guibg=' . g:indent_guides_even_color
    if exists('g:lightline')
        runtime autoload/lightline/colorscheme/catppuccin.vim
        call lightline#init()
        call lightline#colorscheme()
        call lightline#update()
    endif
endfunction

function! ApplyLight()
    set background=light
    hi lineNr guibg=#C8C8A8 guifg=#282828
    let g:indent_guides_odd_color='#C3D0C6'
    let g:indent_guides_even_color='#CFD6C8'
    execute 'hi IndentGuidesOdd guibg=' . g:indent_guides_odd_color
    execute 'hi IndentGuidesEven guibg=' . g:indent_guides_even_color
    if exists('g:lightline')
        runtime autoload/lightline/colorscheme/catppuccin.vim
        call lightline#init()
        call lightline#colorscheme()
        call lightline#update()
    endif
endfunction

command! Dark call ApplyDark()
command! Light call ApplyLight()

if $TERM_PALETTE == "light"
    call ApplyLight()
else
    call ApplyDark()
endif


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
      \ 'colorscheme': 'catppuccin',
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
let NERDTreeIgnore = ['\.pyc$']
let NERDTreeWinSize = 45
let NERDTreeShowHidden = 1

" Since the following commit, devicons are indented too much in NerdTree
" https://github.com/ryanoasis/vim-devicons/commit/40040ba86e29595cd8c42c1142313793b25d16d9
" ... fix by overriding padding before glyph
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ''

" copilot
let g:copilot_no_tab_map = v:true

" -----------
" Functions
" -----------

function! FileDir()
    let filedir = substitute(expand("%:p:h"), '/Users/kyl/', '', 'g')
    let filedir = substitute(l:filedir, 'Library/Mobile Documents/com\~apple\~CloudDocs', 'icloud', 'g')
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
