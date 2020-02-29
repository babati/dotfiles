"============================= General config ==================================
" Disable language providers ---------------------------------------------------
let g:loaded_python_provider = 1
let g:loaded_python3_provider = 1
let g:loaded_ruby_provider = 1
let g:loaded_node_provider = 1

" Disable unused default plugins -----------------------------------------------
let g:loaded_gzip = 1
let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1

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

set wildmenu                    " Turn on command line completion
set wildignore=*.o,*~,*.pyc     " Ignore compiled files
set numberwidth=1               " Line number column width
set cmdheight=2                 " Height of the command bar
set laststatus=2                " Always show the status line
set backspace=eol,start,indent  " Configure backspace
set whichwrap+=<,>,h,l          " Continue cursor movement at line beggining and ending

set list                        " Show characters instead of whitespaces
set listchars=tab:\|\ ,space:.,extends:#,nbsp:. " Swap special characters

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

" Select current scope
nnoremap <silent> % :execute('normal va'.getline('.')[col('.')-1].'o')<cr>
vnoremap <silent> % o

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
nnoremap <silent> <leader>c :tabnew<cr>
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
augroup General
    autocmd!
    autocmd WinEnter * call execute('setlocal scrolloff='.(winheight(0) / 2))
augroup end

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
let g:c_cpp_header_extensions = ['h', 'hh', 'hpp', 'hxx']
let g:c_cpp_source_extensions = ['cpp', 'cc', 'cxx', 'c']

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

function! s:open_qf_window()
    botright copen
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
    cexpr []
    execute('silent grep! "'.a:pattern.'" '.getcwd())
    call s:open_qf_window()
endfunction

function! s:grep_in_current_file(pattern, filename)
    if !empty(a:filename)
        execute('silent vimgrep "'.a:pattern.'" '.a:filename)
        call s:open_qf_window()
    endif
endfunction

" Search in cwd for the given content
command! -nargs=+ Dg call s:grep_in_cwd('<args>')

" Search in cwd for work under cursor
noremap <silent> <f11> :call <sid>grep_in_cwd(expand('<cword>'))<cr>

" Search in current buffer
noremap <silent> <f12> :call <sid>grep_in_current_file(expand('<cword>'), expand('%'))<cr>

" Clean trailing whitespaces and last empty lines ------------------------------
function! s:delete_trailing_whitespaces()
    call s:execute_and_restore_pos('%s/\s\+$//ge')
endfunction

function! s:delete_last_empty_line()
    let line = getline('$')
    while line =~? '^\s*$'
        call s:execute_and_restore_pos('$delete _')
        let line = getline('$')
    endwhile
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

" Jump to file under cursor
nnoremap <silent> <f1> :call <sid>find_file(expand('<cfile>'))<cr>

" Switch between headers and source files
nnoremap <silent> <f4> :call <sid>switch_source_header_c_cpp()<cr>

" Quickfix window customization ------------------------------------------------
function! s:toggle_quickfix_window()
    if getwinvar(winnr('$'), '&buftype') == 'quickfix'
        cclose
    else
        call s:open_qf_window()
    endif
endfunction

augroup QfCustomization
    autocmd!
    autocmd FileType qf setlocal wrap nonumber norelativenumber colorcolumn=0 statusline=
    autocmd FileType qf wincmd J
    autocmd WinEnter * if winnr('$') == 1 && &buftype == "quickfix" | quit | endif
augroup end

noremap <silent> <f10> :call <sid>toggle_quickfix_window()<cr>

"-------------------------------------------------------------------------------
" Asyncron job runner, custom commands can be executed in the background.
" There are two types:
" - qf job: that's output is loaded into the quickfix window
"           control sequences and colorcodes are filtered out from the output
"           one can run at a time
" - daemon job: output is ignored, multiple instances can be executed simultanously

" Commands:
" - StartJob: start a 'qf job'
" - StartDaemon: start a 'daemon job'
" - StopRunningJobs: stop all running job
" - ShowRunningJob: show running qf job id
" - ShowRunningDaemons: show running daemon job ids
" - CTex: execute 'pdflatex' on the current file
" - Make: execute 'make' in the current working directory

" Mappings:
" <c-c> (in quickfix window): stop all running jobs
"-------------------------------------------------------------------------------
if has('nvim')

let g:jr_qf_job_id = 0
let g:jr_daemon_job_ids = []
let g:jr_scrolling = 1

function! s:jr_start_job(command, callbacks)
    return jobstart(split(a:command, '\s'), a:callbacks)
endfunction

function! s:jr_on_event_qf(job_id, data, event) dict
    let g:jr_scrolling = &filetype != 'qf' || line('.') == line('$')

    for line in a:data
        caddexpr substitute(line, '\%\x1b\[[0-9;]*[mKGHF]', '', 'g')
    endfor

    if g:jr_scrolling
        cbottom
    endif
