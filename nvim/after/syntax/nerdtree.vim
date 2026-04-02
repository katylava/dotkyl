" Apply devicons bracket concealment (devicons' FileType autocmd misses
" because nerdtree loads before devicons registers it)
syntax match hideBracketsInNerdTree "\]" contained conceal containedin=NERDTreeFlags
syntax match hideBracketsInNerdTree "\[" contained conceal containedin=NERDTreeFlags
syntax match hideBracketsInNerdTree "\]" contained conceal containedin=NERDTreeLinkFile
syntax match hideBracketsInNerdTree "\]" contained conceal containedin=NERDTreeLinkDir
syntax match hideBracketsInNerdTree "\[" contained conceal containedin=NERDTreeLinkFile
syntax match hideBracketsInNerdTree "\[" contained conceal containedin=NERDTreeLinkDir
setlocal conceallevel=3
setlocal concealcursor=nvic
