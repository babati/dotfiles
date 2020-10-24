" File: git_fn.vim
" Description: Git helper functions
" License: MIT License

if exists("g:loaded_git_fn") || v:version < 700 || !executable('git')
    finish
endif

let g:loaded_git_fn = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" Autocommands
augroup GitFn
    autocmd!
    autocmd VimEnter * call git_fn#initialize()
augroup end

" Commands
command! -nargs=0 BlameG call git_fn#blame()
command! -nargs=? DiffG call git_fn#diff("<args>")
command! -nargs=0 MergeG call git_fn#merge()

let &cpoptions = s:save_cpo
unlet s:save_cpo