endfunction

function! s:jr_on_exit_qf(job_id, data, event) dict
    let g:jr_qf_job_id = 0
    caddexpr '['.a:job_id.'] Exited with code '.a:data

    if g:jr_scrolling
        cbottom
    endif
endfunction

function! s:jr_start_qf_job(command)
    let s:jr_qf_callbacks = {
        \ 'on_stdout': function('s:jr_on_event_qf'),
        \ 'on_stderr': function('s:jr_on_event_qf'),
        \ 'on_exit': function('s:jr_on_exit_qf')
    \ }

    if g:jr_qf_job_id == 0
        cexpr []
        caddexpr a:command
        call s:open_qf_window()
        let g:jr_qf_job_id =s:jr_start_job(a:command, s:jr_qf_callbacks)
    else
        call s:log('[Async] A job is already runnning, id:'.g:jr_qf_job_id)
    endif
endfunction

function! s:jr_on_exit_daemon(job_id, data, event) dict
    let list_id = index(g:jr_daemon_job_ids, a:job_id)
    if list_id != -1
        call remove(g:jr_daemon_job_ids, list_id)
    endif
endfunction

function! s:jr_start_daemon(command)
    let s:jr_daemon_callbacks = {
        \ 'on_exit': function('s:jr_on_exit_daemon')
    \ }

    let job_id = s:jr_start_job(a:command, s:jr_daemon_callbacks)
    if job_id > 0
        call insert(g:jr_daemon_job_ids, job_id)
    endif
endfunction

function! s:jr_stop_running_jobs()
    if g:jr_qf_job_id != 0
        call jobstop(g:jr_qf_job_id)
        let g:jr_qf_job_id = 0
    endif

    for id in g:jr_daemon_job_ids
        call jobstop(id)
    endfor
    let g:jr_daemon_job_ids = []
endfunction

command! -nargs=+ StartJob call s:jr_start_qf_job('<args>')
command! -nargs=+ StartDaemon call s:jr_start_daemon('<args>')
command! -nargs=0 StopRunningJobs call s:jr_stop_running_jobs()
command! -nargs=0 ShowRunningJob call s:log('[Async] Running job id:'.(g:jr_qf_job_id > 0 ? g:jr_qf_job_id : 'NONE'))
command! -nargs=0 ShowRunningDaemons call s:log('[Async] Running daemons:'.(len(g:jr_daemon_job_ids) > 0 ? join(g:jr_daemon_job_ids, ',') : 'NONE'))

command! -nargs=0 CTex StartJob pdflatex %
command! -nargs=0 Make StartJob make

autocmd FileType qf nnoremap <silent> <c-c> :StopRunningJobs<cr>

endif

"-------------------------------------------------------------------------------
" Basic fuzzy file finder.
" There are two modes (automatic switching between modes):
" - fuzzy: matches on characters in the given order, but other characters can be inserted between them
" - strict: matches on exactly the given character sequence

" Commands/Mappings:
" - FsFindFiles (<leader>f): find files in the current directory recursively, filelist is loaded at the first execution
" - FsFindBuffers (<leader>u): find files which are already opened
" - FsFindLines (<leader>o): find lines in the current file
" - FsFindMru (<leader>m): find the recently used files
" - FsClearCache: clear filelist cache
"-------------------------------------------------------------------------------
let g:fs_files = []
let g:fs_mru_cache = []
let g:fs_number_of_matches = 10

function! s:fs_cache_files()
    if !empty(g:vc_git_branch)
        let search_cmd = 'cd '.shellescape(getcwd()).' && git ls-files -co'
    elseif executable('find')
        let search_cmd = 'find '.shellescape(getcwd())
    else
        call s:log('[FileFinder] No external commands are available to list files.')
        return
    endif

    let g:fs_files = systemlist(search_cmd)
endfunction

function! s:fs_get_matching_files(word, list, fuzzy)
    let result = []

    let pattern = (a:fuzzy ? join(split(a:word, '\zs'), '.\{-}') : a:word)
    for file in a:list
        if file =~? pattern
            call add(result, file)
        endif

        if len(result) == g:fs_number_of_matches
            return [pattern, result]
        endif
    endfor
    return [pattern, result]
endfunction

function! s:fs_cache_mru(file_with_line)
    let mru_id = index(g:fs_mru_cache, a:file_with_line)
    if mru_id != -1
        call remove(g:fs_mru_cache, mru_id)
    endif

    call add(g:fs_mru_cache, a:file_with_line)
endfunction

function! s:fs_open_file(line, mode)
    if empty(a:line)
        hide
        return
    endif

    let file_with_line = split(a:line, '\s')[0]
    let file_to_open = split(file_with_line, ':')

    call s:fs_cache_mru(file_with_line)

    hide

    if file_to_open[0][0] != '/'
        let file_to_open[0] = getcwd().'/'.file_to_open[0]
    endif
    execute(a:mode.' +'.(len(file_to_open) > 1 ? file_to_open[1] : 0).' '.fnameescape(file_to_open[0]))
