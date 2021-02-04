" flipdir buffer local mappings
if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

" settings
setlocal nospell noswf nobl bh=wipe bt=nofile

" mappings
nmap <buffer>  h   <Cmd>Flipdir<CR>
nmap <buffer>  l   <Plug>(flipdir_enter)
nmap <buffer> <CR> <Plug>(flipdir_enter)

map  <buffer> s <Plug>(flipdir_split)  
map  <buffer> v <Plug>(flipdir_vsplit) 
map  <buffer> t <Plug>(flipdir_tabedit)
nmap <buffer> p <Plug>(flipdir_preview)

map <buffer> x <Plug>(flipdir_argadd)

" avoid pressing J after V
xmap <buffer> J j

" hide dot prefixed lines. 'u' to show dot files again.
nmap <silent><buffer> gh <Cmd>call <SID>HideDot()<CR>

" delete flipdir buffer
nmap <buffer><nowait><silent> gq <Cmd>bdelete!<CR>

function s:HideDot()
	call search("^[^.]", "c")
	keeppatterns g/^\./d_
	call cursor(line("''"), 1)
endfunction
