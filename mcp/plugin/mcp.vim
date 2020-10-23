" File: mcp.vim
" Description: Minimal completion plugin
" License: MIT License

if exists("g:loaded_mcp") || v:version < 800
    finish
endif

let g:loaded_mcp = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" Options
let g:mcp_max_items = get(g:, 'mcp_max_items ', 10)
let g:mcp_max_file_size = get(g:, 'mcp_max_file_size', 1024000) " bytes

" Autocommands
augroup Mcp
    autocmd!
    autocmd VimEnter * call mcp#initialize()
augroup end

" Mappings
inoremap <expr> <unique> <silent> <tab> mcp#tab_completion(-1)
inoremap <expr> <unique> <silent> <s-tab> mcp#tab_completion(1)
inoremap <expr> <unique> <silent> <cr> mcp#handle_enter()
inoremap <expr> <unique> <silent> <esc> mcp#handle_esc()
inoremap <expr> <unique> <silent> <c-c> mcp#handle_ctr_c()

let &cpoptions = s:save_cpo
unlet s:save_cpo
