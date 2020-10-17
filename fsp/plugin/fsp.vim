" File: fsp.vim
" Description: Minimal file search plugin
" License: MIT License

if exists("g:loaded_fsp") || v:version < 800
    finish
endif

let g:loaded_fsp = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" Options
let g:fsp_number_of_matches = get(g:, 'fsp_number_of_matches', 10)
let g:fsp_search_commands = get(g:, 'fsp_search_commands', ['git ls-files -co', 'find'])

" Commands
command! -nargs=0 FspFiles call fsp#find_files()
command! -nargs=0 FspBuffers call fsp#find_buffers()
command! -nargs=0 FspLines call fsp#find_lines()
command! -nargs=0 FspClearCache call fsp#clear_cache()

" Mappings
if !hasmapto('FspFiles')
    nnoremap <unique> <silent> <leader>f :FspFiles<cr>
endif

if !hasmapto('FspBuffers')
    nnoremap <unique> <silent> <leader>u :FspBuffers<cr>
endif

if !hasmapto('FspLines')
    nnoremap <unique> <silent> <leader>o :FspLines<cr>
endif

let &cpoptions = s:save_cpo
unlet s:save_cpo