endfunction

function! s:fs_fill_search_window(pattern, files)
    let number_of_lines = min([len(a:files),g:fs_number_of_matches])
    silent! put =a:files[:number_of_lines-1]
    call s:execute_and_restore_pos('1delete _')

    if number_of_lines != winheight(0)
        execute('resize '.number_of_lines)
        normal ggG " refresh the current view
    endif

    if !empty(a:pattern)
        syntax clear FsSearch
        execute('syntax match FsSearch "\c'.a:pattern.'"')
    endif

    redraw
endfunction

function! s:fs_find_files(name, list)
    cclose
    execute('below botright '.g:fs_number_of_matches.'new '.a:name)

    let current_word = ''

    call s:setup_scratch_buffer('filelist')
    call s:fs_fill_search_window(current_word, a:list)

    highlight! def link FsSearch Visual

    autocmd BufLeave <buffer> wincmd p

    while 1
        echo '> '.current_word

        let c = getchar()
        if type(c) == type(0)
            if c == 27 " 27 - <esc>
                hide
                call s:clear_cmd_line()
                break
            elseif c == 13 " <enter>
                call s:fs_open_file(getline('.'), 'edit')
                call s:clear_cmd_line()
                break
            elseif c == 22 " <c-v>
                call s:fs_open_file(getline('.'), 'vsplit')
                call s:clear_cmd_line()
                break
            elseif c == 10 " <c-j>
                call cursor(line('.') + 1, 1)
                redraw
                continue
            elseif c == 11 " <c-k>
                call cursor(line('.') - 1, 1)
                redraw
                continue
            elseif c >= 32 && c <= 126
                let next_char = nr2char(c)
                let current_word = current_word.next_char
            else
                call s:clear_cmd_line()
                redraw
                continue
            endif
        elseif c is# "\<del>" || c is# "\<backspace>"
            let current_word = current_word[:-2]
        else
            call s:clear_cmd_line()
            redraw
            continue
        endif

        if getchar(1)
            call s:clear_cmd_line()
            redraw
            continue
        endif

        call s:execute_and_restore_pos('%delete _')

        let [pattern, files] = s:fs_get_matching_files(escape(current_word, '.'), a:list, 0)

        if empty(files)
            let [pattern, files] = s:fs_get_matching_files(escape(current_word, '.'), a:list, 1)
        endif
        call s:fs_fill_search_window(pattern, files)
    endwhile

    highlight! def link FsSearch NONE
    syntax clear FsSearch
endfunction

command! -nargs=0 FsFindFiles if len(g:fs_files) == 0 | call s:fs_cache_files() | endif | call s:fs_find_files('[files]', g:fs_files)
command! -nargs=0 FsFindBuffers call s:fs_find_files('[buffers]', filter(map(copy(getbufinfo({'bufloaded':1})), 's:cut_working_dir(v:val.name)'), {idx, val -> strlen(val) > 0}))
command! -nargs=0 FsFindLines call s:fs_find_files('[lines]', map(getbufline(bufnr('%'), 1, '$'), 's:cut_working_dir(expand("%")).":".v:key." ".v:val'))
command! -nargs=0 FsFindMru call s:fs_find_files('[mru]', g:fs_mru_cache)
command! -nargs=0 FsClearCache let g:fs_files = [] | let g:fs_mru_cache = []

nnoremap <silent> <leader>f :FsFindFiles<cr>
nnoremap <silent> <leader>u :FsFindBuffers<cr>
nnoremap <silent> <leader>o :FsFindLines<cr>
nnoremap <silent> <leader>m :FsFindMru<cr>

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
let g:vc_git_branch = ''

if executable('git')

function! s:vc_get_git_branch()
   let git_branch = system('git rev-parse --abbrev-ref HEAD 2> /dev/null')
   return substitute(git_branch, '\n', '', 'g')
endfunction

function! s:vc_init_working_directory()
    let git_repo_root = system('git rev-parse --show-toplevel')
    if v:shell_error == 0
        execute('cd '.substitute(git_repo_root, '\n', '', 'g'))
        let g:vc_git_branch = s:vc_get_git_branch()
        set grepprg=git\ --no-pager\ grep\ -n\ --no-color\ -i\ $*
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

function! s:vc_git_show(commit_hash)
    enew
    execute('file [show '.a:commit_hash.']')
    call s:vc_fill_git_buffer('git',
                \ 'git show --pretty=fuller --stat '.a:commit_hash,
                \ 'git show --pretty=format:"" '.a:commit_hash)
    call cursor(1, 1)
endfunction

