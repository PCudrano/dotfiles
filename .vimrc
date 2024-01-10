" COPY THIS FILE AS .vimrc in home folder.
" Paolo Cudrano 2024
"
" Adapted from:
" Smylers's .vimrc
" http://www.stripey.com/vim/
" 
" 2000 Jun  1: for `Vim' 5.6



" * User Interface

" have syntax highlighting in terminals which can display colours:
if has('syntax') && (&t_Co > 2)
  syntax on
endif

" display the current mode and partially-typed commands in the status line:
set showmode
set showcmd

" * Text Formatting -- General

" use indents of 2 spaces, and have them copied down lines:
set shiftwidth=2
set shiftround
set expandtab
set autoindent

" wrap lines:
set wrap

" display line numbers:
set number

set formatoptions-=t
set textwidth=99

" * Text Formatting -- Specific File Formats

" enable filetype detection:
filetype on

" for C-like programming, have automatic indentation:
autocmd FileType c,cpp,slang set cindent

" for actual C (not C++) programming where comments have explicit end
" characters, if starting a new line in the middle of a comment automatically
" insert the comment leader characters:
autocmd FileType c set formatoptions+=ro

" make searches case-insensitive, unless they contain upper-case letters:
" set ignorecase
" set smartcase

" show the `best match so far' as search strings are typed:
set incsearch

" * Keystrokes -- Moving Around

" have the h and l cursor keys wrap between lines (like <Space> and <BkSpc> do
" by default), and ~ covert case over line breaks; also have the cursor keys
" wrap in insert mode:
" set whichwrap=h,l,~,[,]

