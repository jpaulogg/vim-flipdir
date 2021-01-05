" flipdir buffer local mappings
" 'let g:flipdir_mappings = 0' to disable default mappings
if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

" line paths commands
map <unique><buffer> l <Plug>(flip_linepath)
map <unique><buffer> s <Plug>(split_linepath)
map <unique><buffer> v <Plug>(vsplit_linepath)
map <unique><buffer> t <Plug>(tabedit_linepath)
map <unique><buffer> p <Plug>(preview_linepath)
map <unique><buffer> a <Plug>(argadd_linepath)

" up directory
nmap <unique><buffer><silent> h :Flipdir<CR>

" edit flipdir buffer
nmap <unique><buffer><nowait> gh <Plug>(flipdir_hidedot)
nmap <unique><buffer><nowait> gr <Plug>(flipdir_reload)

" delete flipdir buffer
nmap <unique><buffer><nowait><silent> gq :bdelete!<CR>
