let s:keywords = {}
let s:completion_time_limit = 0.005 " sec
let s:last_insertion = reltime()

function! CeKeywordComplete(findstart, base)
    return a:findstart ? <sid>find_word_start() : <sid>collect_matching_words(a:base)
endfunction

function! s:find_word_start()
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~? '\w'
        let start -= 1
    endwhile
    return start
endfunction!

function! s:collect_matching_words(base)
    let result = []
    if a:base[0] =~? '\w'
        let result = copy(s:keywords[tolower(a:base[0])])
        call filter(result, 'v:val =~? "^".a:base')
        call map(result, "{ 'word': v:val, 'kind': ' ' }")
    endif
    return { 'words': result, 'refresh': 'always' }
endfunction

function! s:cache_keywords()
    if getfsize(expand('%')) < g:min_compl_max_file_size
        let keywords = uniq(sort(split(join(getline(1,'$'), ' '), '\W\+')))
        call map(keywords, 'add(s:keywords[tolower(v:val[0])], v:val)')
        call map(s:keywords, 'uniq(sort(v:val))')
    endif
endfunction

function! s:is_completion_enabled(elapsed_time)
    return a:elapsed_time > s:completion_time_limit && !pumvisible() && !(&buftype ==? 'nofile')
endfunction

function! s:get_completion_type(current_char)
    let elapsed_time = reltimefloat(reltime(s:last_insertion))
    let s:last_insertion = reltime()
    if s:is_completion_enabled(elapsed_time)
        return a:current_char == '/' ? "\<c-x>\<c-f>" : "\<c-x>\<c-u>"
    endif
    return ''
endfunction

function! s:start_completion()
    call feedkeys(s:get_completion_type(v:char))
endfunction

function! min_compl#initialize()
    set completeopt=menuone,noselect                " show popup with one match
    set shortmess+=ac                               " hide completion message
    call execute('set pumheight='.g:min_compl_max_items)   " max height of popup
    set completefunc=CeKeywordComplete

    for x in range(33, 126)
        let s:keywords[nr2char(x)] = []
    endfor

    augroup McpInit
        autocmd!
        autocmd InsertEnter * let s:last_insertion = reltime()
        autocmd InsertCharPre * call s:start_completion()
        autocmd BufReadPost,BufWritePost * call s:cache_keywords()
    augroup end
endfunction

function! min_compl#tab_completion(direction)
    if pumvisible()
        return a:direction == 1 ? "\<c-p>" : "\<c-n>"
    else
        let line = getline('.')
        let col = col('.')

        if (col == 1) || (line[col - 2] =~? '\s')
            return "\<tab>"
        else
            return s:get_completion_type(line[col - 2])
        endif
    endif
endfunction

function! min_compl#handle_enter()
    return pumvisible() ? (empty(v:completed_item['kind']) ? "\<c-g>u\<cr>" : "\<c-y>") : "\<cr>"
endfunction

function! min_compl#handle_esc()
    return pumvisible() ? (empty(v:completed_item['kind']) ? "\<c-e>\<esc>\<esc>" : "\<c-y>\<esc>\<esc>") : "\<esc>"
endfunction

function! min_compl#handle_ctrl_c()
    return pumvisible() ? "\<c-e>" : "\<c-c>"
endfunction
