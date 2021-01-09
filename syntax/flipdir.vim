if exists("b:current_syntax")
	finish
endif

syn match flipDir ".*/$"
hi def link flipDir netrwDir

let b:current_syntax = "text"
