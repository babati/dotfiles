" File: tep.vim
" Description: Task executor plugin
" License: MIT License

if exists("g:loaded_tep") || !has('nvim')
    finish
endif

let g:loaded_tep = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" Commands
command! -nargs=+ StartQfTask call tep#start_qf_task('<args>')
command! -nargs=+ StartDaemon call tep#start_daemon('<args>')
command! -nargs=0 StopRunningTasks call tep#stop_running_tasks()
command! -nargs=0 ShowRunningQfTask call tep#show_running_qf_task()
command! -nargs=0 ShowRunningDaemons call tep#show_running_deamons()

" Mappings
autocmd FileType qf nnoremap <silent> <buffer> <c-c> :StopRunningTasks<cr>

let &cpoptions = s:save_cpo
unlet s:save_cpo
