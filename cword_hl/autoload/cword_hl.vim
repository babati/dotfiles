function! s:search_visual_selection() range
    let start_pos = getpos("'<")
    let end_pos = getpos("'>")

    let lines = getline(start_pos[1], end_pos[1])
    let lines[-1] = strpart(lines[-1], 0, end_pos[2])
    let lines[0] = strpart(lines[0], start_pos[2] - 1)

    return escape(join(lines, '\n'), '/.*$^~[]')
endfunction

function! s:search_word(word) range
    call setreg('/', a:word)
    call histadd('search', a:word)
    set hlsearch

    " Workaround to highlight the first search as well
    call feedkeys('n', 'n')
    call feedkeys('N', 'n')
endfunction

function! s:highlight_cword()
    if &buftype == '' && &diff == 0 " normal buffer and diff is not active
        let current_char = getline('.')[col('.') - 1]
        let current_word = expand('<cword>')

        if current_word =~? current_char && current_word =~? '^\w\+$' && !(getreg('/') =~? current_word)
            highlight! def link EmphasizedCword Visual
            execute('match EmphasizedCword "\<'.current_word.'\>"')
        endif
    endif
endfunction

function! cword_hl#turn_off()
    nohlsearch
    diffupdate
    call setreg('/', '')
endfunction

function! cword_hl#next_match(key)
    if empty(getreg('/'))
        call setreg('/', histget('search', -1))
    endif
    call feedkeys(a:key, 'n')
endfunction

function! cword_hl#cword_normal_search()
    call s:search_word('\<'.expand('<cword>').'\>')
endfunction

function! cword_hl#cword_visual_search()
    call s:search_word(s:search_visual_selection())
endfunction

function! cword_hl#initialize()
    execute('set updatetime='.g:cword_hl_timeout)

    augroup CwordHighlight
        autocmd!
        autocmd! CursorHold * call s:highlight_cword()
        autocmd! CursorMoved,InsertEnter * highlight! def link EmphasizedCword NONE | syntax clear EmphasizedCword
    augroup end
endfunction
