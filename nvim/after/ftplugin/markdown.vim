silent! nunmap <buffer> gx

setlocal foldmethod=expr
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
