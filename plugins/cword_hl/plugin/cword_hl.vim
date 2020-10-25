" File: cword_hl.vim
" Description: Cword highlight and search plugin
" License: MIT License

if exists("g:loaded_cword_hl") || v:version < 800
    finish
endif

let g:loaded_cword_hl = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" Options
let g:cword_hl_timeout = get(g:, 'cword_hl_timeout', 1000) " msec

" Autocommands
augroup CwordHl
    autocmd!
    autocmd VimEnter * call cword_hl#initialize()
augroup end

" Mappings
nnoremap <silent> <unique> <f8> :call cword_hl#turn_off()<cr>
nnoremap <silent> <unique> n :call cword_hl#next_match('n')<cr>
nnoremap <silent> <unique> N :call cword_hl#next_match('N')<cr>

nnoremap <silent> <unique> # :call cword_hl#cword_normal_search()<cr>
nmap <silent> <unique> * #

vnoremap <silent> <unique> # :call cword_hl#cword_visual_search()<cr>
vmap <silent> <unique> * #

let &cpoptions = s:save_cpo
unlet s:save_cpo
