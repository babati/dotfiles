let s:fsp_cached_files = []

function! s:setup_scratch_buffer(type)
    execute('set filetype='.a:type)
    setlocal nonumber norelativenumber buftype=nofile bufhidden=wipe nobuflisted colorcolumn=0
endfunction

function! s:clear_cmd_line()
    redraw
    echo ' '
endfunction

function! s:execute_and_restore_pos(command)
    let current_line = line('.')
    let current_col = col('.')

    execute(a:command)
    call cursor(current_line, current_col)
endfunction

function! s:cut_working_dir(path)
    return substitute(a:path, getcwd().'/','','')
endfunction

function! s:cache_files()
    for cmd in g:fsp_search_commands
        let s:fsp_cached_files = systemlist(cmd)
        if v:shell_error == 0 && !empty(s:fsp_cached_files)
            break
        endif
    endfor

    if empty(s:fsp_cached_files)
        let s:fsp_cached_files = map(filter(globpath(getcwd(), '**', 0, 1), '!isdirectory(v:val)'), 's:cut_working_dir(v:val)')
    endif
endfunction

function! s:get_matching_files(word, list, fuzzy)
    let result = []

    let pattern = (a:fuzzy ? join(split(a:word, '\zs'), '.\{-}') : a:word)
    for file in a:list
        if file =~? pattern
            call add(result, file)
        endif

        if len(result) == g:fsp_number_of_matches
            return [pattern, result]
        endif
    endfor
    return [pattern, result]
endfunction

function! s:open_file(line, mode)
    if empty(a:line)
        hide
        return
    endif

    let file_with_line = split(a:line, '\s')[0]
    let file_to_open = split(file_with_line, ':')

    hide

    if file_with_line[0] == ':'
        call insert(file_to_open, expand('%'))
    elseif file_to_open[0][0] != '/'
        let file_to_open[0] = getcwd().'/'.file_to_open[0]
    endif

    if len(file_to_open) > 1
        execute(a:mode.' +'.file_to_open[1].' '.fnameescape(file_to_open[0]))
    else
        execute(a:mode.' '.fnameescape(file_to_open[0]))
    endif
endfunction

function! s:fill_search_window(pattern, files)
    let number_of_lines = min([len(a:files), g:fsp_number_of_matches])

    silent! put =a:files[:number_of_lines-1]
    call s:execute_and_restore_pos('1delete _')

    if number_of_lines != winheight(0)
        execute('resize '.number_of_lines)
        normal ggG " refresh the current view
    endif

    if !empty(a:pattern)
        syntax clear FspSearch
        execute('syntax match FspSearch "\c'.a:pattern.'"')
    endif

    redraw
endfunction

function! s:find_files(name, list)
    execute('below botright '.g:fsp_number_of_matches.'new '.a:name)

    let current_word = ''

    call s:setup_scratch_buffer('fsp')
    call s:fill_search_window(current_word, a:list)

    highlight! def link FspSearch Visual
    autocmd BufLeave <buffer> wincmd p
    " disable ctrl-c
    nnoremap <buffer> <silent> <c-c> <cr>

    let matching_mode = 0

    while 1
        echo '> '.current_word

        let c = getchar()
        if type(c) == type(0)
            if c == 27 " 27 - <esc>
                hide
                call s:clear_cmd_line()
                break
            elseif c == 13 " <enter>
                call s:open_file(getline('.'), 'edit')
                call s:clear_cmd_line()
                break
            elseif c == 22 " <c-v>
                call s:open_file(getline('.'), 'vsplit')
                call s:clear_cmd_line()
                break
            elseif c == 10 " <c-j>
                call cursor(line('.') + 1, 1)
                redraw
                continue
            elseif c == 11 " <c-k>
                call cursor(line('.') - 1, 1)
                redraw
                continue
            elseif c == 8 " <c-h>
                call cursor(1, 1)
                redraw
                continue
            elseif c == 12 " <c-l>
                call cursor('$', 1)
                redraw
                continue
            elseif c >= 32 && c <= 126
                let next_char = nr2char(c)
                let current_word = current_word.next_char
            else
                call s:clear_cmd_line()
                redraw
                continue
            endif
        elseif c is# "\<backspace>"
            let current_word = current_word[:-2]
            let matching_mode = 0
        else
            call s:clear_cmd_line()
            redraw
            continue
        endif

        if getchar(1)
            call s:clear_cmd_line()
            redraw
            continue
        endif

        call s:execute_and_restore_pos('%delete _')

        let [pattern, files] = s:get_matching_files(escape(current_word, '.'), a:list, matching_mode)
        if empty(files) && matching_mode == 0
            let matching_mode = 1
            let [pattern, files] = s:get_matching_files(escape(current_word, '.'), a:list, matching_mode)
        endif

        call s:fill_search_window(pattern, files)
    endwhile

    highlight! def link FspSearch NONE
    syntax clear FspSearch
endfunction

function! fsp#find_files()
    if empty(s:fsp_cached_files)
        call s:cache_files()
    endif
    call s:find_files('[files]', s:fsp_cached_files)
endfunction

function! fsp#find_buffers()
    call s:find_files('[buffers]', filter(map(copy(getbufinfo({'bufloaded':1})), 's:cut_working_dir(v:val.name)'), {idx, val -> strlen(val) > 0}))
endfunction

function fsp#find_lines()
    call s:find_files('[lines]', map(getbufline(bufnr('%'), 1, '$'), '":".eval(v:key + 1)." ".v:val'))
endfunction

function! fsp#clear_cache()
    let s:fsp_cached_files = []
endfunction
