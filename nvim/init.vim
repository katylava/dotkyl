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
" Theme (setup in lua/functions.lua, catppuccin setup below)
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

command! Dark lua ApplyDark()
command! Light lua ApplyLight()

if $TERM_PALETTE == "light"
    lua ApplyLight()
else
    lua ApplyDark()
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
      \   'lineinfo': ' %2v:%-3l',
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
