" File: min_compl.vim
" Description: Minimal completion plugin
" License: MIT License

if exists("g:loaded_min_compl") || v:version < 800
    finish
endif

let g:loaded_min_compl = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" Options
let g:min_compl_max_items = get(g:, 'min_compl_max_items ', 10)
let g:min_compl_max_file_size = get(g:, 'min_compl_max_file_size', 1024000) " bytes

" Autocommands
augroup Mcp
    autocmd!
    autocmd VimEnter * call min_compl#initialize()
augroup end

" Mappings
inoremap <expr> <unique> <silent> <tab> min_compl#tab_completion(-1)
inoremap <expr> <unique> <silent> <s-tab> min_compl#tab_completion(1)
inoremap <expr> <unique> <silent> <cr> min_compl#handle_enter()
inoremap <expr> <unique> <silent> <esc> min_compl#handle_esc()
inoremap <expr> <unique> <silent> <c-c> min_compl#handle_ctr_c()

let &cpoptions = s:save_cpo
unlet s:save_cpo
