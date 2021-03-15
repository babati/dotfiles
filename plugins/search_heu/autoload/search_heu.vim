let s:c_cpp_header_extensions = ['h', 'hh', 'hpp', 'hxx']
let s:c_cpp_source_extensions = ['cc', 'cpp', 'cxx', 'c']

let s:cpp_type_definition_pattern = '\(\(\(\<struct\>\)\|\(\<class\>\)\|\(\<enum\>\)\) \+\<$*\>\)\|\(\<using\> \+\<$*\> \+=\)\|\(\<typedef\> .* \<$*\> *;\)'
let s:cpp_usage_pattern = '\<$*\>'
let s:cpp_function_pattern = '\<$*\> *('

let s:py_type_definition_pattern = 'class \+\<$*\>'
let s:py_type_usage_pattern = '\<$*\>'
let s:py_function_definition_pattern = 'def \+\<$*\> *('
let s:py_function_usage_pattern = '\<$*\> *('

" Text search
function! search_heu#grep_in_cwd(pattern)
    execute('silent grep! "'.a:pattern.'" '.getcwd())
    botright copen
endfunction

function! search_heu#lgrep_in_cwd(pattern)
    execute('silent lgrep! "'.a:pattern.'" '.getcwd())
    silent! botright lopen
endfunction

function! search_heu#grep_in_current_file(pattern)
    let filename = expand('%')

    if !empty(filename)
        execute('silent lvimgrep "'.a:pattern.'" '.filename)
        silent! botright lopen
    endif
endfunction

function! s:token_search(word, pattern, fallback_pattern)
    call search_heu#lgrep_in_cwd(a:word)

    let target_pattern = substitute(a:pattern, '\$\*', a:word, 'g')
    let content = filter(getloclist(0), 'v:val["text"] =~? target_pattern')

    if empty(content) && !empty(a:fallback_pattern)
        let target_pattern = substitute(a:fallback_pattern, '\$\*', a:word, 'g')
        let content = filter(getloclist(0), 'v:val["text"] =~? target_pattern')
    endif

    call setloclist(0, content)
endfunction

function! search_heu#definition_search_cpp(pattern)
    call s:token_search(a:pattern, s:cpp_type_definition_pattern, s:cpp_function_pattern)
endfunction

function! search_heu#usage_search_cpp(pattern)
    call s:token_search(a:pattern, s:cpp_usage_pattern, '')
endfunction

function! search_heu#definition_search_python(pattern)
    call s:token_search(a:pattern, s:py_type_definition_pattern, s:py_function_definition_pattern)
endfunction

function! search_heu#usage_search_python(pattern)
    call s:token_search(a:pattern, s:py_function_usage_pattern, s:py_type_usage_pattern)
endfunction

" File search
function! search_heu#find_file(filename)
    let result = findfile(a:filename, getcwd().'/**')
    if !empty(result)
        execute('edit '.result)
        return 1
    endif
endfunction

function! s:check_file(extensions)
    let filename = expand('%:t:r')
    for ext in a:extensions
        if search_heu#find_file(filename.'.'.ext) == 1
            break
        endif
    endfor
endfunction

function! search_heu#switch_source_header_c_cpp()
    let current_extension = expand('%:e')
    if index(s:c_cpp_source_extensions, current_extension) != -1
        call s:check_file(s:c_cpp_header_extensions)
    elseif index(s:c_cpp_header_extensions, current_extension) != -1
        call s:check_file(s:c_cpp_source_extensions)
    endif
endfunction