function! s:vc_git_show_inplace()
    let current_hash = substitute(split(getbufline(bufnr('%'), line('.'))[0], '\s')[0], '\^', '', '')
    quit
    call s:vc_git_show(current_hash)
    nnoremap <silent> <buffer> q :call <sid>erase_buffer(0)<cr>
endfunction!

function! s:vc_git_blame(current_file)
    let current_line = line('.') - 1

    set scrollbind

    42vnew [blame]
    call s:vc_fill_git_buffer('gitrebase', 'git blame -f -c '.a:current_file)

    nnoremap <silent> <buffer> <Enter> :call <sid>vc_git_show_inplace()<cr>
    nnoremap <silent> <buffer> q :q<cr>
    autocmd BufLeave <buffer> wincmd p | set noscrollbind

    call cursor(1, 1)
    execute('normal '.current_line.'j')

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
        call s:open_qf_window()
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
    if empty(g:vc_git_branch) || empty(a:filename) || !executable('grep')
        return
    endif

    let g:vc_git_branch = s:vc_get_git_branch()
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
" Completion engine, uses the builtin completefunc.
" Automatically shows the completion popup.
" Custom completion sources can registered in order to extend the completion.
" By default keyword completion is active, it caches the unique keywords from every document at open and write.

" Mappings:
" - <tab>: open popup or move to next item
" - <s-tab>: open popup or move to previous item
" - <cr>: accept completion
" - <esc>: cancel completion
" - <c-c>: accept/cancel completion
"-------------------------------------------------------------------------------
let g:ce_keywords = {  'a': [], 'b': [], 'c': [], 'd': [], 'e': [], 'f': [], 'g': [], 'h': [], 'i': [],
            \ 'j': [], 'k': [], 'l': [], 'm': [], 'n': [], 'o': [], 'p': [], 'q': [], 'r': [], 's': [],
            \ 't': [], 'u': [], 'v': [], 'w': [], 'x': [], 'y': [], 'z': [], '_': [],
            \ '0': [], '1': [], '2': [], '3': [], '4': [], '5': [], '6': [], '7': [], '8': [], '9': [] }
let g:ce_sources = []
let g:ce_max_items = 10
let g:ce_max_file_size = 512000 " bytes
let g:ce_completion_time_limit = 0.005 " sec
let g:ce_last_insertion = reltime()

set completeopt=menuone,noselect                " show popup with one match
set shortmess+=ac                               " hide completion message
call execute('set pumheight='.g:ce_max_items)   " max height of popup
set completefunc=CeCustomComplete

function! CeCustomComplete(findstart, base)
    return a:findstart ? <sid>ce_find_word_start() : <sid>ce_collect_matching_words(a:base)
endfunction

function! s:ce_register_source(fn)
    call add(g:ce_sources, a:fn)
endfunction

function! s:ce_find_word_start()
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~? '\w'
        let start -= 1
    endwhile
    return start
endfunction!

function! s:ce_keyword_source(base)
    let result = []
    if a:base[0] =~? '\w'
        for word in g:ce_keywords[tolower(a:base[0])]
            if word =~? '^'.a:base
                call add(result, { 'word': word, 'kind': 'ID' })
            endif
        endfor
    endif
    return result
endfunction

function! s:ce_collect_matching_words(base)
    let result = []
    for Fn in g:ce_sources
        let result += Fn(a:base)
    endfor
    return { 'words': result, 'refresh': 'always' }
endfunction

function! s:ce_cache_keywords()
    if getfsize(expand('%')) < g:ce_max_file_size
        let keywords = uniq(sort(split(join(getline(1,'$'), '\n'), '\W\+')))
        call map(keywords, 'add(g:ce_keywords[tolower(v:val[0])], v:val)')
        call map(g:ce_keywords, 'uniq(sort(v:val))')
    endif
endfunction

function! s:ce_is_completion_enabled(elapsed_time)
    return a:elapsed_time > g:ce_completion_time_limit &&
         \ !pumvisible() &&
         \ !(&buftype ==? 'nofile')
endfunction

function! s:ce_get_completion_type(current_char)
    let elapsed_time = reltimefloat(reltime(g:ce_last_insertion))
    let g:ce_last_insertion = reltime()
    if s:ce_is_completion_enabled(elapsed_time)
        if a:current_char =~? '\w'
            return "\<c-x>\<c-u>"
        elseif a:current_char == '/'
            return "\<c-x>\<c-f>"
        endif
    endif
    return ''
endfunction

function! s:ce_start_completion()
    call feedkeys(s:ce_get_completion_type(v:char))
endfunction

function! s:ce_tab_completion(direction)
    if pumvisible()
        return a:direction == 1 ? "\<c-p>" : "\<c-n>"
    else
        let line = getline('.')
        let col = col('.')

        if (col == 1) || (line[col - 2] =~? '\s')
            return "\<tab>"
        else
            return s:ce_get_completion_type(line[col - 2])
        endif
    endif

