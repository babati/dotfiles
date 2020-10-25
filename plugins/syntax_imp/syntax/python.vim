" Member
syntax match PyClassMember '\.\<\w\+\>\ze\s*[^(]'
highlight! default link PyClassMember Identifier

" Function call
syntax match PyFunctionCall '\.\?\zs\<\w\+\>\ze\s*('
highlight! default link PyFunctionCall Function

" Self
syntax keyword PySelf self
highlight! default link PySelf Type
