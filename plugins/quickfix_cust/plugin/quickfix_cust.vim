" File: quickfix_cust.vim
" Description: Quickfix window customization plugin
" License: MIT License

if exists("g:loaded_quickfix_cust") || v:version < 700
    finish
endif

let g:loaded_quickfix_cust = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" Commands
command! -nargs=0 ToggleQf call quickfix_cust#toggle_quickfix_window()
command! -nargs=0 ToggleLocList call quickfix_cust#toggle_loclist_window()

" Autocommands
augroup QuickfixCustomization
    autocmd!
    autocmd VimEnter * call quickfix_cust#initialize()
augroup end

" Mappings
if !hasmapto('ToggleLocList')
    noremap <silent> <unique> <f9> :ToggleLocList<cr>
endif

if !hasmapto('ToggleQf')
    noremap <silent> <unique> <f10> :ToggleQf<cr>
endif

let &cpoptions = s:save_cpo
unlet s:save_cpo
