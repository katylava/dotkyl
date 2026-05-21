" Filetype detection
autocmd BufRead *.gs set filetype=javascript
autocmd BufRead *.md set filetype=markdown
autocmd BufRead *.sql set filetype=sql
autocmd BufRead *.txt set filetype=markdown
autocmd BufRead .zsh* set filetype=sh
autocmd BufRead .npmrc set commentstring=#\ %s

autocmd BufRead requirements.txt set filetype=text sw=2 ts=2
autocmd BufRead requirements/*.txt set filetype=text sw=2 ts=2
autocmd BufRead,BufNewFile CLAUDE_COMMIT_MSG set filetype=gitcommit

" Filetype-specific settings
autocmd FileType cfg setlocal tabstop=4 shiftwidth=4 textwidth=0 commentstring=#\ %s
autocmd FileType css setlocal tabstop=2 shiftwidth=2 textwidth=0
autocmd FileType javascript,javascript.jsx setlocal tabstop=2 shiftwidth=2 textwidth=120
autocmd FileType json setlocal tabstop=2 shiftwidth=2 foldmethod=syntax filetype=json5
autocmd FileType markdown setlocal textwidth=79 tabstop=2 shiftwidth=2 comments=n:> wrap
autocmd FileType python setlocal tabstop=4 shiftwidth=4 commentstring=#\ %s foldmethod=indent
autocmd FileType sql setlocal commentstring=--\ %s
autocmd FileType toml setlocal tw=0
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2


" Crontab: edit in place
autocmd FileType crontab setlocal nobackup nowritebackup

" Tabs in python are bad
autocmd FileType python highlight Tabs ctermbg=red guibg=red | match Tabs /^\t+/

" Automatically chmod +x shell scripts
autocmd BufWritePost *.sh silent !chmod +x %

" Open file at last edited location
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif

" Title string (FileDir defined in functions.lua)
autocmd BufEnter * let &titlestring = expand('%:t') . ' ∈ ' . v:lua.FileDir()

" Remove html link/italic overrides from colorscheme
autocmd ColorScheme * hi link htmlLink NONE | hi link htmlItalic NONE

" Trailing whitespace highlighting
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
