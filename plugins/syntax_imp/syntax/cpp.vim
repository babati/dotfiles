" Scoped type
syntax match CppScopedType '::\s*\zs\<\w\+\>'
highlight! default link CppScopedType Type

" Scope
syntax match CppScope '\<\w\+\>\ze\s*::'
highlight! default link CppScope Constant

runtime! syntax/c.vim
