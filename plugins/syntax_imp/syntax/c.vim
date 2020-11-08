" Member
syntax match CClassMember '\(\.\|->\)\zs\<\w\+\>'
highlight! default link CClassMember Identifier

" Function call
syntax match CFunctionCall '\(\.\|->\)\?\zs\<\w\+\>\ze\s*('
highlight! default link CFunctionCall Function
