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

" Signify fold
nnoremap <Leader>s :SignifyFold<CR>

" Window swap
nnoremap <C-w>m :call WindowSwapping()<CR>

" NERDTree
map ,d :NERDTreeToggle<CR>
map ,e :NERDTreeFind<CR>

" Fuzzy finder (fzf.vim, with command_prefix='Fzf')
map ,f :FzfFiles<CR>
map ,m :FzfHistory<CR>

" Copilot
imap <silent><script><expr> <C-n> copilot#Accept("\<CR>")

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

" ---------------------
" CoC mappings
" ---------------------

" Tab completion
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()

" Diagnostics navigation
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Show documentation
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
nmap ,n  <Plug>(coc-format)

" Code actions
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>ac  <Plug>(coc-codeaction)
nmap <leader>qf  <Plug>(coc-fix-current)
nmap <leader>cl  <Plug>(coc-codelens-action)

" Text objects for functions and classes
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Scroll float windows/popups
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Selection ranges
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" CoC commands
command! -nargs=0 Format :call CocActionAsync('format')
command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

" CoCList mappings
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<CR>
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<CR>
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<CR>
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<CR>
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<CR>
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
