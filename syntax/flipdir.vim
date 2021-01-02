if exists("b:current_syntax")
  finish
endif

syn match MiniTreeDir ".*/$"
hi def link MiniTreeDir netrwDir

let b:current_syntax = "text"
