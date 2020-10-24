"============================= General config ==================================
" Disable language providers ---------------------------------------------------
let g:loaded_python_provider = 1
let g:loaded_python3_provider = 1
let g:loaded_ruby_provider = 1
let g:loaded_node_provider = 1

" Disable unused default plugins -----------------------------------------------
let g:loaded_gzip = 1
let g:loaded_matchit = 1
" let g:loaded_matchparen = 1
" let g:loaded_netrw = 1
" let g:loaded_netrwPlugin = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1

" Netrw ------------------------------------------------------------------------
let g:netrw_banner = 0          " No header
let g:netrw_liststyle = 1       " List view
let g:netrw_browse_split = 0    " Open file in the same split
let g:netrw_altv = 1            " Right splitting
let g:netrw_winsize = 15        " Size is 15% of window
let g:netrw_fastbrowse = 1      " Re-use directory listing in remote browsing
let g:netrw_keepdir = 1         " Do not change cwd at browsing
let g:netrw_silent = 0          " File transfering is not silent
let g:netrw_special_syntax = 1  " Syntax highlight for special files

function! s:netrw_open(path)
    let win_width = winwidth(0)
    let g:netrw_maxfilenamelen = win_width - 42
    execute('edit '.(strlen(a:path) > 0 ? a:path : expand('%:p:h')))
endfunction

command! -nargs=? E call s:netrw_open('<args>')

augroup NetrwListing
  autocmd!
  autocmd! VimEnter * if expand('%') == '' | call s:netrw_open('.') | endif
  autocmd! FileType netrw setlocal nonumber norelativenumber bufhidden=wipe colorcolumn=0
augroup end

set rtp+=/local/data/dotfiles/fsp
set rtp+=/local/data/dotfiles/mcp
set rtp+=/local/data/dotfiles/tep
set rtp+=/local/data/dotfiles/quickfix_cust
set rtp+=/local/data/dotfiles/cword_hl

" LSP --------------------------------------------------------------------------
if has('nvim-0.5')

set rtp+=/local/data/env/vim/nvim-lspconfig/

lua << EOF
require'nvim_lsp'.clangd.setup{}
EOF

function! s:lsp_log()
    let logpath = v:lua.vim.lsp.get_log_path()
    execute('edit '.logpath)
endfunction

function! s:lsp_reload()
    lua vim.lsp.stop_client(vim.lsp.get_active_clients())
    edit
endfunction

command! -nargs=0 LspLog call <sid>lsp_log()
command! -nargs=0 LspReload call <sid>lsp_reload()

nnoremap <silent> <f4> <cmd> ClangdSwitchSourceHeader<cr>
nnoremap <silent> <space>j <cmd>lua vim.lsp.buf.declaration()<cr>
nnoremap <silent> <space>i <cmd>lua vim.lsp.buf.hover()<cr>
nnoremap <silent> <space>l <cmd>lua vim.lsp.buf.references()<cr>
nnoremap <silent> <space>O <cmd>lua vim.lsp.buf.document_symbol()<cr>
nnoremap <silent> <space>g <cmd>lua vim.lsp.buf.workspace_symbol()<cr>

autocmd Filetype c,cpp setlocal completefunc=v:lua.vim.lsp.omnifunc

endif

" Common config ----------------------------------------------------------------
let mapleader = ' '             " Set <leader> key
let g:mapleader = ' '

set nocompatible                " Be iMproved, required
filetype plugin on              " Enable filetype plugins
filetype indent on

syntax enable                   " Enable syntax highlighting
set t_Co=256                    " 256 color terminal
set synmaxcol=200               " Max column length for syntax highlighting

set history=9000                " Command line history
set notitle                     " Do not set window title

set autoread                    " Auto read when a file is changed
set modelines=0                 " No modelines (config lines) are checked
set showmode                    " Show mode on statusline
set showcmd                     " Show command on right hand side of statusline
set mouse=                      " Disable mouse
set scrolloff=4                 " Set n lines to the cursor

set wildmenu                    " Turn on command line completion
set wildignore=*.o,*~,*.pyc     " Ignore compiled files
set numberwidth=1               " Line number column width
set cmdheight=2                 " Height of the command bar
set laststatus=2                " Always show the status line
set backspace=eol,start,indent  " Configure backspace
set whichwrap+=<,>,h,l          " Continue cursor movement at line beggining and ending

set list                        " Show characters instead of whitespaces
set listchars=tab:\|\ ,space:\ ,extends:#,nbsp:. " Swap special characters

