" flipdir buffer local mappings
if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

" settings
setlocal nospell noswf nobl bh=hide bt=nofile

" mappings
map <buffer>  h   <Cmd>Flipdir<CR>
map <buffer>  l   <Plug>(flipdir_enter)
map <buffer> <CR> <Plug>(flipdir_enter)

map  <buffer> s <Plug>(flipdir_split)  
map  <buffer> v <Plug>(flipdir_vsplit) 
map  <buffer> t <Plug>(flipdir_tabedit)
map  <buffer> x <Plug>(flipdir_argadd)
nmap <buffer> p <Plug>(flipdir_preview)

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
