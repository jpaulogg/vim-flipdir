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

if get(g:, 'loaded_netrwPlugin', 0)
	augroup flipdir
		" you can add BufEnter autocmd here so ':edit directory' will open a flipdir buffer, etc.
		autocmd VimEnter * if isdirectory(bufname('%')) | 
		            \ exec 'file! %:p' |
		            \ call s:SetBuffer(bufname('%'))
	augroup END
endif

function s:Flipdir(cmd,...)              " {{{1
	if exists('a:1')
		let target = fnamemodify(a:1, ':p')
		if !empty(s:dir_buffers)
			silent exec 'bwipe '.join(s:dir_buffers)
		endif
	else
		let bname  = expand('%:p')
		let dirmod = isdirectory(bname) ? ':h' : ''
		let target = fnamemodify(bname, dirmod.':h').'/'
		let tail_pat = fnamemodify(bname, dirmod.':t')
	endif

	silent exec a:cmd.' '.target
	call s:SetBuffer(target)
	silent! let b:last_acess = searchpos('^'.tail_pat.'/\?$', 'c')
endfunction

let s:dir_buffers = []

function s:Fliplines(cmd) range          " {{{1
	let curdir = bufname('%')

	for line in getline(a:firstline, a:lastline)
		let target = curdir . fnameescape(line)
		exec a:cmd.' '.target

		if target =~# "/$"
			call s:SetBuffer(target)
			silent! call cursor(b:last_acess)
		elseif !empty(s:dir_buffers)
			silent exec 'bwipe '.join(s:dir_buffers)
		endif

	endfor
endfunction

function s:SetBuffer(target)             " {{{1
	" if you prefer, try using globpath(a:target, '*', 0, 1) instead of systemlist('ls')
	" and than fnamemodify(val, ':h:t').'/' : fnamemodify(val, ':t'), plus other changes
	let unix_ls = systemlist('ls '.a:target.' -A --group-directories-first')
	call map(unix_ls, {idx, val -> isdirectory(a:target.val) ? val.'/' : val})

	let bufnr = bufnr(a:target)
	call setbufvar(bufnr, '&ft', 'flipdir')         " file type settings in ftplugin/flipdir.vim
	call setbufline(bufnr, 1, unix_ls)
	call add(s:dir_buffers, bufnr)
endfunction