set ignorecase                  " Ignore case when searching
set smartcase                   " Be case sensitive when upper case letter included

if executable('ag')             " If ag is available, use it as search engine
    set grepprg=ag\ --vimgrep\ -r\ $*
    set grepformat=%f:%l:%c:%m
endif

set hlsearch                    " Highlight search results
set incsearch                   " Incremental search

set lazyredraw                  " Don't redraw while executing macros
set magic                       " Turn regular expression magic on

set showmatch                   " Show matching brackets while inserting
set mat=2                       " Tenths of a second to blink when matching brackets

set noerrorbells                " No sound on errors
set novisualbell                " Disable visual bells
set t_vb=                       " Disable screen flashing
set tm=500                      " Timeout to complete a key mapping

set number                      " Absolute number on current line
set relativenumber              " Relative numbers on other lines
set cursorline                  " Highlight current line
set colorcolumn=80              " Show colored column

set encoding=utf8               " Set utf8 as standard encoding
set ffs=unix,dos,mac            " Use Unix as the default file type

set nobackup                    " Turn backup off
set nowb                        " Do not write backup
set noswapfile                  " Turn swapping off

set hidden                      " A buffer becomes hidden when it is abandoned

set expandtab                   " Use spaces instead of tabs
set smarttab                    " Be smart when using tabs
set shiftwidth=4                " 1 tab == 4 spaces in indentation
set tabstop=4                   " Space count for a tab
set showtabline=0               " Do not show tab bar on top of window
set nojoinspaces                " Insert one space only with join

set nowrap                      " Do not wrap lines
set tw=0                        " Do not break inserted lines

set noautoindent                " No auto indent
set smartindent                 " Smart indent

set nofoldenable                " No folding by default
set foldmethod=manual           " Syntax defines folding

"================================ Mappings =====================================
" 0 as first non-blank character
nnoremap 0 ^

" Saving
nnoremap <silent> <leader>w :w!<cr>

" Show registers
nnoremap <silent> <leader>r :registers<cr>

" Remove current line
nnoremap _ dd

" Move line
nnoremap + :m+<cr>
nnoremap - :m-2<cr>

" Move between windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Disable arrows in command, insert and visual mode
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Managing tabs
nnoremap <silent> <leader>c :cclose<cr>:lclose<cr>:tabnew<cr>
nnoremap <silent> <leader>xy :tabclose<cr>
nnoremap <silent> <leader>n :tabnext<cr>
nnoremap <silent> <leader>p :tabprevious<cr>
nnoremap <silent> <leader>t :tabs<cr>

" Splitting
nnoremap <silent> <leader>\| :vsplit<cr>
nnoremap <silent> <leader>- :split<cr>

" Update diff at change
nnoremap <silent> dp :diffput<cr> :diffupdate <cr>
nnoremap <silent> do :diffget<cr> :diffupdate <cr>

" Move around the buffers
nnoremap <silent> <f2> :bprevious <cr>
nnoremap <silent> <f3> :bnext <cr>

" Exit terminal
tnoremap <esc><esc> <c-\><c-n>

"=============================== Commands ======================================
" Open file at last position
autocmd BufReadPost * if line("'\"") >= 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif

" Enable spelling for tex files
autocmd FileType tex setlocal spell spelllang=en_us

" Custom make commands
command! -nargs=0 Make StartQfTask make
command! -nargs=0 CTex execute('StartQfTask pdflatex -interaction=nonstopmode '.expand('%'))

" Json pretty printer ----------------------------------------------------------
if executable('python')
    command! -range Jsonpp execute(<line1>.','.<line2>.'!python -m json.tool')
endif

" Print the full path of the current file
command! -nargs=0 Pf echo expand('%:p')

" Start profiling
command! -nargs=1 StartProfiling profile start <args> | profile func * | profile file *

"======================= Common config/functions ===============================
let g:log_file = ''

function! s:setup_scratch_buffer(type)
    execute('set filetype='.a:type)
    setlocal nonumber norelativenumber buftype=nofile bufhidden=wipe nobuflisted colorcolumn=0
endfunction

function! s:clear_cmd_line()
    redraw
    echo ' '
endfunction

function! s:cut_working_dir(path)
    return substitute(a:path, getcwd().'/','','')
endfunction

function! s:log(data) abort
    let line = strftime('%D-%T').' > '.a:data
    if !empty(g:log_file)
        call writefile([line], g:log_file, 'a')
    else
        echom line
    endif
