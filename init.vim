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

augroup NetrwListing
    autocmd!
    autocmd! FileType netrw setlocal nonumber norelativenumber bufhidden=wipe colorcolumn=0
augroup end

" Plugins ----------------------------------------------------------------------
set rtp+=/local/data/dotfiles/plugins/colorscheme
let g:bgc_enable_statusline_customization = 1
colorscheme bgc

set rtp+=/local/data/dotfiles/plugins/cword_hl
set rtp+=/local/data/dotfiles/plugins/fsp
set rtp+=/local/data/dotfiles/plugins/git_fn
set rtp+=/local/data/dotfiles/plugins/min_compl
set rtp+=/local/data/dotfiles/plugins/quickfix_cust
set rtp+=/local/data/dotfiles/plugins/search_heu
set rtp+=/local/data/dotfiles/plugins/syntax_imp

set rtp+=/local/data/dotfiles/plugins/task_exec
command! -nargs=0 Make StartQfTask make
command! -nargs=0 CTex execute('StartQfTask pdflatex -interaction=nonstopmode '.expand('%'))

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
set nowritebackup               " Do not write backup
set noswapfile                  " Turn swapping off

set hidden                      " A buffer becomes hidden when it is abandoned
set noequalalways               " Do not resize windows

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

set path=.,,**,/usr/include/  " Paths for file searching

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

" Json pretty printer ----------------------------------------------------------
if executable('python')
    command! -range Jsonpp execute(<line1>.','.<line2>.'!python -m json.tool')
endif

" Print the full path of the current file
command! -nargs=0 Pf echo expand('%:p')

" Start profiling
command! -nargs=1 StartProfiling profile start <args> | profile func * | profile file *

"=============================== Functions =====================================
" Keep window open at buffer deleting ------------------------------------------
function! s:erase_buffer()
    let buf_num = bufnr('%')

    if len(getbufinfo()) == 1
        enew
    elseif bufnr('$') == buf_num
        bprevious
    else
        bnext
    endif

    if bufexists(buf_num)
        execute('bwipeout! '.buf_num)
    endif
endfunction

command! -nargs=0 Bc call s:erase_buffer()
command! -nargs=0 Bca %bwipeout!

nnoremap <silent> <leader>q :Bc<cr>

" Clean trailing whitespaces and last empty lines ------------------------------
function! s:delete_trailing_whitespaces()
    let current_line = line('.')
    let current_col = col('.')

    %s/\s\+$//ge
    call cursor(current_line, current_col)
endfunction

augroup WsCleaner
    autocmd!
    autocmd BufWrite * call s:delete_trailing_whitespaces()
augroup end