endfunction

function! s:ce_handle_esc()
    if pumvisible()
        return empty(get(v:completed_item, 'kind', '')) ? "\<c-e>\<esc>\<esc>" : "\<c-y>\<esc>\<esc>"
    else
        return "\<esc>"
    endif
endfunction

function! s:ce_handle_enter()
    if pumvisible()
        return empty(get(v:completed_item, 'kind', '')) ? "\<c-g>u\<cr>" : "\<c-y>"
    else
        return "\<cr>"
    endif
endfunction

augroup CompletionEngine
    autocmd!
    autocmd VimEnter * call s:ce_register_source(function('s:ce_keyword_source'))
    autocmd InsertEnter * let g:ce_last_insertion = reltime()
    autocmd InsertCharPre * call s:ce_start_completion()
    autocmd BufReadPost,BufWritePost * call s:ce_cache_keywords()
augroup end

inoremap <expr> <silent> <tab> <sid>ce_tab_completion(-1)
inoremap <expr> <silent> <s-tab> <sid>ce_tab_completion(1)
inoremap <expr> <silent> <cr> <sid>ce_handle_enter()
inoremap <expr> <silent> <esc> <sid>ce_handle_esc()
inoremap <expr> <silent> <c-c> pumvisible() ? "\<c-e>" : "\<c-c>"

"-------------------------------------------------------------------------------
" Gtags integration, works on c/c++ currently.
" Tag files are searched in g:tg_db_dir and lib tag files can be used from g:tg_lib_path.
" Tags can be used in completion.

" Commands:
" - UpdateTagDb: update currently used tag db
" - CreateSysTagDb: tag a library in the given path
" - LoadTagDb: detect tag db
" - ClearTagDb: delete currently used tag db
" - SearchTag: search tags for given name

" Mappings:
" - <leader>j: jump to tag under cursor
" - <leader>i: show tags matches under cursor
" - <leader>l: find usages of current tag under cursor
" - <leader>O: open file finder for tags of current file
"-------------------------------------------------------------------------------
if executable('gtags') && executable('global')

let g:tg_configured = 0
let g:tg_lib_path = '/local/data/env/vim/sys'
let g:tg_db_dir = ''
let g:tg_extensions = g:c_cpp_header_extensions + g:c_cpp_source_extensions

function! s:tg_set_env()
    let $GTAGSFORCECPP = 1
    let $GTAGSROOT = getcwd()
    let $GTAGSDBPATH = g:tg_db_dir

    let lib_tags = join(globpath(g:tg_lib_path, '*/', 0, 1), ':')
    let $GTAGSLIBPATH = lib_tags
endfunction

function! s:tg_detect_db()
    let g:tg_db_dir = '/local/data/env/vim/'.split(getcwd(), '\/')[-1]

    call s:tg_set_env()
    call s:ce_register_source(function('s:tg_completion_source'))
    if filereadable(g:tg_db_dir.'/GTAGS')
        let g:tg_configured = 1
        call s:log('[Gtags] Database is used from: '.g:tg_db_dir)
    endif
endfunction

function! s:tg_create_db(target_dir)
    call s:log('[Gtags] Creating tags for: '.a:target_dir)

    let lib_name = split(a:target_dir, '/')[-1]
    let db_dir = g:tg_lib_path.'/'.lib_name
    call mkdir(db_dir, 'p')

    if !filereadable(db_dir.'/GTAGS')
        let current_pwd = getcwd()
        execute('cd '.a:target_dir)

        let update_cmd = 'gtags '.db_dir
        call system(update_cmd)

        execute('cd '.current_pwd)

        let $GTAGSLIBPATH = $GTAGSLIBPATH.':'.db_dir
    endif
endfunction

function! s:tg_update_db(filename)
    if !filereadable(g:tg_db_dir.'/GTAGS')
        call mkdir(g:tg_db_dir, 'p')
        let update_cmd = 'gtags '.g:tg_db_dir
    else
        let update_cmd = 'global -u'
        if !empty(a:filename)
            let update_cmd .= ' --single-update="'.a:filename.'"'
        else
            call s:log('[Gtags] Updating tag database')
        endif
    endif

    call system(update_cmd)
    let g:tg_configured = 1
endfunction

function! s:tg_auto_update_db()
    if g:tg_configured
        let extension = expand('%:t:e')
        if index(g:tg_extensions, extension) != -1
            call s:tg_update_db(expand('%:p'))
        endif
    endif
endfunction

