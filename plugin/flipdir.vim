" flipdir.vim - Flip/Split Directory Browser <https://github.com/jpaulogg/flipdir.git>

" Author:      João Paulo G. Garcia
" Licence:     public domain
" Last Change: 2020-01-04
" Requeriment: posix shell

" Flip or split current buffer into new buffer with 'ls' shell command output.
" Each line in the buffer is a 'tail' path, which is used to flip/split files.

if exists('g:loaded_flipdir')
	finish
endif
let g:loaded_flipdir = 1

" flip/split directory {{{1
function s:Flipdir(cmd,...)
	let l:dir = get(a:, 1, s:Updir())
	exec a:cmd.' '.l:dir.'/'
	let l:list = systemlist('ls '.shellescape(l:dir).' -A --group-directories-first')
	for l in l:list
		if isdirectory(l:dir.'/'.l)
			let l .= '/'
		endif
		put = l
	endfor
	0delete
	setlocal noswf nobl bh=wipe bt=nofile ft=flipdir
	if exists('s:lastpath')
		call search(s:lastpath, 'c')
	endif
endfunction

" flip/split current or visually selected line paths (file/directory) {{{1
function s:Fliplines(cmd) range
	let l:dir = expand('%:p')
	for l in getline(a:firstline, a:lastline)
		exec a:cmd.' '.l:dir.fnameescape(l)
		if l =~ "/$"
			call s:Flipdir("edit", expand('%:p:h'))
			return
		endif
	endfor
endfunction

" return up-directory path {{{1
function s:Updir()
	if isdirectory(expand('%'))
		let s:lastpath = '^'.expand('%:h:t').'/$'
		return expand('%:p:h:h')
	else
		let s:lastpath = '^'.expand('%:t').'$'
		return expand('%:p:h')
	endif
endfunction

" Plug mapping {{{1

nmap <silent> <Plug>(flip_workdir) :call <SID>Flipdir('edit', getcwd())<CR>
nmap <silent> <Plug>(flip_updir)   :call <SID>Flipdir('edit')<CR>
nmap <silent> <Plug>(split_updir)  :call <SID>Flipdir('split')<CR>
nmap <silent> <Plug>(vsplit_updir) :call <SID>Flipdir('vsplit')<CR>

map <silent> <Plug>(flip_linepath)    :call <SID>Fliplines('edit')<CR>
map <silent> <Plug>(split_linepath)   :call <SID>Fliplines('topleft split')<CR>
map <silent> <Plug>(vsplit_linepath)  :call <SID>Fliplines('topleft vsplit')<CR>
map <silent> <Plug>(preview_linepath) :call <SID>Fliplines('botright vert pedit')<CR><C-w>=
map <silent> <Plug>(arglist_linepath) :call <SID>Fliplines('argadd')<CR>

nmap <silent> <Plug>(flipdir_hidedot) :keeppatterns g/^\./d<CR>:silent! normal ''<CR>
nmap <silent> <Plug>(flipdir_reload)  :call <SID>Flipdir('edit')<CR>

" global key mapping {{{1
" local mappings to flipdir buffers in the 'ftplugin' directory
" 'let g:flipdir_defaults = 0' to disable default mappings

if get(g:, 'flipdir_mappings', 1)
	nmap - <Plug>(flip_updir)
	nmap <C-f>w <Plug>(flip_workdir)
	nmap <C-f>s <Plug>(split_updir)
	nmap <C-f>v <Plug>(vsplit_updir)
endif

" Flipdir command {{{1
command -nargs=? -complete=dir Flipdir call s:Flipdir('edit', <f-args>)

if get(g:, 'loaded_netrwPlugin', 0)
	augroup flipdir
		au!
		autocmd VimEnter * if &ft == '' &&
			\isdirectory(expand('<afile>')) |
			\Flipdir %:p
	augroup END
endif
" }}}

" vim: set noet fdm=marker :
