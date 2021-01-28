" flipdir buffer local mappings
if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

" settings
setlocal nospell noswf nobl bh=wipe bt=nofile

" mappings
nmap <buffer>  h   <Cmd>Flipdir<CR>
nmap <buffer>  l   <Plug>(flip_linepath)
nmap <buffer> <CR> <Plug>(flip_linepath)

map <buffer> s <Plug>(split_linepath)
map <buffer> v <Plug>(vsplit_linepath)
map <buffer> t <Plug>(tabedit_linepath)
map <buffer> p <Plug>(preview_linepath)

map <buffer> x <Plug>(argadd_linepath)

" avoid pressing J after V
xmap <buffer> J j

" hide dot prefixed lines. 'u' to show dot files again.
nmap <silent><buffer><nowait> gh <Cmd>call <SID>HideDot()<CR>

function s:HideDot()
	call search("^[^.]", "c")
	keeppatterns g/^\./d_
	call cursor(line("''"), 1)
endfunction

" delete flipdir buffer
nmap <buffer><nowait><silent> gq <Cmd>bdelete!<CR>
