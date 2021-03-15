function! quickfix_cust#toggle_quickfix_window()
    let qf_winid = getqflist({'winid':1})

    if empty(qf_winid) || qf_winid.winid == 0
        botright copen
    else
        cclose
    endif
endfunction

function! quickfix_cust#toggle_loclist_window()
    let loclist_winid = getloclist(0, {'winid':1})

    if empty(loclist_winid) || empty(getwininfo(loclist_winid.winid))
        silent! botright lopen
    else
        lclose
    endif
endfunction

function s:open_buffer(current)
    for info in getwininfo()
        if info.bufnr == a:current.bufnr
            execute info.winnr.'wincmd w'
            execute a:current.lnum
            return
        endif
    endfor

    wincmd p
    execute 'buffer +'.a:current.lnum.' '.a:current.bufnr
endfunction

function s:open_in_last_window()
    if getwininfo(win_getid())[0].loclist
        call feedkeys("\<cr>", 'n')
    elseif !empty(getqflist())
        let current = getqflist()[line('.') - 1]
        if current.bufnr
            call s:open_buffer(current)
        endif
    endif
endfunction

function! quickfix_cust#initialize()
    augroup QfCustomization
        autocmd!
        autocmd FileType qf setlocal wrap nonumber norelativenumber colorcolumn=0 statusline=
        autocmd FileType qf nnoremap <silent> <buffer> <cr> :call <sid>open_in_last_window()<cr>
        autocmd WinEnter * if winnr('$') == 1 && &buftype == "quickfix" | quit | endif
    augroup end
endfunction
