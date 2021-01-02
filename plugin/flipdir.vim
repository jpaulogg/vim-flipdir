" flipdir.vim - Vim Split Explorer

" Autor:       João Paulo G. Garcia
" Licença:     público (public domain)
" Editado em:  02 de janeiro de 2021
" Requer:      unix-like OS
" 
" Permite listar diretórios e seus conteúdos, além de abrir arquivos listados.
" <https://github.com/jpaulogg/flipdir.git>

if exists('g:loaded_flipdir')
	finish
endif
let g:loaded_flipdir = 1

" functions {{{1
" open file tree
function! s:Flip(...)
    let l:cmd = get(a:, 1, 'edit')
    let l:dir = get(a:, 2, expand('%:p:h'))
    exec l:cmd.' '.l:dir
    let l:list = systemlist('ls '.shellescape(l:dir).' -a --group-directories-first')
    for l in l:list
        if isdirectory(l:dir.'/'.l)
            let l .= '/'
        endif
        put = l
    endfor
    0delete
    keeppatterns g/^\.\+\//d
    setlocal nobuflisted bufhidden=wipe buftype=nofile
    set filetype=flipdir
endfunction

" enter path (file/directory)
function! s:Enter(cmd) range
    for l in getline(a:firstline, a:lastline)
	let l:path = expand('%:p').fnameescape(l)
	exec a:cmd.' '.l:path
	if l:path =~ "/$"
	    call <SID>Flip("edit", expand('%:p'))
	    return
	endif
    endfor
endfunction

" return up-directory path
function! s:GetUpdir()
    if isdirectory(expand('%'))
	return expand('%:p:h:h')
    else
	return expand('%:p:h')
    endif
endfunction

" mappings {{{1
"
" Plug mapping
" directory browse
nmap <silent> <Plug>(flipdir_WorkDir)  :call <SID>Flip('edit', getcwd())<CR>
nmap <silent> <Plug>(flipdir_UpDir)    :call <SID>Flip('edit', <SID>GetUpdir())<CR>
nmap <silent> <Plug>(flipdir_SplitUp)  :call <SID>Flip('split' )<CR>
nmap <silent> <Plug>(flipdir_VsplitUp) :call <SID>Flip('vsplit')<CR>
nmap <silent> <Plug>(flipdir_Reload)   :call <SID>Flip('edit', expand('%'))<CR>

" file opening
map <silent> <Plug>(flipdir_Enter)   :call <SID>Enter('edit')<CR>
map <silent> <Plug>(flipdir_SEnter)  :call <SID>Enter('topleft split' )<CR>
map <silent> <Plug>(flipdir_VEnter)  :call <SID>Enter('topleft vsplit')<CR>
map <silent> <Plug>(flipdir_Preview) :call <SID>Enter('topleft vert pedit')<CR><C-w>=

" hide dotfiles
nnoremap <silent> <Plug>(flipdir_HideDot)  :keeppatterns g/^\./d<CR>

" Global mapping
" other mappings in ftplugin/ directory
nmap - <Plug>(flipdir_UpDir)
nmap <C-e>w <Plug>(flipdir_WorkDir)
nmap <C-e>s <Plug>(flipdir_SplitUp)
nmap <C-e>v <Plug>(flipdir_VsplitUp)

" command {{{1
if get(g:, 'loaded_netrwPlugin', 0)
command! -nargs=? -complete=dir Flipdir call <SID>Flip('edit', <f-args>)
    augroup flipdir
	au!
	autocmd VimEnter * if isdirectory(expand('<afile>')) |
	    \Flipdir %:p:h
    augroup END
endif
" }}}

" vim: set fdm=marker :