function! s:tg_clear_db()
    if g:tg_configured
        let tags_path = [g:tg_db_dir.'/GTAGS', g:tg_db_dir.'/GRTAGS', g:tg_db_dir.'/GPATH']

        let rm_cmd = 'rm -f '.join(tags_path, ' ')

        call inputsave()
        let confirm = input('Removing by "'.rm_cmd.'" ok? (y/n) ')
        call inputrestore()

        call s:clear_cmd_line()
        if confirm == 'y'
            let g:tg_configured = 0
            call system(rm_cmd)
            call s:log('[Gtags] Database has been removed from: '.g:tg_db_dir)
        endif
    endif
endfunction

function! s:tg_query_db(option, pattern)
    if g:tg_configured
        return systemlist('global -iq --result grep '.a:option.' '.a:pattern)
    endif

    return []
endfunction

function! s:tg_search_tag(option, pattern, jump)
    let result = s:tg_query_db(a:option, a:pattern)

    if !empty(result)
        if a:jump && len(result) == 1
            silent cexpr result
        else
            cgetexpr result
            call s:open_qf_window()
        endif
    endif
endfunction

function! s:tg_completion_source(base)
    return map(s:tg_query_db('-c', a:base), "{ 'word': v:val, 'kind': 'TAG' }")
endfunction

augroup TagDb
    autocmd!
    autocmd VimEnter * call s:tg_detect_db()
    autocmd BufWritePost * call s:tg_auto_update_db()
augroup end

command! -nargs=0 UpdateTagDb call s:tg_update_db('')
command! -nargs=1 -complete=dir CreateSysTagDb call s:tg_create_db('<args>')
command! -nargs=0 LoadTagDb call s:tg_detect_db()
command! -nargs=0 ClearTagDb call s:tg_clear_db()
command! -nargs=1 SearchTag call s:tg_search_tag('', '<args>', 0)

nnoremap <silent> <leader>j :call <sid>tg_search_tag('-d', expand('<cword>'), 1)<cr>
nnoremap <silent> <leader>i :call <sid>tg_search_tag('-s', expand('<cword>'), 0)<cr>
nnoremap <silent> <leader>l :call <sid>tg_search_tag('-r', expand('<cword>'), 0)<cr>
nnoremap <leader>g :SearchTag
nnoremap <silent> <leader>O :call <sid>fs_find_files('[tags]', map(<sid>tg_query_db('-f', expand('%:p')), "substitute(v:val, ':\(.*\):', ':\1 ', '')"))<cr>

endif

"-------------------------------------------------------------------------------
" Highlight cword in idle time.
" Cword searching does not jump to the next match.
" The visual selection can be searched just like cword.

" Mappings:
" - <f8>: turn of highlight
" - n: go to the next match
" - N: go to the previous match
" - #/*: search cword or selection
"-------------------------------------------------------------------------------
set updatetime=1000

augroup CwordHighlight
    autocmd!
    autocmd! CursorHold * call s:hl_highlight_cword()
    autocmd! CursorMoved,InsertEnter * highlight! def link EmphasizedCword NONE | syntax clear EmphasizedCword
augroup end

function! s:hl_highlight_cword()
    if &buftype == '' " normal buffer
        let current_char = getline('.')[col('.') - 1]
        let current_word = expand('<cword>')

        if current_word =~? current_char && current_word =~? '^\w\+$' && !(getreg('/') =~? current_word)
            highlight! def link EmphasizedCword Visual
            execute('match EmphasizedCword "\<'.current_word.'\>"')
        endif
    endif
endfunction

function! s:hl_turn_off()
    nohlsearch
    diffupdate
    call setreg('/', '')
endfunction

function! s:hl_next_match(key)
    if empty(getreg('/'))
        call setreg('/', histget('search', -1))
    endif
    call feedkeys(a:key, 'n')
endfunction

function! s:hl_search_visual_selection() range
    let start_pos = getpos("'<")
    let end_pos = getpos("'>")

    let lines = getline(start_pos[1], end_pos[1])
    let lines[-1] = strpart(lines[-1], 0, end_pos[2])
    let lines[0] = strpart(lines[0], start_pos[2] - 1)

    return escape(join(lines, '\n'), '/.*$^~[]')
endfunction

nnoremap <silent> <f8> :call <sid>hl_turn_off()<cr>
nnoremap <silent> n :call <sid>hl_next_match('n')<cr>
nnoremap <silent> N :call <sid>hl_next_match('N')<cr>

nnoremap <silent> # :call setreg('/', '\<'.expand('<cword>').'\>')<cr>:call histadd('search', expand('<cword>'))<cr>:set hlsearch<cr>
nmap <silent> * #

vnoremap <silent> # :call setreg('/', <sid>hl_search_visual_selection())<cr>:call histadd('search', getreg('/'))<cr>:set hlsearch<cr>
vmap <silent> * #

