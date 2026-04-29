" Escape
inoremap jk <Esc>
inoremap kk <Esc>

" Window navigation
nnoremap <C-j> :wincmd j<CR>
nnoremap <C-k> :wincmd k<CR>
nnoremap <C-h> :wincmd h<CR>
nnoremap <C-l> :wincmd l<CR>

" Window resize (<opt> = - . ,)
nnoremap ≠ 10<C-W>+
nnoremap – 10<C-W>-
nnoremap ≥ 10<C-W>>
nnoremap ≤ 10<C-W><

" Window move (<opt> b f k j)
nnoremap ∫ <C-W>H
nnoremap ƒ <C-W>L
nnoremap ˚ <C-W>K
nnoremap ∆ <C-W>J

" Tabs (<opt> p o)
nnoremap π :tabnext<CR>
nnoremap ø :tabprevious<CR>

" Select just-pasted lines
nnoremap gp `[v`]

" Insert space or newline and get back to normal mode
nnoremap <silent> gj o<Esc>
nnoremap <silent> gk O<Esc>
nnoremap <silent> gh i<Space><Esc>
nnoremap <silent> gl a<Space><Esc>
nnoremap <silent> gn i<CR><Esc>

" Center search result
nnoremap N Nzz
nnoremap n nzz

" System clipboard
noremap ,y "+y
noremap ,p "+p

" Don't show help when F1 is pressed
map <F1> <ESC>

" Remove trailing space without overwriting current search
nnoremap <silent> ,s :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" Gitsigns fold (show only changed hunks)
nnoremap <Leader>s :GitsignsFold<CR>

" Window swap
nnoremap <C-w>m :call WindowSwapping()<CR>

" nvim-tree
map ,d :NvimTreeToggle<CR>
map ,e :NvimTreeFindFile<CR>

" Fuzzy finder (fzf.vim, with command_prefix='Fzf')
map ,f :FzfFiles<CR>
map ,m :FzfHistory<CR>

" Copilot (was <C-n>; remapped to free <C-n>/<C-p> for cmp menu nav)
imap <silent><script><expr> <C-j> copilot#Accept("\<CR>")

" Diffview
" all uncommitted changes (unstaged + staged in split view)
nnoremap <silent> <leader>dd :DiffviewOpen<CR>
" staged only (git diff --cached)
nnoremap <silent> <leader>ds :DiffviewOpen --cached<CR>
" diff vs branch/commit (tab-completes — type branch name then <CR>)
nnoremap <leader>db :DiffviewOpen<Space>
" last commit, like git show HEAD
nnoremap <silent> <leader>dc :DiffviewOpen HEAD^!<CR>
" close
nnoremap <silent> <leader>dq :DiffviewClose<CR>

" Command typos
command! Q  quit
command! W  write
command! Wq wq
command! Wn wn
command! WN wN
