" Mark's super duper    _
" _ __   ___  _____   _(_)_ __ ___
"| '_ \ / _ \/ _ \ \ / / | '_ ` _ \
"| | | |  __/ (_) \ V /| | | | | | |
"|_| |_|\___|\___/ \_/ |_|_| |_| |_|

set title
set history=700
set background=dark

filetype plugin on
filetype indent on
syntax enable

let mapleader=" "
let maplocalleader=" "

set autoread        " automatically reload changed files
set wildmenu        " handy auto complete menu

set list
set listchars=tab:·\ ,trail:▂,extends:»,precedes:«
set infercase       " completion recognizes capitalization
set smartcase
set ignorecase
set incsearch       " search as you type
set hidden          " sometimes I don't want to save a buffer before switching away from it

set completeopt-=preview
set matchtime=1
set modeline
set modelines=5
set noswapfile
set scrolloff=8
set shiftwidth=4
set softtabstop=4
set spell
set tabstop=4

" install vim-plug
if !filereadable(expand('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !echo "Installing vim-plug..."
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
call plug#begin('~/.local/share/nvim/plugged')

" color schemes
Plug 'dylanaraps/wal.vim'

" syntax
Plug 'cakebaker/scss-syntax.vim'
Plug 'calviken/vim-gdscript3'
Plug 'ianks/vim-tsx'
Plug 'leafgarland/typescript-vim'
Plug 'lepture/vim-jinja'
Plug 'posva/vim-vue'

" functionality
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-commentary', "{{{
    nmap <leader>c <Plug>Commentary
    xmap <leader>c <Plug>Commentary
    omap <leader>c <Plug>Commentary
    nmap <leader>cc <Plug>CommentaryLine
"}}}
Plug 'tpope/vim-fugitive', "{{{
    map \b :Gblame<CR>
    map \l :Glog<CR>
    map \gs :Gstatus<CR>
"}}}
Plug 'carlitux/deoplete-ternjs', {'do': 'npm install -g tern'}
Plug 'w0rp/ale', "{{{
    let g:ale_linters = {
        \ 'c': ['clang'],
        \ 'cpp': ['clangx'],
        \ 'php': ['phpcs'],
        \ 'javascript': ['eslint'],
        \}
    let g:ale_python_pylint_options = '--load-plugins pylint_django'
    let g:ale_sign_error = '⬤'
"}}}
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline', "{{{
    let g:airline_symbols = {}
    let g:airline_symbols.branch = '⭠'
    let g:airline_symbols.readonly = '⭤'
    let g:airline_symbols.linenr = '⭡'
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_theme = 'wal'
"}}}
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
Plug 'easymotion/vim-easymotion', "{{{
    map <Leader><Leader> <Plug>(easymotion-prefix)
"}}}
if has('nvim')
	Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
else
	Plug 'Shougo/deoplete.nvim'
	Plug 'roxma/nvim-yarp'
	Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#sources#syntax#min_keyword_length = 2
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neosnippet.vim', "{{{
	let g:neosnippet#snippets_directory = '~/.vim/bundle/'.expand(fnamemodify($MYVIMRC, ':p:h').'/snippets/')
	let g:neosnippet#enable_snipmate_compatibility = 1
"}}}
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim',  "{{{
"}}}
call plug#end()

" key bindings
map <C-n> :bnext<CR>
map <C-p> :bprev<CR>
nmap <C-j> <C-W>j                   " faster window movement
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l
vmap <C-o> :sort<CR>                " sort lines in visual mode with ctrl-o
map <F7> mzgg=G`z<CR>               " autoformat document
nmap <leader>n :set invnumber<CR>   " toggle line numbers
vnoremap < <gv                      " stay in visual mode when shifting
vnoremap > >gv
nnoremap <leader>pu :PlugUpdate<CR> " vim-plug actions
nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>pc :PlugClean<CR>
nnoremap <leader>o :jumps<CR>       " show jumps list
nnoremap zn ]s                      " next misspelling
nnoremap zp [s                      " prev misspelling
nnoremap zf <Esc>1z=                " replace misspelling with first suggestion
nnoremap z! :set local spell!<CR>   " toggle spellcheck
nnoremap <leader>ve :e $MYVIMRC<CR> " quick open this file
if executable('rg')
    set grepprg='rg\ --vimgrep'     " use ripgrep if available
endif

" theme / visual
try
	colorscheme wal
catch
endtry
hi clear SpellBad                   " italicize misspellings
hi SpellBad gui=underline cterm=italic

" netrw
nnoremap \e :Lexplore!<CR>
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:netrw_winsize = 25
let g:netrw_browse_split = 4
augroup netrw_mapping
	autocmd!
	autocmd filetype netrw call NetrwMapping()
augroup END
function! NetrwMapping()
	noremap <buffer> \e :bd<CR>
endfunction

" read .vimlocal if available
if filereadable(expand('~/.vimlocal'))
    source ~/.vimlocal
endif
