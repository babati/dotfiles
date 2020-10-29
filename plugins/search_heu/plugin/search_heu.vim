" File: search_heu.vim
" Description: Heuristic search functions for text and files
" License: MIT License

if exists("g:loaded_search_heu") || v:version < 700
    finish
endif

let g:loaded_search_heu = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" Commands
command! -nargs=+ Bg call search_heu#grep_in_current_file('<args>')
command! -nargs=+ Dg call search_heu#lgrep_in_cwd('<args>')
command! -nargs=+ Dgq call search_heu#grep_in_cwd('<args>')

command! -nargs=+ FindFile call search_heu#find_file('<args>')
command! -nargs=+ DefSearch if &filetype == 'cpp' | call search_heu#definition_search_cpp('<args>') | elseif &filetype == 'python' | call search_heu#definition_search_python('<args>') | endif

" Mappings
nnoremap <silent> <f1> :execute('FindFile '.expand('<cfile>'))<cr>

noremap <silent> <unique> <f11> :execute('Dg '.expand('<cword>'))<cr>
noremap <silent> <unique> <f12> :execute('Bg '.expand('<cword>'))<cr>

autocmd Filetype c,cpp nnoremap <silent> <buffer> <f4> :call search_heu#switch_source_header_c_cpp()<cr>
autocmd Filetype c,cpp nnoremap <silent> <buffer> <leader>j :call search_heu#definition_search_cpp(expand('<cword>'))<cr>
autocmd Filetype c,cpp nnoremap <silent> <buffer> <leader>l :call search_heu#usage_search_cpp(expand('<cword>'))<cr>

autocmd Filetype python nnoremap <silent> <buffer> <leader>j :call search_heu#definition_search_python(expand('<cword>'))<cr>
autocmd Filetype python nnoremap <silent> <buffer> <leader>l :call search_heu#usage_search_python(expand('<cword>'))<cr>

let &cpoptions = s:save_cpo
unlet s:save_cpo
