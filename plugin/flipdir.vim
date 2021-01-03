" flipdir.vim - Flip/Split Directory Browser <https://github.com/jpaulogg/flipdir.git>

" Autor:       João Paulo G. Garcia
" Licença:     público (public domain)
" Editado em:  02 de janeiro de 2021
" Requer:      posix shell
" 
" Vira janelas de arquivo em buffers do explorador, permitindo visualizar e
" interagir com a saída do comando 'ls -a --group-directories-first' (unix).

if exists('g:loaded_flipdir')
	finish
endif
let g:loaded_flipdir = 1

" function - flip/split directory {{{1
function s:Flip(cmd,...)
	let l:dir = get(a:, 1, expand('%:p:h'))
	exec a:cmd.' '.l:dir.'/'
	let l:list = systemlist('ls '.shellescape(l:dir).' -A --group-directories-first')
	for l in l:list
		if isdirectory(l:dir.'/'.l)
			let l .= '/'
		endif
		put = l
	endfor
	0delete
	setl nobl bh=wipe bt=nofile ft=flipdir
	if exists('s:lastpath')
		call search(s:lastpath, 'c')
	endif
endfunction

" function - flip/split line(s) path(s) (file/directory) {{{1
function s:Enter(cmd) range
	let l:dir = expand('%:p')
	for l in getline(a:firstline, a:lastline)
		exec a:cmd.' '.l:dir . fnameescape(l)
		if l =~ "/$"
			call <SID>Flip("edit")
			return
		endif
	endfor
endfunction

" function - return up-directory path {{{1
function s:GetUpdir()
	if isdirectory(expand('%'))
		let s:lastpath = '^'.expand('%:h:t').'/$'
		return expand('%:p:h:h')
	else
		let s:lastpath = '^'.expand('%:t').'$'
		return expand('%:p:h')
	endif
endfunction

" Plug mapping {{{1

nmap <silent> <Plug>(flip_workdir) :call <SID>Flip('edit', getcwd())<CR>
nmap <silent> <Plug>(flip_updir)   :call <SID>Flip('edit', <SID>GetUpdir())<CR>
nmap <silent> <Plug>(split_updir)  :call <SID>Flip('split')<CR>
nmap <silent> <Plug>(vsplit_updir) :call <SID>flip('vsplit')<CR>

map <silent> <Plug>(flip_linepaths)   :call <SID>Enter('edit')<CR>
map <silent> <Plug>(split_linepaths)  :call <SID>Enter('topleft split')<CR>
map <silent> <Plug>(vsplit_linepaths) :call <SID>Enter('topleft vsplit')<CR>
map <silent> <Plug>(preview_linepath) :call <SID>Enter('botright vert pedit')<CR><C-w>=

nmap <silent> <Plug>(flipdir_hidedot) :keeppatterns g/^\./d<CR>gg
nmap <silent> <Plug>(flipdir_reload)  :call <SID>Flip('edit')<CR>

" global key mapping {{{1
" local mappings to flipdir buffers in the 'ftplugin' directory

" flip directory
nmap - <Plug>(flip_updir)

" flip work directory
nmap <C-f>w <Plug>(flip_workdir)

" split directory
nmap <C-f>s <Plug>(split_updir)
nmap <C-f>v <Plug>(vsplit_updir)

" command {{{1
command -nargs=? -complete=dir Flipdir call <SID>Flip('edit', <f-args>)

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
