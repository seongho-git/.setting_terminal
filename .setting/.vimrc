set nocompatible " Disable Vi compatibility mode for enhanced features
filetype off " Disable filetype detection temporarily
set rtp+=~/.fzf " Add fzf to runtime path

call plug#begin()
Plug 'Valloric/YouCompleteMe' "Code completion
" Plug 'NLKNguyen/papercolor-theme' " Color scheme
Plug 'vim-airline/vim-airline' " Status bar
Plug 'morhetz/gruvbox' " Color scheme

Plug 'scrooloose/nerdtree' " File explorer
Plug 'yssl/AutoCWD.vim' " Auto change directory
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy finder
Plug 'junegunn/fzf.vim' " Vim plugin for fzf
Plug 'Chiel92/vim-autoformat' " Autoformat
Plug 'rhysd/vim-clang-format' " Clang format
Plug 'tc50cal/vim-terminal' " Terminal

Plug 'tpope/vim-fugitive' " Git integration
Plug 'mhinz/vim-signify' " Show git diff in the gutter
Plug 'mbbill/undotree' " Visualize undo tree

Plug 'jiangmiao/auto-pairs' " Auto pairs
Plug 'vim-scripts/DoxygenToolkit.vim' " Doxygen toolkit
Plug 'chrisbra/vim-commentary' " Commenting
Plug 'antiagainst/vim-tablegen' " Tablegen syntax highlighting
call plug#end()
filetype plugin indent on " Enable filetype detection

" set shell=/bin/zsh " Set shell to zsh
set encoding=utf-8
set mouse=a " Enable mouse
set hlsearch " Highlight search
set nu " Show line numbers
" set autoindent " Enable auto indent
" set cindent " Enable C indent
" set scrolloff=2 " Scroll offset
" set wildmode=longest,list " Command line tab completion
set ts=4 " Tab size
" set sw=4 " Shift width
" set autoread " Auto read file changes
" set autowrite " Auto write file changes
" set bs=eol,start,indent " Backspace behavior
" set history=256 " Command history
" set paste " Enable paste mode
" set shiftwidth=4 " Indentation size
" set showmatch " Show matching brackets
" set smartcase " Consider case in search
" set smarttab
" set smartindent
" set softtabstop=2
" set tabstop=2
" set ruler " Show cursor position
set incsearch " Incremental search
" set statusline=\ %<%l:%v\ [%P]%=%a\ %h%m%r\ %F\
" set expandtab " Indents <Tab> as spaces
set wrap " wrap lines
set breakindent " indent with wrap
set laststatus=2 " Always show status bar
set sessionoptions-=blank " Don't save empty windows

" Map <Del> key for normal and insert mode (optional)
nnoremap <C-d> x
inoremap <C-d> <C-o>x

" Colorscheme
" colorscheme PaperColor
" let g:github_colors_soft = 1
" let g:github_colors_block_diffmark = 1
colorscheme gruvbox
set background=dark
" let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_bold = 1
let g:gruvbox_italic = 1

au BufReadPost *
						\ if line("'\"") > 0 && line("'\"") <= line("$") |
						\ exe "norm g`\"" |
						\ endif
if $LANG[0]=='k' && $LANG[1]=='o'
		set fileencoding=korea
endif

" Syntax highlighting
if has("syntax")
		syntax on
endif

" Python
if has("python")
		python3 import sys
endif

" Configure persistent undo if available
if has("persistent_undo")
		let target_path = expand('~/.undodir')
		" create the directory and any parent directories
		" if the location does not exist.
		if !isdirectory(target_path)
				call mkdir(target_path, "p", 0700)
		endif

		let &undodir=target_path
		set undofile
		set undolevels=500
		set undoreload=10000
endif

" autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
" Filetype detection
autocmd BufNewFile,BufRead *.td setlocal filetype=tablegen
autocmd BufNewFile,BufRead *.ll setlocal filetype=llvm
autocmd BufNewFile,BufRead *rst setlocal filetype=rest

" Set Autoformat
" let g:formatterpath = ['/usr/bin/clang-format-14']
" noremap <F3> : Autoformat<CR>
" au BufWrite * :Autoformat
" let g:leave_my_textwidth_alone=1
" let g:autoformat_autoindent = 0
" let g:autoformat_retab = 0
" let g:autoformat_remove_trailing_spaces = 0
" let ftexclude = ['python', 'markdown', 'text', 'llvm']
" au BufWrite * if index(ftexclude, &ft) < 0 | :Autoformat
let extexclude = ['py', 'md', 'txt']
au BufWrite * if index(extexclude, expand('%:e')) < 0 | :Autoformat
" autocmd BufWrite *.md set noautoindent nosmartindent noautowrite nosmarttab

" LLVM File Format Setting
let g:markdown_fenced_languages = ['mlir']

" Fugitive
autocmd FileType gitcommit set foldmethod=syntax
autocmd FileType c, cpp, cuda ClangFormatAutoEnable

" Open Terminal Window at the right side
nnoremap <F9> :rightb term<CR>
nnoremap <F10> :rightb vert term<CR>

" Set up AutoPairs
" let g:AutoPairsFlyMode = )
let g:AutoPairsShortcutBackInsert='<C-b>'
let g:AutoPairsShortcutFastWrap='<C-e>'
autocmd FileType vim let g:AutoPairs = {}
autocmd FileType markdown let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '```':'```', '"""':'"""', "'''":"'''"}

" Set up shortcuts
let mapleader=","
let g:camelcasemotion_key = '<leader>'
let g:tex_flavor = "latex"

" Open and close NERDTree
nnoremap <F5> :NERDTreeToggle<CR> "Open and close NERDTreeToggle
nnoremap <F8> :NERDTreeFind<CR> "Find file in NERDTree
let NERDTreeShowHidden=1 " Show hidden files
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>r :NERDTreeRefreshRoot<CR>
let g:NERDTreeGitStatusIndicatorMapCustom = {
						\ 'Modified'  :'✹',
						\ 'Staged'    :'✚',
						\ 'Untracked' :'✭',
						\ 'Renamed'   :'➜',
						\ 'Unmerged'  :'═',
						\ 'Deleted'   :'✖',
						\ 'Dirty'     :'✗',
						\ 'Ignored'   :'☒',
						\ 'Clean'     :'✔︎',
						\ 'Unknown'   :'?',
						\ }

" You Complete Me
let g:ycm_confirm_extra_conf = 0
let &rtp .= ',' . expand( '<sfile>:p:h' )
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'
let g:ycm_enable_inlay_hints = 0
nnoremap <leader>g :YcmCompleter GoTo<CR>
nnoremap <leader>d :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>t :YcmCompleter GetType<CR>
nnoremap <leader>p :YcmCompleter GetParent<CR>
nnoremap <leader>rf :YcmCompleter GoToReferences<CR>
nnoremap <leader>f :YcmCompleter FixIt<CR>

" fzf.vim
set rtp+=~/.fzf
nnoremap <leader><leader>f :Files<CR>
nnoremap <leader><leader>g :GFiles?<CR>
nnoremap <leader><leader>b :Buffers<CR>
nnoremap <leader><leader>m :Marks<CR>
nnoremap <leader><leader>l :Lines<CR>
nnoremap <leader><leader>s :Snippets<CR>
nnoremap <leader><leader>c :Commits<CR>

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
						\ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

