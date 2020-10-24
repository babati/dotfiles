" File: task_exec.vim
" Description: Task executor plugin
" License: MIT License

if exists("g:loaded_task_exec") || !has('nvim')
    finish
endif

let g:loaded_task_exec = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" Commands
command! -nargs=+ StartQfTask call task_exec#start_qf_task('<args>')
command! -nargs=+ StartDaemon call task_exec#start_daemon('<args>')
command! -nargs=0 StopRunningTasks call task_exec#stop_running_tasks()
command! -nargs=0 ShowRunningQfTask call task_exec#show_running_qf_task()
command! -nargs=0 ShowRunningDaemons call task_exec#show_running_deamons()

" Mappings
autocmd FileType qf nnoremap <silent> <buffer> <c-c> :StopRunningTasks<cr>

let &cpoptions = s:save_cpo
unlet s:save_cpo
