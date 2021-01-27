" vim: set noet fdm=marker:
" 'zR' opens and 'zM' closes' all folds

" flipdir.vim - flip/split directory browser <https://github.com/jpaulogg/flipdir.git>
" Flip or split current window to new buffer with directory and files listing

" Licence: public domain
" Last Change: 2020-01-26

" Each line in the new buffer is the 'tail'  of  a	path,  which  is  used	to
" flip/split files and browse directories. Buffer's name is the directory full
" path and can be used in command-line expansions (see `:h :c_%`).

" load once
if exists('g:loaded_flipdir')
	finish
endif
let g:loaded_flipdir = 1

" mappings {{{1
map  <silent> <Plug>(flip_linepath)    :call <SID>Fliplines('edit')<CR>
map  <silent> <Plug>(split_linepath)   :call <SID>Fliplines('topleft split')<CR>
map  <silent> <Plug>(vsplit_linepath)  :call <SID>Fliplines('topleft vsplit')<CR>
map  <silent> <Plug>(tabedit_linepath) :call <SID>Fliplines('tabedit')<CR>
map  <silent> <Plug>(preview_linepath) :call <SID>Fliplines('botright vert pedit')<CR><C-w>=
map  <silent> <Plug>(argadd_linepath)  :call <SID>Fliplines('argadd')<CR>

" global key mapping
" the local mappings to flipdir buffers are in the ftplugin/flipdir.vim file
nmap <unique><silent> - <Cmd>Flipdir<CR>

" commands {{{1
command -nargs=? -complete=dir Flipdir  call s:Flipdir('edit', <f-args>)
command -nargs=? -complete=dir Splitdir call s:Flipdir(<q-mods>.' split', <f-args>)

if get(g:, 'loaded_netrwPlugin', 0)
	augroup flipdir
		autocmd VimEnter * if isdirectory(expand('<afile>')) | Flipdir %:p/
	augroup END
endif

" flip/split directory {{{1
function s:Flipdir(cmd,...)              " a:1 is an optional argument with the directory path
	if exists('a:1')
		let target = a:1
	else
		let bname  = expand('%:p')
		let fmod   = isdirectory(bname) ? ':h:h' : ':h'
		let target = fnamemodify(bname, fmod).'/'
	endif
	if target !~ '/$'
		let target .= '/'
	endif
	exec 'noswapfile '.a:cmd.' '.target

	let unix_ls = systemlist('ls '.target.' -A --group-directories-first')
	call map(unix_ls, {list, item -> isdirectory(target.item) ? item.'/' : item})
	" if you prefer, try using globpath(target, '*', 0, 1) instead of systemlist('ls')
	" and than fnamemodify(item, ':h:t').'/' : fnamemodify(item, ':t'), plus other changes
	
	let bufnr = bufnr(target)
	call setbufline(bufnr, 1, unix_ls)
	call setbufvar(bufnr, '&ft', 'flipdir')               " file type settings in ftplugin/flipdir.vim

	if !exists('a:1')
		let fmod = isdirectory(bname) ? ':h:t' : ':t'
		let lastpath = fnamemodify(bname, fmod)
		call search('^'.lastpath.'/\?$', 'c')
	else
		call cursor(line('.'), col('.'))
	endif
endfunction

" flip/split current or visually selected line paths (file/directory) {{{1
function s:Fliplines(cmd) range
	let curdir = bufname('%')
	for line in getline(a:firstline, a:lastline)
		let target = fnameescape(curdir.line)
		if line =~ "/$"
			call s:Flipdir(a:cmd, target)
		else
			exec a:cmd.' '.target
		endif
	endfor
endfunction

