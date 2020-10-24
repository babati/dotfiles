runtime! syntax/c.vim

" Scoped type
syntax match CppScopedType '::\s*\zs\<\w\+\>\ze\s*[^:]'
highlight! default link CppScopedType Type

" Scope
syntax match CppScope '\<\w\+\>\ze\s*::'
highlight! default link CppScope Constant
