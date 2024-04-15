"
" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

runtime! syntax/json.vim

syn match jsonComment  /\/\/.*$/

syn region jsonMultilineComment start="/\*" end="\*/"

" syn region jsonMultilineComment start="/\*" end="\*/" contains=jsonMultilineComment,jsonMultilineCommentError
" syn match jsonMultilineCommentError "\S" contained

" the default highlighting

hi! link jsonComment                Comment
hi! link jsonMultilineComment       Comment

let b:current_syntax="json"

