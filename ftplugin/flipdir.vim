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
nmap <buffer><silent> h <Cmd>Flipdir<CR>

" hide dot files and folders. Undo to show dot files again.
nmap <silent><buffer><nowait> gh <Cmd>call <SID>HideDot()<CR>

function s:HideDot()
	call search("^[^.]", "c")
	keeppatterns g/^\./d
	call cursor(line("''"), 1)
endfunction

" delete flipdir buffer
nmap <buffer><nowait><silent> gq <Cmd>bdelete!<CR>