endfunction

function! s:execute_and_restore_pos(command)
    let current_line = line('.')
    let current_col = col('.')

    execute(a:command)
    call cursor(current_line, current_col)
endfunction

"======================== Plugin like functions ================================
" Keep window open at buffer deleting ------------------------------------------
function! s:erase_buffer(wipe)
    let buf_num = bufnr('%')

    if len(getbufinfo()) == 1
        enew
    elseif bufnr('$') == buf_num
        bprevious
    else
        bnext
    endif

    if a:wipe && bufexists(buf_num)
        execute('bwipeout! '.buf_num)
    endif
endfunction

command! -nargs=0 Bc call s:erase_buffer(1)
command! -nargs=0 Bca %bwipeout!

nnoremap <silent> <leader>q :Bc<cr>

" Search pattern in files ------------------------------------------------------
function! s:grep_in_cwd(pattern)
    execute('silent grep! "'.a:pattern.'" '.getcwd())
    botright copen
endfunction

function! s:lgrep_in_cwd(pattern)
    execute('silent lgrep! "'.a:pattern.'" '.getcwd())
    silent! lopen
endfunction

function! s:grep_in_current_file(pattern, filename)
    if !empty(a:filename)
        execute('silent lvimgrep "'.a:pattern.'" '.a:filename)
        silent lopen
    endif
endfunction

" Search in cwd for the given content
command! -nargs=+ Dg call s:grep_in_cwd('<args>')
command! -nargs=+ Dgl call s:lgrep_in_cwd('<args>')

" Search in cwd for word under cursor
noremap <silent> <f11> :call <sid>lgrep_in_cwd(expand('<cword>'))<cr>

" Search in current buffer for word under cursor
noremap <silent> <f12> :call <sid>grep_in_current_file(expand('<cword>'), expand('%'))<cr>

" Regexp based definition search -----------------------------------------------
if !has('nvim-0.5')

let g:cpp_type_definition_pattern = '\(\(\(\<struct\>\)\|\(\<class\>\)\|\(\<enum\>\)\) \+\<$*\>\)\|\(\<using\> \+\<$*\> \+=\)\|\(\<typedef\> .* \<$*\> *;\)'
let g:cpp_usage_pattern = '\<$*\>'
let g:cpp_function_pattern = '\<$*\> *('

let g:py_type_definition_pattern = 'class \+\<$*\>'
let g:py_type_usage_pattern = '\<$*\>'
let g:py_function_definition_pattern = 'def \+\<$*\> *('
let g:py_function_usage_pattern = '\<$*\> *('

function! s:definition_search(word, pattern, fallback_pattern)
    call s:lgrep_in_cwd(a:word)

    let target_pattern = substitute(a:pattern, '\$\*', a:word, 'g')
    let content = filter(getloclist(0), 'v:val["text"] =~? target_pattern')

    if empty(content) && !empty(a:fallback_pattern)
        let target_pattern = substitute(a:fallback_pattern, '\$\*', a:word, 'g')
        let content = filter(getloclist(0), 'v:val["text"] =~? target_pattern')
    endif

    call setloclist(0, content)
endfunction

autocmd Filetype c,cpp noremap <silent> <buffer> <leader>j <cmd> call <sid>definition_search(expand('<cword>'), g:cpp_type_definition_pattern, g:cpp_function_pattern)<cr>
autocmd Filetype c,cpp noremap <silent> <buffer> <leader>l <cmd> call <sid>definition_search(expand('<cword>'), g:cpp_usage_pattern, '')<cr>

autocmd Filetype python noremap <silent> <buffer> <leader>j <cmd> call <sid>definition_search(expand('<cword>'), g:py_type_definition_pattern, g:py_function_definition_pattern)<cr>
autocmd Filetype python noremap <silent> <buffer> <leader>l <cmd> call <sid>definition_search(expand('<cword>'), g:py_function_usage_pattern, g:py_type_usage_pattern)<cr>

" Filename based header/source switching ---------------------------------------
let g:c_cpp_header_extensions = ['h', 'hh', 'hpp', 'hxx']
let g:c_cpp_source_extensions = ['cpp', 'cc', 'cxx', 'c']

function! s:check_file(extensions)
    let filename = expand('%:t:r')
    for ext in a:extensions
        if s:find_file(filename.'.'.ext) == 1
            break
        endif
    endfor
endfunction