"-------------------------------------------------------------------------------
" Minimalistic file browser
"-------------------------------------------------------------------------------
function! s:fb_get_line(path)
    let type = getftype(v:val)
    if type == 'dir'
        let filename = fnamemodify(v:val, ":h:t")
        let filename .= '/'
    else
        let filename = fnamemodify(v:val, ":t")
        if type == 'link'
            let filename .= '@'
        endif
    endif
    let stats = getfsize(v:val)." | ".strftime('%D-%T', getftime(v:val))

    let count = winwidth(0) - len(filename) - len(stats)
    return filename.repeat(' ', count).stats
endfunction

function! s:fb_load_file_list(path)
    setlocal modifiable
    %delete _

    let directories = globpath(fnameescape(a:path), '{.,}*', 1, 1)
    call map(directories, 's:fb_get_line(v:val)')
    silent! put =directories

    1delete _
    setlocal nomodifiable
endfunction

function! s:fb_refresh_file_list()
    call s:execute_and_restore_pos('call s:fb_load_file_list(b:fb_path)')
endfunction

function! s:fb_is_directory(path)
    return a:path =~ '\(\w\|\.\)\+/$'
endfunction

function! s:fb_open_file(path)
    if s:fb_is_directory(a:path)
        if a:path == './'
            return
        elseif a:path != '../'
            let b:fb_path .= '/'.a:path
        endif
        let b:fb_path = fnamemodify(b:fb_path, ':h')

        call s:fb_load_file_list(b:fb_path)
    else
        let file_to_open = b:fb_path.'/'.a:path
        execute('hide edit '.file_to_open)
    endif
endfunction

function! s:fb_delete_file(filename)
    let is_dir = s:fb_is_directory(a:filename)
    let full_path = b:fb_path.'/'.a:filename

    call inputsave()
    let confirm = input('Removing '.(is_dir ? 'directory' : 'file').': "'.full_path.'" ok? (y/n) ')
    call inputrestore()

    if confirm == 'y'
        call delete(fnameescape(full_path), 'rf')
        call s:fb_refresh_file_list()
    endif
endfunction

function! s:fb_rename_file(filename)
    let is_dir = s:fb_is_directory(a:filename)
    let full_path = b:fb_path.'/'.a:filename

    call inputsave()
    let new_filename = input('Moving '.(is_dir ? 'directory' : 'file').': ', full_path)
    call inputrestore()

    if !empty(new_filename)
        call rename(fnameescape(full_path), fnameescape(new_filename))
        call s:fb_refresh_file_list()
    endif
endfunction

function! s:fb_copy_file(filename)
    let is_dir = s:fb_is_directory(a:filename)
    let full_path = b:fb_path.'/'.a:filename

    call inputsave()
    let new_filename = input('Copying '.(is_dir ? 'directory' : 'file').': ', full_path, 'file')
    call inputrestore()

    if !empty(new_filename)
        call system('cp '.(is_dir ? '-a ' : '').full_path.' '.new_filename)
        call s:fb_refresh_file_list()
    endif
endfunction

function! s:fb_new_file()
    call inputsave()
    let new_filename = input('Creating new file: ', b:fb_path.'/')
    call inputrestore()

    if !empty(new_filename)
        call system('touch '.new_filename)
        call s:fb_refresh_file_list()
    endif
endfunction

function! s:fb_setup_syntax()
    syntax match FileBrowserDir '^\<\(\w\+\|\.\)\>\ze/'
    highlight! default link FileBrowserDir Type

    syntax match FileBrowserSymLink '^\<\(\w\|\.\)\+\>\ze@'
    highlight! default link FileBrowserSymLink Function
endfunction

function! s:fb_get_filename(line)
    return split(a:line, ' ', 0)[0]
endfunction

function! s:fb_setup_mappings()
    nnoremap <silent> <buffer> <Enter> :call <sid>fb_open_file(<sid>fb_get_filename(getline('.')))<cr>
    nnoremap <silent> <buffer> - :call <sid>fb_open_file('../')<cr>
    nnoremap <silent> <buffer> D :call <sid>fb_delete_file(<sid>fb_get_filename(getline('.')))<cr>
    nnoremap <silent> <buffer> R :call <sid>fb_rename_file(<sid>fb_get_filename(getline('.')))<cr>
    nnoremap <silent> <buffer> N :call <sid>fb_new_file()<cr>
    nnoremap <silent> <buffer> Y :call <sid>fb_copy_file(<sid>fb_get_filename(getline('.')))<cr>
    nnoremap <silent> <buffer> r :call <sid>fb_refresh_file_list()<cr>
    nnoremap <silent> <buffer> q :call <sid>erase_buffer(0)<cr>
endfunction

function! s:fb_determine_working_directory(path)
    let path = getcwd()
    if !empty(a:path)
        let path = fnamemodify(a:path, ':p:h')
    elseif !empty(expand('%:p:h'))
        let path = expand('%:p:h')
    endif

    return path
endfunction

