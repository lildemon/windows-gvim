" Vim indent file
" Language:     tf (TinyFugue)
" Maintainer:   Christian J. Robinson <infynity@onewest.net>
" URL:          http://www.infynity.spodzone.com/vim/indent/tf.vim
" Last Change:  2002 May 29

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetTFIndent()
setlocal indentkeys-=0{,0} indentkeys-=0# indentkeys-=:
setlocal indentkeys+==/endif,=/then,=/else,=/done,0;

" Only define the function once:
if exists("*GetTFIndent")
  finish
endif

function GetTFIndent()
	" Find a non-blank line above the current line:
	let lnum = prevnonblank(v:lnum - 1)

	" No indent for the start of the file:
	if lnum == 0
		return 0
	endif

	let ind = indent(lnum)
	let line = getline(lnum)

	" No indentation if the previous line didn't end with "\":
	" (Could be annoying, but it lets you know if you made a mistake.)
	if line !~ '\\$'
		return 0
	endif

	if line =~ '\(/def.*\\\|/for.*\(%;\s*\)\@\<!\\\)$'
		let ind = ind + &sw
	elseif line =~ '\(/if\|/else\|/then\)'
		if line !~ '/endif'
			let ind = ind + &sw
		endif
	elseif line =~ '/while'
		if line !~ '/done'
			let ind = ind + &sw
		endif
	endif

	let line = getline(v:lnum)

	if line =~ '\(/else\|/endif\|/then\)'
		if line !~ '/if'
			let ind = ind - &sw
		endif
	elseif line =~ '/done'
		if line !~ '/while'
			let ind = ind - &sw
		endif
	endif

	" Comments at the beginning of a line:
	if line =~ '^\s*;'
		let ind = 0
	endif


	return ind

endfunction
