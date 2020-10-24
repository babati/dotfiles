let s:qf_task_id = 0
let s:daemon_task_ids = []
let s:scrolling = 1

function! s:start_task(command, callbacks)
    return jobstart(split(a:command, '\s'), a:callbacks)
endfunction

function! s:on_event_qf(task_id, data, event) dict
    let s:scrolling = &filetype != 'qf' || line('.') == line('$')

    for line in a:data
        caddexpr substitute(line, '\%\x1b\[[0-9;]*[mKGHF]', '', 'g')
    endfor

    if s:scrolling
        cbottom
    endif
endfunction

function! s:on_exit_qf(task_id, data, event) dict
    let s:qf_task_id = 0
    caddexpr '['.a:task_id.'] Exited with code '.a:data

    if s:scrolling
        cbottom
    endif
endfunction

function! s:on_exit_daemon(task_id, data, event) dict
    let list_id = index(s:daemon_task_ids, a:task_id)
    if list_id != -1
        call remove(s:daemon_task_ids, list_id)
    endif
endfunction

function! task_exec#start_qf_task(command)
    let s:qf_callbacks = {
        \ 'on_stdout': function('s:on_event_qf'),
        \ 'on_stderr': function('s:on_event_qf'),
        \ 'on_exit': function('s:on_exit_qf')
    \ }

    if s:qf_task_id == 0
        cexpr []
        caddexpr a:command
        botright copen
        let s:qf_task_id =s:start_task(a:command, s:qf_callbacks)
    else
        echom '[Async] A quickfix task is already runnning, id:'.s:qf_task_id
    endif
endfunction

function! task_exec#start_daemon(command)
    let s:daemon_callbacks = { 'on_exit': function('s:on_exit_daemon') }

    let task_id = s:start_task(a:command, s:daemon_callbacks)
    if task_id > 0
        call insert(s:daemon_task_ids, task_id)
    endif
endfunction

function! task_exec#stop_running_tasks()
    if s:qf_task_id != 0
        call jobstop(s:qf_task_id)
        let s:qf_task_id = 0
    endif

    for id in s:daemon_task_ids
        call jobstop(id)
    endfor

    let s:daemon_task_ids = []
endfunction

function! task_exec#show_running_qf_task()
    echom '[Async] Running quickfix task:'.(s:qf_task_id > -2 ? s:qf_task_id : 'NONE')
endfunction

function! task_exec#show_running_deamons()
    echom '[Async] Running daemons:'.(len(s:daemon_task_ids) > 0 ? join(s:daemon_task_ids, ',') : 'NONE')
endfunction
