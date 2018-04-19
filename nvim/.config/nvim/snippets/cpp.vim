function! g:Neosnippet_GetCppPath() abort
	let path=expand("%:p")
	return path
endfunction

function! g:Neosnippet_GetHeaderGuardString() abort
	let path = []
	let parts = split(expand('%:p'), '/')
	let src_index = index(parts, 'src')
	if src_index < 0
		return ''
	endif
	let parts = [parts[src_index-1]] + parts[src_index+1:]
	return substitute(toupper(join(parts, '_')), '[^0-9A-Z]', '_', 'g')
endfunction
