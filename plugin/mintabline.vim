if exists('g:loaded_mintabline_vim')
	finish
endif
let g:loaded_mintabline_vim = 1

function! s:toSuperscript(n)
	let unicodes = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹']
	return a:n < len(unicodes) ? unicodes[a:n] : '⁺'
endfunction

function! mintabline#tabline()
	let s = ''
	for i in range(tabpagenr('$'))
		" Get tab infos
		let tab = i + 1
		let winnr = tabpagewinnr(tab)
		" Get buf infos
		let buflist = tabpagebuflist(tab)
		let bufspnr = buflist[winnr - 1]
		let bufname = bufname(bufspnr)
		let bufmodif = getbufvar(bufspnr, '&mod')

		" Set tab state
		let s .= '%' . tab . 'T'
		let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')

		" Set tab label
		let s .= ' '
		if bufname =~ 'term://.*#FZF$'
			let s .= 'FZF '
		else
			" Empty or collapsed name
			let s .= (empty(bufname) ? '∅ ' : substitute(fnamemodify(bufname, ':~:.'), '\v\w\zs.{-}\ze(\\|/)', '', 'g'))
			" Add modified flag or number
			if bufmodif != 0
				let s .= '* '
			else
				let s .= s:toSuperscript(tab) . ' '
			endif
		endif
	endfor

	" Finalize tabline
	let s .= '%#TabLineFill#'

	return s
endfunction

set tabline=%!mintabline#tabline()
