if exists("b:current_syntax")
	finish
endif

syn match MiniTreeDir ".*/$"
hi def link MiniTreeDir Directory

let b:current_syntax = "text"
