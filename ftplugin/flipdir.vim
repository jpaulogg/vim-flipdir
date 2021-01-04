" flipdir buffer local mappings
" 'let g:flipdir_defaults = 0' to disable default mappings
if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

if get(g:, 'flipdir_mappings', 1)

	" line paths commands
	nmap <buffer><nowait> h  <Plug>(flip_updir)
	map  <buffer><nowait> l  <Plug>(flip_linepath)
	map  <buffer><nowait> s  <Plug>(split_linepath)
	map  <buffer><nowait> v  <Plug>(vsplit_linepath)
	map  <buffer><nowait> p  <Plug>(preview_linepath)
	map  <buffer><nowait> a  <Plug>(arglist_linepath)

	" edit flipdir buffer
	nmap <buffer><nowait> gh <Plug>(flipdir_hidedot)
	nmap <buffer><nowait> gr <Plug>(flipdir_reload)

	" delete flipdir buffer
	nmap <buffer><nowait><silent> gq :bdelete!<CR>
endif