function! s:switch_source_header_c_cpp()
    let current_extension = expand('%:e')
    if index(g:c_cpp_source_extensions, current_extension) != -1
        call s:check_file(g:c_cpp_header_extensions)
    elseif index(g:c_cpp_header_extensions, current_extension) != -1
        call s:check_file(g:c_cpp_source_extensions)
    endif
endfunction

autocmd Filetype c,cpp nnoremap <silent> <f4> :call <sid>switch_source_header_c_cpp()<cr>

endif

" Clean trailing whitespaces and last empty lines ------------------------------
function! s:delete_trailing_whitespaces()
    call s:execute_and_restore_pos('%s/\s\+$//ge')
endfunction

function! s:delete_last_empty_line()
    if getline('$') =~? '^\s*$'
        call s:execute_and_restore_pos('$delete _')
    endif
endfunction

augroup WsCleaner
    autocmd!
    autocmd BufWrite * call s:delete_trailing_whitespaces()
    autocmd BufWrite * call s:delete_last_empty_line()
augroup end

" Find files in working directory ----------------------------------------------
function! s:find_file(filename)
    let result = findfile(a:filename, getcwd().'/**')
    if !empty(result)
        execute('edit '.result)
        return 1
    endif
endfunction

" Jump to file under cursor
nnoremap <silent> <f1> :call <sid>find_file(expand('<cfile>'))<cr>

"-------------------------------------------------------------------------------
" Version control (git) helper functions.
" The current working directory is set to the repository root if the editor was opened in one.

" Commands:
" - Gblame: show blame information for the current file
" - Gvdiff: show the current file compared to a given revision
" - Gmerge: find conflicting files and load them into the quickfix window

" Mappings:
" - q: close current view
" - <enter>: show commit in blame view
"-------------------------------------------------------------------------------
if executable('git')

let g:vc_git_configured = v:false

function! s:vc_init_working_directory()
    let git_repo_root = system('git rev-parse --show-toplevel')

    if v:shell_error == 0
        execute('cd '.substitute(git_repo_root, '\n', '', 'g'))
        let g:vc_git_configured = v:true
        set grepprg=git\ --no-pager\ grep\ -n\ -E\ --no-color\ -i\ $*
        set grepformat=%f:%l:%m
    endif

    unlet git_repo_root
endfunction

function! s:vc_fill_git_buffer(filetype, ...)
    call s:setup_scratch_buffer(a:filetype)

    for cmd in a:000
        let output = system(cmd)
        silent! put =output
    endfor

    call s:execute_and_restore_pos('1delete _')
    setlocal nomodifiable
endfunction!

function! s:vc_git_show_inplace(current_file, current_line)
    let commit_hash = substitute(split(getbufline(bufnr('%'), line('.'))[0], '\s')[0], '\^', '', '')
    quit

    enew

    let b:current_file = a:current_file
    let b:current_line = a:current_line

    execute('file [show '.commit_hash.']')
    call s:vc_fill_git_buffer('git',
                \ 'git show --pretty=fuller --stat '.commit_hash,
                \ 'git show --pretty=format:"" '.commit_hash)
    call cursor(1, 1)

    nnoremap <silent> <buffer> q :execute('edit +'.b:current_line.' '.b:current_file)<cr>
endfunction!

function! s:vc_git_blame(current_file)
    let current_line = line('.')

    set scrollbind

    42vnew [blame]
    call s:vc_fill_git_buffer('gitrebase', 'git blame -f -c '.a:current_file)

    let b:current_file = a:current_file
    let b:current_line = current_line

    nnoremap <silent> <buffer> <Enter> :call <sid>vc_git_show_inplace(b:current_file, b:current_line)<cr>
    nnoremap <silent> <buffer> q :q<cr>
    autocmd BufLeave <buffer> wincmd p | set noscrollbind

    call cursor(1, 1)
    execute('normal '.(current_line-1).'j')

    set scrollbind
    syncbind
endfunction

function! s:vc_git_diff(current_file, revision)
    let filetype = &filetype
    let current_line = line('.')
    diffthis

    execute('vnew [diff '.(empty(a:revision) ? 'HEAD' : a:revision).']')
    call s:vc_fill_git_buffer(filetype, 'git show '.a:revision.':'.s:cut_working_dir(a:current_file))
    diffthis

    nnoremap <silent> <buffer> q :diffoff!<cr>:q<cr>
endfunction

