" flipdir buffer local mappings
" 'let g:flipdir_defaults = 0' to disable default mappings
if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

if get(g:, 'flipdir_mappings', 1)

	" line paths commands
	map <buffer> l <Plug>(flip_linepath)
	map <buffer> s <Plug>(split_linepath)
	map <buffer> v <Plug>(vsplit_linepath)
	map <buffer> t <Plug>(tabedit_linepath)
	map <buffer> p <Plug>(preview_linepath)
	map <buffer> a <Plug>(argadd_linepath)

	" up directory
	nmap <buffer><silent> h :Flipdir<CR>

	" edit flipdir buffer
	nmap <buffer><nowait> gh <Plug>(flipdir_hidedot)
	nmap <buffer><nowait> gr <Plug>(flipdir_reload)

	" delete flipdir buffer
	nmap <buffer><nowait><silent> gq :bdelete!<CR>

endif
