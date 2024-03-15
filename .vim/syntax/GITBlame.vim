
if exists("b:current_syntax")
  finish
endif

syn match gitFileText       /.*$/
syn match gitCommitDetail   /.\{-}(.\{-})/                nextgroup=gitFileText
syn match gitCommitHash     /^\s*.[0-9A-Za-z]\+ /         nextgroup=gitCommitDetail
syn match gitUncommitted    /^0*.*(Not Committed Yet.*$/
syn match gitInitialCommit  /^\s*\^[0-9A-Za-z]\+/

hi def link gitFileText       Statement
hi def link gitCommitDetail   Type
hi def link gitCommitHash     String
hi def link gitUncommitted    Special
hi def link gitInitialCommit  PreProc

let b:current_syntax = "GITBlame"
