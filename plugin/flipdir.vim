" flipdir.vim - flip/split directory browser <https://github.com/jpaulogg/flipdir.git>

" Author:  João Paulo G. Garcia
" Licence: public domain
" Last Change: 2020-01-04
" Requeriment: posix shell

" Flip or split current window to new buffer with the  output  of  'ls'  (unix
" utility). Each line in the new buffer is the 'tail' of a path, which is used
" to flip/split files and browse directories. Buffer's name is  the  directory
" full path and can be used in command-line expansions (see `:h :c_%`).

if exists('g:loaded_flipdir')
	finish
endif
let g:loaded_flipdir = 1

" flip/split directory {{{1
function s:Flipdir(cmd,...)    " a:1 is an optional argument with a directory path
	let l:path = get(a:, 1, s:Parent())
	exec a:cmd.' '.l:path.'/'
	let l:ls_output = systemlist('ls '.shellescape(l:path).' -A --group-directories-first')
	for l in l:ls_output
		if isdirectory(l:path.'/'.l)
			let l .= '/'
		endif
		put = l
	endfor
	0delete
	setl ft=flipdir            " file type settings in ftplugin/flipdir.vim
	if exists('s:lastpath')
		call search('^'.s:lastpath.'$', 'c')
	endif
endfunction

" flip/split current or visually selected line paths (file/directory) {{{1
function s:Fliplines(cmd) range
	let l:cd = expand('%')
	for l in getline(a:firstline, a:lastline)
		exec a:cmd.' '.l:cd.fnameescape(l)
		if l =~ "/$"
			call s:Flipdir("edit", expand('%:p:h'))
			return
		endif
	endfor
endfunction

" return parent directory path {{{1
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
command -nargs=? -complete=dir Flipdir   call s:Flipdir('edit', <f-args>)
command -nargs=? -complete=dir Splitdir  call s:Flipdir(<q-mods>.' split', <f-args>)

if get(g:, 'loaded_netrwPlugin', 0)
	augroup flipdir
		au!
		autocmd VimEnter * if &ft == '' &&
			\isdirectory(expand('<afile>')) |
			\Flipdir %:p
	augroup END
endif
" }}}
" mappings {{{1

" Plugs
map  <silent> <Plug>(flip_linepath)    :call <SID>Fliplines('edit')<CR>
map  <silent> <Plug>(split_linepath)   :call <SID>Fliplines('topleft split')<CR>
map  <silent> <Plug>(vsplit_linepath)  :call <SID>Fliplines('topleft vsplit')<CR>
map  <silent> <Plug>(tabedit_linepath) :call <SID>Fliplines('tabedit')<CR>
map  <silent> <Plug>(preview_linepath) :call <SID>Fliplines('botright vert pedit')<CR><C-w>=
map  <silent> <Plug>(argadd_linepath)  :call <SID>Fliplines('argadd')<CR>

" global key mapping
" the local mappings to flipdir buffers are in the ftplugin/flipdir.vim file
nmap <unique><silent> - :Flipdir<CR>

" }}}
" vim: set noet fdm=marker :
