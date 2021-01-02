if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

" filetype mappings
nmap <buffer><nowait> gh <Plug>(flipdir_HideDot)
nmap <buffer><nowait> r  <Plug>(flipdir_Reload)
nmap <buffer><nowait> h  <Plug>(flipdir_UpDir)

map <buffer><nowait> l  <Plug>(flipdir_Enter)
map <buffer><nowait> s  <Plug>(flipdir_SEnter)
map <buffer><nowait> v  <Plug>(flipdir_VEnter)
map <buffer><nowait> p  <Plug>(flipdir_Preview)

nmap <buffer><nowait> gq :bdelete!<CR>
