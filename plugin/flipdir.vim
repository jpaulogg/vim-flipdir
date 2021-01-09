" flipdir.vim - flip/split directory browser <https://github.com/jpaulogg/flipdir.git>

" Author:  João Paulo G. Garcia
" Licence: public domain
" Last Change: 2020-01-04
" Requeriment: posix shell

" Flip or split current window to new buffer with the  output  of  'ls'  (unix
" utility). Each line in the new buffer is the 'tail' of a path, which is used
" to flip/split files and browse directories. Buffer's name is  the  directory
" full path and can be used in command-line expansions (see `:h :c_%`).

" load once
if exists('g:loaded_flipdir')
	finish
endif
let g:loaded_flipdir = 1

" flip/split directory {{{1
function s:Flipdir(cmd,...)              " a:1 is an optional argument with the directory path
	let l:path = get(a:, 1, s:Parent())  " default value is the parent directory
	exec a:cmd.' '.l:path.'/'
	let l:ls_output = systemlist('ls '.shellescape(l:path).' -A --group-directories-first')
	for l in l:ls_output
		if isdirectory(l:path.'/'.l)
			let l .= '/'
		endif
		put = l
	endfor
	0delete
	setl ft=flipdir                      " file type settings in ftplugin/flipdir.vim
	if exists('s:lastpath')
		call search('^'.s:lastpath.'$', 'c')
	endif
endfunction

" flip/split current or visually selected line paths (file/directory) {{{1
function s:Fliplines(cmd) range
	let l:cd = expand('%:p')
	if getline('.') =~ "/$"
		let l:path = l:cd.fnameescape(getline('.'))
		call s:Flipdir("edit", l:path)
		return
	endif
	for l in getline(a:firstline, a:lastline)
		let l:path = l:cd.fnameescape(l)
		exec a:cmd.' '.l:path
	endfor
endfunction

" return parent directory full path {{{1
function s:Parent()
	if isdirectory(expand('%'))
		let s:lastpath = expand('%:h:t').'/'
		return expand('%:p:h:h')
	else
		let s:lastpath = expand('%:t')
		return expand('%:p:h')
	endif
endfunction

" commands {{{1
command -nargs=? -complete=dir Flipdir  call s:Flipdir('edit', <f-args>)
command -nargs=? -complete=dir Splitdir call s:Flipdir(<q-mods>.' split', <f-args>)

if get(g:, 'loaded_netrwPlugin', 0)
	augroup flipdir
		autocmd VimEnter * if &ft == '' &&
			\isdirectory(expand('<afile>')) |
			\Flipdir %:p/
	augroup END
endif
" }}}
" mappings {{{1

" Plugs
map  <silent> <Plug>(flip_pathline)    :call <SID>Fliplines('edit')<CR>
map  <silent> <Plug>(split_pathline)   :call <SID>Fliplines('topleft split')<CR>
map  <silent> <Plug>(vsplit_pathline)  :call <SID>Fliplines('topleft vsplit')<CR>
map  <silent> <Plug>(tabedit_pathline) :call <SID>Fliplines('tabedit')<CR>
map  <silent> <Plug>(preview_pathline) :call <SID>Fliplines('botright vert pedit')<CR><C-w>=
map  <silent> <Plug>(argadd_pathline)  :call <SID>Fliplines('argadd')<CR>

" global key mapping
" the local mappings to flipdir buffers are in the ftplugin/flipdir.vim file
nmap <unique><silent> - :Flipdir<CR>

" }}}
" vim: set sw=0 noet fdm=marker :