function! s:vc_git_merge()
    let conflicting_files = systemlist('git diff --no-ext-diff --no-color --name-only --diff-filter=U')
    cexpr []

    if !empty(conflicting_files)
        for file in conflicting_files
            let markers = systemlist(substitute(&grepprg, '\$\*', '"<<<<<<<" '.file, ''))
            if !empty(markers)
                caddexpr markers[0]
            endif
        endfor
        botright copen
    else
        call s:log('[Git] No conflicting file has been found.')
    endif
endfunction

sign define Added text=+ texthl=Structure
sign define Modified text=~ texthl=Type
sign define Removed text=_ texthl=WarningMsg

function! s:vc_extract_changes_from_diff(diff_line)
    let splitted = split(a:diff_line, ',')
    let line = splitted[0]
    let count = len(splitted) > 1 ? splitted[1] : 1
    return count ? range(line, line + count - 1) : []
endfunction

function! s:vc_place_signs(name, filename, processed, others)
    for line in a:processed
        if empty(a:others) || (line < a:others[0] || line > a:others[-1])
            execute('sign place 1 line='.line.' name='.a:name.' file='.a:filename)
        else
            execute('sign place 1 line='.line.' name=Modified file='.a:filename)
        endif
    endfor
endfunction

function! s:vc_collect_signs(filename)
    if !g:vc_git_configured || empty(a:filename) || !executable('grep')
        return
    endif

    execute('sign unplace * file='.a:filename)

    let result = systemlist('git diff --no-ext-diff --no-color --unified=0 HEAD -- '.a:filename.' 2> /dev/null | grep -e "^@@"')
    for change in result
        let status = split(split(change, '@@')[0], '\s')
        let deleted_lines = s:vc_extract_changes_from_diff(status[0][1:])
        let added_lines = s:vc_extract_changes_from_diff(status[1][1:])

        call s:vc_place_signs('Removed', a:filename, deleted_lines, added_lines)
        call s:vc_place_signs('Added', a:filename, added_lines, deleted_lines)
    endfor
endfunction

augroup GitWorkingDirectory
    autocmd!
    autocmd VimEnter * call s:vc_init_working_directory()
    autocmd BufReadPost,BufWritePost * call s:vc_collect_signs(expand('%:p'))
augroup end

command! -nargs=0 Gblame call s:vc_git_blame(expand("%"))
command! -nargs=? Gvdiff call s:execute_and_restore_pos('call s:vc_git_diff(expand("%"), "<args>")')
command! -nargs=0 Gmerge call s:vc_git_merge()

endif

"-------------------------------------------------------------------------------
" Syntax highlight improvements.
" - c: member function calls, members
" - c++: member function calls, members, scopes
" - python: member functions calls, members
"-------------------------------------------------------------------------------
function! s:enhance_c_highlight()
    " Member
    syntax match CClassMember '\(\.\|->\)\zs\<\w\+\>\ze\s*[^(]'
    highlight! default link CClassMember Identifier

    " Function call
    syntax match CFunctionCall '\(\.\|->\)\?\zs\<\w\+\>\ze\s*('
    highlight! default link CFunctionCall Function

    " Trailing whitespace
    syntax match CTrailingWhiteSpace '\s\+$'
    highlight! default link CTrailingWhiteSpace Visual
endfunction

function! s:enhance_cpp_highlight()
    " Scopes
    syntax match CppScopedType '::\s*\zs\<\w\+\>\ze\s*[^:]'
    highlight! default link CppScopedType Type

    syntax match CppScope '\<\w\+\>\ze\s*::'
    highlight! default link CppScope Constant

    call s:enhance_c_highlight()
endfunction

function! s:enhance_python_highlight()
    " Member
    syntax match PyClassMember '\.\zs\<\w\+\>'
    highlight! default link PyClassMember Identifier

    " Function call
    syntax match PyFunctionCall '\.\?\zs\<\w\+\>\ze\s*('
    highlight! default link PyFunctionCall Function

    " Self
    syntax keyword PySelf self
    highlight! default link PySelf Type
endfunction

augroup EnhancedSyntaxHighlight
    autocmd!
    autocmd Syntax c call s:enhance_c_highlight()
    autocmd Syntax cpp call s:enhance_cpp_highlight()
    autocmd Syntax python call s:enhance_python_highlight()
augroup end

" Colors -----------------------------------------------------------------------
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

" StatusLine customization -----------------------------------------------------
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

" Colorscheme ------------------------------------------------------------------
function! s:colorscheme() abort
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
endfunction

augroup Colors
    autocmd!
    autocmd VimEnter * call s:colorscheme()
augroup end
