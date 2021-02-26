" vim: set noet fdm=marker:
" zR opens and zM closes all folds

" Plugin: flipdir.vim - flip/split directory browser <http//github.com/jpaulogg/flipdir.git>
" Licence: public domain
" Last Change: 2020-01-26

" Flip or split current window to new buffer with directory and files listing.

" load once
if exists('g:loaded_flipdir')
	finish
endif
let g:loaded_flipdir = 1

" mappings and commands {{{1
" the local mappings to flipdir buffers are in the ftplugin/flipdir.vim file
nmap <unique><silent> - <Cmd>Flipdir<CR>

map  <silent> <Plug>(flipdir_enter)   :call  <SID>Fliplines('edit')<CR>
map  <silent> <Plug>(flipdir_split)   :call  <SID>Fliplines('topleft split')<CR>
map  <silent> <Plug>(flipdir_vsplit)  :call  <SID>Fliplines('topleft vsplit')<CR>
map  <silent> <Plug>(flipdir_tabedit) :call  <SID>Fliplines('tabedit')<CR>
map  <silent> <Plug>(flipdir_argadd)  :call  <SID>Fliplines('argadd')<CR>
nmap <silent> <Plug>(flipdir_preview) <Cmd>call  <SID>Fliplines('botright vert pedit')<CR><C-w>=

" commands
" similar to netrw's Explore and Sexplore commands. You can even use these names
command! -nargs=? -complete=dir Flipdir  call s:Flipdir('edit', <f-args>)
command! -nargs=? -complete=dir Splitdir call s:Flipdir(<q-mods>.' split', <f-args>)

if exists('loaded_netrwPlugin')
	augroup flipdir
		" you can add BufEnter autocmd here so ':edit directory' will open a flipdir buffer, etc.
		autocmd VimEnter * if isdirectory(bufname('%')) | 
		            \ file %:p | call s:SetBuffer(bufname('%'))
	augroup END
endif

function s:Flipdir(cmd, ...)             " {{{1
	if a:0
		let target = fnamemodify(a:1, ':p')
	else
		let bname  = expand('%:p')
		let dirmod = isdirectory(bname) ? ':h' : ''
		let tail   = fnamemodify(bname, dirmod.':t')
		let target = fnamemodify(bname, dirmod.':h').'/'
	endif

	silent exec 'keepalt '.a:cmd.' '.target
	call s:SetBuffer(target)
	silent! let b:last_acess = searchpos('^'.tail.'/\?$', 'c')
endfunction

function s:Fliplines(cmd) range          " {{{1
	let curdir = bufname('%')

	for line in getline(a:firstline, a:lastline)
		let target = curdir . fnameescape(line)
		silent exec 'keepalt '.a:cmd.' '.target

		if target =~# "/$"
			call s:SetBuffer(target)
			silent! call cursor(b:last_acess)
		endif

	endfor

	if len(s:tmp_buffers) > 5
		silent! exec 'bwipe '.join(remove(s:tmp_buffers 0, 2))
	endif
endfunction

function s:SetBuffer(target)             " {{{1
	let bufnr = bufnr(a:target)
	if getbufvar(bufnr, '&filetype') == 'flipdir'
		call setbufvar(bufnr, '&buflisted', 0)
		return
	endif

	let unix_ls = systemlist('ls '.a:target.' -pA --group-directories-first')
	" if you prefer, try using globpath(a:target, '*', 0, 1) instead of systemlist('ls');
	" and than fnamemodify(val, ':h:t').'/' : fnamemodify(val, ':t');
	" call map(pathlist, {idx, val -> isdirectory(a:target.val) ? val.'/' : val}), etc.
	" you need to experiment these suggestions...

	call setbufvar(bufnr, '&filetype', 'flipdir')         " file type settings in ftplugin/flipdir.vim
	call setbufline(bufnr, 1, unix_ls)
	call add(s:tmp_buffers, bufnr)
endfunction

let s:tmp_buffers = []