function! s:fb_open_file_browser(path)
    let fb_path = s:fb_determine_working_directory(a:path)

    enew
    call s:setup_scratch_buffer('filebrowser')
    execute('file '.fb_path)

    call s:fb_setup_syntax()
    call s:fb_setup_mappings()

    let b:fb_path = fb_path

    call s:fb_load_file_list(b:fb_path)
endfunction

command! -nargs=? ExploreFileBrowser call s:fb_open_file_browser('<args>')

augroup FileBrowser
  autocmd!
  autocmd! VimEnter * if expand('%') == '' | call s:fb_open_file_browser('.') | endif
augroup end

"-------------------------------------------------------------------------------
" Simple buffer lister
"-------------------------------------------------------------------------------
function! s:bl_get_line(buffer)
    let name = s:cut_working_dir(a:buffer.name)
    let prop = (a:buffer.loaded ? 'loaded' : 'unloaded').' | '.a:buffer.bufnr

    let count = winwidth('.') - len(name) - len(prop)
    return name.repeat(' ', count).prop
endfunction

function! s:bl_load_buffer_list()
    setlocal modifiable
    %delete _

    let lines = map(filter(getbufinfo(), {idx, val -> v:val.bufnr != bufnr('%') }), 's:bl_get_line(v:val)')
    silent! put =lines

    1delete _
    setlocal nomodifiable
endfunction

function! s:bl_open_buffer(bufnr)
    if a:bufnr > 0
        execute('buffer '.a:bufnr)
    endif
endfunction

function! s:bl_wipe_buffer(bufnr)
    if a:bufnr > 0
        execute('bwipeout! '.a:bufnr)
        call s:bl_refresh_list()
    endif
endfunction

function! s:bl_refresh_list()
    call s:execute_and_restore_pos('call s:bl_load_buffer_list()')
endfunction

function! s:bl_get_bufnr(line)
    return empty(a:line) ? 0 : split(a:line, ' ', 0)[-1]
endfunction

function! s:bl_setup_mappings()
    nnoremap <silent> <buffer> <Enter> :call <sid>bl_open_buffer(<sid>bl_get_bufnr(getline('.')))<cr>
    nnoremap <silent> <buffer> D :call <sid>bl_wipe_buffer(<sid>bl_get_bufnr(getline('.')))<cr>
    nnoremap <silent> <buffer> r :call <sid>bl_refresh_list()<cr>
    nnoremap <silent> <buffer> q :call <sid>erase_buffer(0)<cr>
endfunction

function! s:bl_open_buffer_list(path)
    enew
    call s:setup_scratch_buffer('bufferlist')
    call s:bl_setup_mappings()
    call s:bl_load_buffer_list()
endfunction

command! -nargs=? BufferList call s:bl_open_buffer_list('<args>')

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
let s:color_grey1 = '16'
let s:color_grey2 = '233'
let s:color_grey3 = '237'
let s:color_grey4 = '251'
let s:color_grey5 = '238'
let s:color_grey6 = '234'

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
set statusline+=%2*\ \ %{g:vc_git_branch}\ \            " Branch
set statusline+=%3*\ %<%F                               " File
set statusline+=%3*\ %=\ %y\                            " FileType
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
    execute('highlight! Comment ctermfg='.s:color_grey3.' ctermbg='.s:nocolor.' cterm=none')
    execute('highlight! Constant ctermfg='.s:color_purple0.' ctermbg='.s:nocolor.' cterm=none')
    execute('highlight! CursorLineNr ctermfg='.s:color_grey5.' ctermbg='.s:nocolor.' cterm=none')
    highlight! link Title CursorLineNr
    execute('highlight! DiffAdd ctermfg='.s:color_grey4.' ctermbg='.s:color_green1.' cterm=none')
    execute('highlight! DiffChange ctermfg='.s:color_grey3.' ctermbg='.s:color_blue0.' cterm=none')
    execute('highlight! DiffText ctermfg='.s:color_grey4.' ctermbg='.s:color_purple1.' cterm=none')
    execute('highlight! Error ctermfg='.s:color_grey0.' ctermbg='.s:color_red0.' cterm=none')
    highlight! link ErrorMsg Error
    highlight! link DiffDelete Error
    highlight! link SpellBad Error
    execute('highlight! Function ctermfg='.s:color_blue1.' ctermbg='.s:nocolor.' cterm=none')
    highlight! link ModeMsg Function
    highlight! link MoreMsg Function
    highlight! link Special Function
    execute('highlight! Identifier ctermfg='.s:color_blue0.' ctermbg='.s:nocolor.' cterm=none')
    execute('highlight! LineNr ctermfg='.s:color_grey6.' ctermbg='.s:nocolor.' cterm=none')
    execute('highlight! LongLineWarning ctermfg='.s:nocolor.' ctermbg='.s:nocolor.' cterm=none')
    highlight! link Ignore LongLineWarning
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
