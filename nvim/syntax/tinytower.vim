if exists("b:current_syntax")
  finish
endif

syn match ttSep '|' 

syn match ttCrNoDream '| n |' containedin=ttCr
syn match ttSvNoDream '| n |' containedin=ttSv
syn match ttRtNoDream '| n |' containedin=ttRt
syn match ttRcNoDream '| n |' containedin=ttRc
syn match ttFdNoDream '| n |' containedin=ttFd

syn match ttCrUnemployed '| Unemployed     |' containedin=ttCr
syn match ttSvUnemployed '| Unemployed     |' containedin=ttSv
syn match ttRtUnemployed '| Unemployed     |' containedin=ttRt
syn match ttRcUnemployed '| Unemployed     |' containedin=ttRc
syn match ttFdUnemployed '| Unemployed     |' containedin=ttFd

syn match ttCr '^.*| Cr\d |.*$' contains=ttSep,ttCrNoDream,ttCrUnemployed
syn match ttSv '^.*| Sv\d |.*$' contains=ttSep,ttSvNoDream,ttSvUnemployed
syn match ttRt '^.*| Rt\d |.*$' contains=ttSep,ttRtNoDream,ttRtUnemployed
syn match ttRc '^.*| Rc\d |.*$' contains=ttSep,ttRcNoDream,ttRcUnemployed
syn match ttFd '^.*| Fd\d |.*$' contains=ttSep,ttFdNoDream,ttFdUnemployed

syn match ttHeader '^| Name.*D |$' contains=ttSep
syn match vimModeline '^# vim:.*:$'

hi ttCr ctermfg=203
hi ttSv ctermfg=31
hi ttRt ctermfg=63
hi ttRc ctermfg=136
hi ttFd ctermfg=64

hi ttCrNoDream ctermfg=203 cterm=reverse
hi ttSvNoDream ctermfg=31  cterm=reverse
hi ttRtNoDream ctermfg=63  cterm=reverse
hi ttRcNoDream ctermfg=136 cterm=reverse
hi ttFdNoDream ctermfg=64  cterm=reverse

hi ttCrUnemployed ctermfg=203 cterm=reverse
hi ttSvUnemployed ctermfg=31  cterm=reverse
hi ttRtUnemployed ctermfg=63  cterm=reverse
hi ttRcUnemployed ctermfg=136 cterm=reverse
hi ttFdUnemployed ctermfg=64  cterm=reverse

hi ttSep ctermfg=16
hi ttHeader ctermfg=192 cterm=underline
hi vimModeline ctermfg=black

hi ColorColumn ctermbg=none
hi CursorLine ctermbg=white cterm=reverse

