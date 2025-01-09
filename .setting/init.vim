" init.vim
" Author: Seongho Kim
" Email: seongho-kim@yonsei.ac.kr
" Date: 2024-11-04
" Description: This is the simple configuration file for Neovim
" influenced by NeuralNine

" set nocompatible            " disable compatibility to old-time vi
set showmatch               " highlight matching [{()}]
set number                  " show line numbers
" set relativenumber          " show relative line numbers

set mouse=a                 " enable mouse click
"set cursorline              " highlight current line
set clipboard=unnamedplus   " use system clipboard

set ignorecase              " ignore case when searching
set hlsearch                " highlight search

set autoindent              " copy indent from current line
set tabstop=4               " number of columns occupied by a tab
set shiftwidth=4            " number of spaces for autoindent
set smarttab                " use shiftwidth spaces instead of tab
set expandtab               " converts tabs to white space

filetype plugin indent on   "allow auto-indenting depending on file type
syntax on                   " syntax highlighting
filetype plugin on
" set spell                 " enable spell check
" set noswapfile            " disable creating swap file
" set backupdir=~/.cache/vim " Directory to store backup files.

set encoding=utf-8          " set encoding to utf-8

call plug#begin()
 
 " Neovim plugins
 Plug 'mhinz/vim-startify' " Start screen
 Plug 'nvim-lualine/lualine.nvim' " Status line
 Plug 'akinsho/bufferline.nvim', { 'tag': '*' } " Buffer line
 Plug 'tc50cal/vim-terminal' " NVim Terminal
 
 " Neovim settings
 Plug 'projekt0n/github-nvim-theme' " Theme
 Plug 'nvim-tree/nvim-web-devicons' " Icons
 
 " NERDTree settings
 Plug 'scrooloose/nerdtree' " File tree
 Plug 'SirVer/ultisnips' " Snippet engine
 Plug 'honza/vim-snippets' " Snippets
 Plug 'preservim/nerdcommenter' " Commenting plugin
 
 " Neovim LSP for commands
 Plug 'tpope/vim-fugitive' " Git wrapper
 
 " Code writing helpers
 Plug 'tpope/vim-surround' " Surround text with tags
 Plug 'tpope/vim-commentary' " Commenting gcc and gc
 Plug 'preservim/nerdcommenter' " Commenting plugin
 Plug 'preservim/tagbar' " Tagbar about the code structure
 
 Plug 'terryma/vim-multiple-cursors' " Multiple cursors

call plug#end()

colorscheme github_dark_dimmed " Set theme

let g:airline_powerline_fonts = 1 " Use powerline fonts
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" NERDTree settings
let NERDTreeShowFiles=1 " Show files
let NERDTreeShowHidden=1 " Show hidden files
let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"

" Map <Del> key for normal and insert mode (optional)
nnoremap <C-d> x
inoremap <C-d> <C-o>x

" NERDTree keybindings
nnoremap <C-z> :u<CR> " Undo with Ctrl+z
nnoremap <C-s> :w<CR> " Save with Ctrl+s
nnoremap <C-a> :qa<CR> " Quit with Ctrl+q
nnoremap <C-q> :q<CR> " Quit all with Ctrl+a
nnoremap <C-t> :NERDTreeToggle<CR> " Toggle NERDTree
nnoremap <A-t> :terminal<CR> " Open terminal with Alt+t
nnoremap <C-j> :call CocActionAsync('jumpDefinition')<CR> " Go to definition with Ctrl+l
nnoremap <C-o> :tabnew<CR> " Open new tab
nnoremap <C-p> :tabnext<CR> " Go to next tab

" refresh nvim
nnoremap <F5> :source $MYVIMRC<CR> " Refresh nvim
nmap <F8> :TagbarToggle<CR> " Toggle Tagbar

lua << EOF
require('github-theme').setup({
  options = {
    styles = {
      comments = 'italic',
      keywords = 'bold',
      types = 'italic,bold',
    }
  }
})

require('lualine').setup {
  options = {
    theme = 'github_dark_dimmed',
  }
}

require('bufferline').setup {
  options = {
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local icon = level:match("error") and " " or " "
      return " " .. icon .. count
    end
  }
}
EOF

" NeoVim Commands
" :q      " quit
" :q!     " quit without saving
" :w      " save
" :wq     " save and quit
" :u      " undo
" Ctrl+r  " redo
" +y      " copy to clipboard (visual mode)
" +p      " paste from clipboard
" Ctrl+w  " switch windows
" Ctrl+w+w " switch windows
" Ctrl+w+arrow " switch windows
" Ctrl+w+v " split vertically
" Ctrl+w+s " split horizontally

" Plugin commands
" :PlugInstall " Install plugins
" :PlugClean " Remove unused plugins
" :PlugUpdate " Update plugins

" Commenting commands
" gcc     " comment line
" gc      " comment visual selection
" gcgc    " toggle comment line

" Find commands
" /       " search forward
" ?       " search backward
" n       " next search result
