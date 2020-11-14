let s:configured = v:false

function! s:setup_scratch_buffer(type)
    execute('set filetype='.a:type)
    setlocal nonumber norelativenumber buftype=nofile bufhidden=wipe nobuflisted colorcolumn=0
endfunction

function! s:fill_buffer(filetype, ...)
    call s:setup_scratch_buffer(a:filetype)

    for cmd in a:000
        let output = system(cmd)
        silent! put =output
    endfor

    let current_line = line('.')
    1delete _
    call cursor(current_line, 1)
    setlocal nomodifiable
endfunction!

function! s:show_inplace(current_file, current_line)
    let commit_hash = substitute(split(getbufline(bufnr('%'), line('.'))[0], '\s')[0], '\^', '', '')
    quit

    enew

    let b:current_file = a:current_file
    let b:current_line = a:current_line

    execute('file [show '.commit_hash.']')
    call s:fill_buffer('git',
                \ 'git show --pretty=fuller --stat '.commit_hash,
                \ 'git show --pretty=format:"" '.commit_hash)
    call cursor(1, 1)

    nnoremap <silent> <buffer> q :execute('edit +'.b:current_line.' '.b:current_file)<cr>
endfunction!

function! git_fn#blame()
    let current_file = expand('%')
    let current_line = line('.')

    set scrollbind

    42vnew [blame]
    call s:fill_buffer('gitrebase', 'git blame -f -c '.current_file)

    let b:current_file = current_file
    let b:current_line = current_line

    nnoremap <silent> <buffer> <Enter> :call <sid>show_inplace(b:current_file, b:current_line)<cr>
    nnoremap <silent> <buffer> q :q<cr>
    autocmd BufLeave <buffer> wincmd p | set noscrollbind

    call cursor(1, 1)
    execute('normal '.(current_line-1).'j')

    set scrollbind
    syncbind
endfunction

function! git_fn#diff(revision)
    let current_file = expand('%')
    let current_line = line('.')
    let filetype = &filetype

    diffthis

    execute('vnew [diff '.(empty(a:revision) ? 'HEAD' : a:revision).']')
    call s:fill_buffer(filetype, 'git show '.a:revision.':'.substitute(current_file, getcwd().'/','',''))
    diffthis

    nnoremap <silent> <buffer> q :diffoff!<cr>:q<cr>
    call cursor(current_line, 1)
endfunction

function! git_fn#merge()
    let conflicting_files = systemlist('git diff --no-ext-diff --no-color --name-only --diff-filter=U')
    cexpr []

    if !empty(conflicting_files)
        for file in conflicting_files
            let markers = systemlist(substitute(&grepprg, '\$\*', '"<<<<<<<" '.file, ''))
            if !empty(markers)
                caddexpr markers[0]
            endif
        endfor
        botright copen
    else
        echom '[Git] No conflicting file has been found.'
    endif
endfunction

function! s:extract_changes_from_diff(diff_line)
    let splitted = split(a:diff_line, ',')
    let line = splitted[0]
    let count = len(splitted) > 1 ? splitted[1] : 1
    return count ? range(line, line + count - 1) : []
endfunction

function! s:place_signs(name, filename, processed, others)
    for line in a:processed
        if empty(a:others) || (line < a:others[0] || line > a:others[-1])
            execute('sign place 1 line='.line.' name='.a:name.' file='.a:filename)
        else
            execute('sign place 1 line='.line.' name=Modified file='.a:filename)
        endif
    endfor
endfunction

function! s:collect_signs(filename)
    if !s:configured || empty(a:filename) || !executable('grep')
        return
    endif

    execute('sign unplace * file='.a:filename)

    let result = systemlist('git diff --no-ext-diff --no-color --unified=0 HEAD -- '.a:filename.' 2> /dev/null | grep -e "^@@"')
    for change in result
        let status = split(split(change, '@@')[0], '\s')
        let deleted_lines = s:extract_changes_from_diff(status[0][1:])
        let added_lines = s:extract_changes_from_diff(status[1][1:])

        call s:place_signs('Removed', a:filename, deleted_lines, added_lines)
        call s:place_signs('Added', a:filename, added_lines, deleted_lines)
    endfor
endfunction

function! git_fn#initialize()
    let repo_root = system('git rev-parse --show-toplevel')

    if v:shell_error == 0
        execute('cd '.substitute(repo_root, '\n', '', 'g'))
        let s:configured = v:true
        set grepprg=git\ --no-pager\ grep\ -n\ -E\ --no-color\ -i\ $*
        set grepformat=%f:%l:%m

        sign define Added text=+ texthl=diffAdded
        sign define Modified text=~ texthl=Type
        sign define Removed text=_ texthl=WarningMsg

        augroup GitWorkingDirectory
            autocmd!
            autocmd BufReadPost,BufWritePost * call s:collect_signs(expand('%:p'))
        augroup end
    endif
endfunction
