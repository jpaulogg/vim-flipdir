" minitree.vim - Vim Minimal File Tree

" Autor:       João Paulo G. Garcia
" Licença:     público (public domain)
" Editado em:  02 de janeiro de 2021
" Requer:      unix-like OS
" 
" Permite listar diretórios e seus conteúdos, além de abrir arquivos listados.
" <https://github.com/jpaulogg/minitree-vim.git>

if exists('g:loaded_minitree')
	finish
endif
let g:loaded_minitree = 1

" functions {{{1
" open file tree
function! s:Explore(...)
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
    set filetype=minitree
endfunction

" enter path (file/directory)
function! s:Enter(cmd) range
    for l in getline(a:firstline, a:lastline)
	let l:path = expand('%:p').fnameescape(l)
	exec a:cmd.' '.l:path
	if l:path =~ "/$"
	    call <SID>Explore("edit", expand('%:p'))
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
nmap <silent> <Plug>(MiniTree_WorkDir)  :call <SID>Explore('edit', getcwd())<CR>
nmap <silent> <Plug>(MiniTree_UpDir)    :call <SID>Explore('edit', <SID>GetUpdir())<CR>
nmap <silent> <Plug>(MiniTree_SplitUp)  :call <SID>Explore('split' )<CR>
nmap <silent> <Plug>(MiniTree_VsplitUp) :call <SID>Explore('vsplit')<CR>
nmap <silent> <Plug>(MiniTree_Reload)   :call <SID>Explore('edit', expand('%'))<CR>

" file opening
map <silent> <Plug>(MiniTree_Enter)   :call <SID>Enter('edit')<CR>
map <silent> <Plug>(MiniTree_SEnter)  :call <SID>Enter('topleft split' )<CR>
map <silent> <Plug>(MiniTree_VEnter)  :call <SID>Enter('topleft vsplit')<CR>
map <silent> <Plug>(MiniTree_Preview) :call <SID>Enter('topleft vert pedit')<CR><C-w>=

" hide dotfiles
nnoremap <silent> <Plug>(MiniTree_HideDot)  :keeppatterns g/^\./d<CR>

" Global mapping
" other mappings in ftplugin/ directory
nmap - <Plug>(MiniTree_UpDir)
nmap <C-e>w <Plug>(MiniTree_WorkDir)
nmap <C-e>s <Plug>(MiniTree_SplitUp)
nmap <C-e>v <Plug>(MiniTree_VsplitUp)

" command {{{1
command! -nargs=? -complete=dir Mexplore call <SID>Explore('edit', <f-args>)

if get(g:, 'loaded_netrwPlugin', 0)
    augroup MiniTree
	au!
	autocmd VimEnter * if isdirectory(expand('<afile>')) |
	    \Mexplore %:p:h
    augroup END
endif
" }}}

" vim: set fdm=marker :
