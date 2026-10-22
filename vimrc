" Global variable
let g:mapleader = " "
let g:maplocalleader = "\\"

" Use Vim settings, rather than Vi settings.
set nocompatible

set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Print the line number in front of each line
set number
" Show the line number relative to the line with the cursor
set relativenumber

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Switch on highlighting the last used search pattern.
set hlsearch
" Do incremental searching when it's possible to timeout.
set incsearch

" Prevent that the langmap option applies to characters that result from a
" mapping.  If set (default), this may break plugins (but it's backward
" compatible).
set nolangremap

set nobackup	" do not keep a backup file, use versions instead

" Reload a file when it has been changed outside of vim
set autoread

" Enable the use of mouse
set mouse=a

" Set indents and tab
set softtabstop=4
set expandtab
set shiftwidth=4

" Ignore case in search patterns
set ignorecase
" Do not ignore case when the search pattern contains upper case characters
set smartcase

" Dealing with long lines
set wrap
set linebreak

" Don't use Q for Ex mode, use it for formatting.  Except for Select mode.
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

augroup vimStartup
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid, when inside an event handler
  " (happens when dropping a file on gvim), for a commit or rebase message
  " (likely a different one than last time), and when using xxd(1) to filter
  " and edit binary files (it transforms input files back and forth, causing
  " them to have dual nature, so to speak) or when running the new tutor
  autocmd BufReadPost *
    \ let line = line("'\"")
    \ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
    \      && index(['xxd', 'gitrebase', 'tutor'], &filetype) == -1
    \ |   execute "normal! g`\""
    \ | endif

  " Set the default background for putty to dark. Putty usually sets the
  " $TERM to xterm and by default it starts with a dark background which
  " makes syntax highlighting often hard to read with bg=light
  " undo this using:  ":au! vimStartup TermResponse"
  autocmd TermResponse * if v:termresponse == "\e[>0;136;0c" | set bg=dark | endif
augroup END

" Give a hint about how to get out the command line window.
augroup vimHints
  au!
  autocmd CmdwinEnter *
        \ echohl Todo |
        \ echo gettext('You discovered the command-line window! You can close it with ":q".') |
        \ echohl None
augroup END

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages.
packadd! matchit

" Manage plugins by vim-plug
call plug#begin()

Plug 'dense-analysis/ale'
Plug 'preservim/nerdtree'

call plug#end()

" Enable file type detection.
filetype plugin indent on

" Switch syntax highlighting on 
syntax enable

" ALE configuration
let g:ale_linters = {
  \ 'python': ['pyright', 'ruff'],
\ }
let g:ale_fixers = {
  \ 'python': ['ruff_format'],
\ }
let g:ale_completion_enabled = 1
let g:ale_python_auto_uv = 1
let g:ale_python_pyright_executable = 'basedpyright-langserver'
let g:ale_python_pyright_use_global = 1
let g:ale_python_ruff_executable = 'ruff'
let g:ale_python_ruff_use_global = 1
let g:ale_python_ruff_format_executable = 'ruff'
let g:ale_python_ruff_format_use_global = 1
