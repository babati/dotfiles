" File: bgc.vim
" Description: Blue gray colorscheme
" License: MIT License

let g:colors_name = "bgc"

highlight clear
syntax reset

set background=dark

let s:color_grey0 = '232'
let s:color_grey1 = '0'
let s:color_grey2 = '233'
let s:color_grey3 = '238'
let s:color_grey4 = '251'
let s:color_grey5 = '239'
let s:color_grey6 = '236'

let s:color_blue0 = '116'
let s:color_blue1 = '153'
let s:color_blue2 = '25'

let s:color_purple0 = '103'
let s:color_purple1 = '60'

let s:color_green0 = '151'
let s:color_green1 = '66'

let s:color_red0 = '131'

let s:nocolor = 'none'

execute('highlight! CursorColumn ctermfg='.s:nocolor.' ctermbg='.s:color_grey1.' cterm=none')
highlight! link ColorColumn CursorColumn
execute('highlight! CursorLine ctermfg='.s:nocolor.' ctermbg='.s:color_grey1.' cterm=none')
execute('highlight! CursorLineNr ctermfg='.s:color_grey4.' ctermbg='.s:nocolor.' cterm=none')
highlight! link Title CursorLineNr
execute('highlight! Comment ctermfg='.s:color_grey3.' ctermbg='.s:nocolor.' cterm=none')
execute('highlight! Constant ctermfg='.s:color_purple0.' ctermbg='.s:nocolor.' cterm=none')
execute('highlight! DiffAdd ctermfg='.s:color_grey4.' ctermbg='.s:color_green1.' cterm=none')
execute('highlight! DiffChange ctermfg='.s:color_grey3.' ctermbg='.s:color_blue0.' cterm=none')
execute('highlight! DiffText ctermfg='.s:color_grey4.' ctermbg='.s:color_purple1.' cterm=none')
execute('highlight! Error ctermfg='.s:color_grey4.' ctermbg='.s:color_red0.' cterm=none')
highlight! link ErrorMsg Error
highlight! link DiffDelete Error
highlight! link SpellBad Error
execute('highlight! Function ctermfg='.s:color_blue1.' ctermbg='.s:nocolor.' cterm=none')
highlight! link ModeMsg Function
highlight! link MoreMsg Function
highlight! link Special Function
execute('highlight! Identifier ctermfg='.s:color_blue0.' ctermbg='.s:nocolor.' cterm=none')
execute('highlight! LineNr ctermfg='.s:color_grey5.' ctermbg='.s:nocolor.' cterm=none')
execute('highlight! LongLineWarning ctermfg='.s:nocolor.' ctermbg='.s:nocolor.' cterm=none')
highlight! link Ignore LongLineWarning
execute('highlight! MatchParen  ctermfg='.s:color_grey4.' ctermbg='.s:color_green1.' cterm=none')
execute('highlight! NonText ctermfg='.s:color_grey2.' ctermbg='.s:nocolor.' cterm=none')
highlight! link VertSplit NonText
execute('highlight! Normal ctermfg='.s:color_grey4.' ctermbg='.s:color_grey0.' cterm=none')
highlight! link TabLine Normal
highlight! link Todo Normal
execute('highlight! Pmenu ctermfg='.s:color_grey5.' ctermbg='.s:color_grey2.' cterm=none')
execute('highlight! PmenuSel ctermfg='.s:color_grey4.' ctermbg='.s:color_grey3.' cterm=none')
execute('highlight! qfLineNr ctermfg='.s:color_blue2.' ctermbg='.s:nocolor.' cterm=none')
execute('highlight! Search ctermfg='.s:color_grey0.' ctermbg='.s:color_blue2.' cterm=none')
execute('highlight! SignColumn ctermfg='.s:nocolor.' ctermbg='.s:color_grey0.' cterm=none')
highlight! link FoldColumn SignColumn
execute('highlight! SpellCap ctermfg='.s:color_grey0.' ctermbg='.s:color_blue1.' cterm=none')
highlight! link SpellLocal SpellCap
execute('highlight! SpellRare ctermfg='.s:color_grey0.' ctermbg='.s:color_purple1.' cterm=none')
execute('highlight! Structure ctermfg='.s:color_green1.' ctermbg='.s:nocolor.' cterm=none')
highlight! link Operator Structure
highlight! link PreProc Structure
highlight! link Statement Structure
highlight! link diffAdded Structure
execute('highlight! StatusLine ctermfg='.s:color_grey3.' ctermbg='.s:color_grey0.' cterm=none')
highlight! link Folded StatusLine
execute('highlight! StatusLineNC ctermfg='.s:color_grey2.' ctermbg='.s:color_grey3.' cterm=none')
execute('highlight! String ctermfg='.s:color_green0.' ctermbg='.s:nocolor.' cterm=none')
highlight! link Question String
execute('highlight! Type ctermfg='.s:color_purple1.' ctermbg='.s:nocolor.' cterm=none')
highlight! link Directory Type
execute('highlight! Visual ctermfg='.s:nocolor.' ctermbg='.s:color_grey6.' cterm=bold')
execute('highlight! WarningMsg ctermfg='.s:color_red0.' ctermbg='.s:nocolor.' cterm=none')
highlight! link diffRemoved WarningMsg

" StatusLine customization -----------------------------------------------------
if get(g:, 'bgc_enable_statusline_customization', 0) == 1
    set statusline=
    set statusline+=%1*\ %m%r%w\                            " Modified,readonly
    set statusline+=%2*\ %y\                                " FileType
    set statusline+=%3*\ %<%F\ %=\                          " File
    set statusline+=%2*\ %{''.(&fenc\ ?&fenc:&enc).''}      " Encoding
    set statusline+=%2*\ [%{&ff}]\                          " FileFormat
    set statusline+=%1*\ \ %l/%L                            " Rownumber/total
    set statusline+=%1*\ :\ %c                              " Column number
    set statusline+=%1*\ [%p%%]\                            " Percent

    execute('highlight User2 ctermfg='.s:color_grey4.' ctermbg='.s:color_grey0.' cterm=none')
    execute('highlight User3 ctermfg='.s:color_grey4.' ctermbg='.s:color_grey2.' cterm=none')

    function! s:sl_change_color(mode)
        let current_color = s:color_blue2
        if a:mode == 'i'
            let current_color = s:color_purple1
        elseif a:mode == 'r'
            let current_color = s:color_green1
        endif
        execute('highlight User1 ctermfg='.s:color_grey4.' ctermbg='.current_color.' cterm=none')
    endfunction

    augroup StatusLineCustomization
        autocmd InsertEnter,InsertChange * call s:sl_change_color(v:insertmode)
        autocmd VimEnter,InsertLeave * call s:sl_change_color('c')
    augroup end
endif
