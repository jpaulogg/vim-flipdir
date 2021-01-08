" flipdir buffer local mappings
if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

" settings
setlocal nospell noswf nobl bh=wipe bt=nofile

" path lines (accept more than one line)
map <buffer> <CR> <Plug>(flip_pathline)
map <buffer>  l   <Plug>(flip_pathline)
map <buffer>  s   <Plug>(split_pathline)
map <buffer>  v   <Plug>(vsplit_pathline)
map <buffer>  t   <Plug>(tabedit_pathline)
map <buffer>  p   <Plug>(preview_pathline)
map <buffer>  a   <Plug>(argadd_pathline)

" parent directory
nmap <buffer><silent> h :Flipdir<CR>

" hide dot files and folders (undo to unhide)
" to undo all(almost) changes :u1 (shortcut for :undo 1)
nmap <buffer><nowait> gh :keeppatterns g/^\./d<CR>:silent! normal ''<CR>

" delete flipdir buffer
nmap <buffer><nowait><silent> gq :bdelete!<CR>
