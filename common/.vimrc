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

" indent with 4 spaces, never real tabs:
set tabstop=4                   " a tab is four spaces
set softtabstop=4               " when hitting <BS>, pretend like a tab is removed, even if spaces
set expandtab                   " insert spaces instead of tabs
set shiftwidth=4                " number of spaces to use for autoindenting
set shiftround                  " use multiple of shiftwidth when indenting with '<' and '>'
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set autoindent                  " always set autoindenting on
set copyindent                  " copy the previous indentation on autoindenting
set smartindent

set smarttab                    " insert tabs on the start of a line according to
                                "    shiftwidth, not tabstop
set scrolloff=4                 " keep 4 lines off the edges of the screen when scrolling

" wrap lines:
set wrap

" display line numbers:
set nonumber

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

set wildmenu                    " make tab completion for files/buffers act like bash
set wildmode=list:full          " show a list when pressing tab and complete
                                "    first full match
set wildignore=*.swp,*.bak,*.pyc,*.class

"set visualbell                  " don't beep
set noerrorbells                " don't beep
set showcmd                     " show (partial) command in the last line of the screen
                                "    this also shows visual selection info
