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
set cmdheight=2
set updatetime=750
set signcolumn=yes
set shortmess+=c

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
Plug 'sickill/vim-monokai'

" syntax
Plug 'cakebaker/scss-syntax.vim'
Plug 'calviken/vim-gdscript3'
Plug 'ianks/vim-tsx'
Plug 'leafgarland/typescript-vim'
Plug 'lepture/vim-jinja'
Plug 'nikvdp/ejs-syntax'
Plug 'noahfrederick/vim-noctu'
Plug 'posva/vim-vue'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

" functionality
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary', "{{{
    nmap <leader>c <Plug>Commentary
    xmap <leader>c <Plug>Commentary
    omap <leader>c <Plug>Commentary
    nmap <leader>cc <Plug>CommentaryLine
    autocmd FileType vue setlocal commentstring=//\ %s
"}}}

Plug 'tpope/vim-fugitive', "{{{
    map \b :Gblame<CR>
    map \l :Glog<CR>
    map \gs :Gstatus<CR>
"}}}

Plug 'neoclide/coc.nvim', {'branch': 'release'}, "{{{
  inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction
  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  nmap <silent> ]p :<C-u>CocPrev<CR>
  nmap <silent> [p :<C-u>CocNext<CR>

  nmap <leader>f <Plug>(coc-fix-current)

  " Use <c-space> to trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()

  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
   if (index(['vim','help'], &filetype) >= 0)
     execute 'h '.expand('<cword>')
   else
     call CocAction('doHover')
   endif
  endfunction

  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
  " Coc only does snippet and additional edit on confirm.
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
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
Plug 'airblade/vim-gitgutter'
Plug 'easymotion/vim-easymotion', "{{{
    map <Leader><Leader> <Plug>(easymotion-prefix)
"}}}

Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim',  "{{{
    function! s:buflist()
        redir => ls
        silent ls
        redir END
        return split(ls,'\n')
    endfunction

    function! s:bufopen(e)
        execute 'buffer' matchstr(a:e, '^[ 0-9]*')
    endfunction

    nnoremap <silent> <Leader><Enter> :call fzf#run({
                \ 'source': reverse(<sid>buflist()),
                \ 'sink': function('<sid>bufopen'),
                \ 'options': '+m',
                \ 'down': len(<sid>buflist()) + 2
                \})<CR>


    function! s:FuzzyFiles()
        let gitparent=system('git rev-parse --show-toplevel')[:-2]
        let rootdir='.'

        if empty(matchstr(gitparent, '^fatal:.*'))
            silent call fzf#run({
                        \ 'dir':     gitparent,
                        \ 'source':  '(git ls-tree -r --name-only HEAD | rg --files)',
                        \ 'sink':    'e',
                        \})
        else
            silent call fzf#run({
                        \ 'dir':     '.',
                        \ 'source':  'rg --files',
                        \ 'sink':    'e',
                        \})
        endif
    endfunction

    command! -bang -nargs=* Rg
                \ call fzf#vim#grep(
                \  'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
                \  <bang>0 ? fzf#vim#with_preview('up:60%')
                \          : fzf#vim#with_preview('right:50%:hidden', '?'),
                \  <bang>0)

    nnoremap <silent> ; :call <sid>FuzzyFiles()<CR>
    nnoremap <leader>/ :Rg<CR>
	
"}}}
call plug#end()

" theme / visual
try
	" colorscheme wal
        colorscheme monokai
catch
endtry
hi clear SpellBad                   " italicize misspellings
hi SpellBad gui=underline cterm=italic

highlight ExtraWhitespace ctermbg=20 ctermfg=1
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" List items are always weird distracting colors
hi SpecialKey ctermfg=238

" key mappings
map <C-n> :bnext<cr>                " next buffer
map <C-p> :bprev<cr>                " prev buffer

nmap <C-j> <C-W>j                   " focus window down
nmap <C-k> <C-W>k                   " focus window up
nmap <C-h> <C-W>h                   " focus window left
nmap <C-l> <C-W>l                   " focus window right

vnoremap <C-o> :sort<cr>                " visual select and sort
noremap <F7> mzgg=G`z<cr>               " auto-format entire document

nnoremap <leader>pu :PlugUpdate<cr>     " update plugins managed by vim-plugged
nnoremap <leader>pi :PlugInstall<cr>    " install new plugins
nnoremap <leader>pc :PlugClean<cr>      " clean removed plugins

nnoremap zn ]s                          " next misspelling
nnoremap zp [s                          " prev misspelling
nnoremap zf <Esc>1z=                    " replace misspelling with first suggestion

nnoremap <leader>n :set number!<cr>     " toggle numbering

nnoremap <leader>ve :e $MYVIMRC<cr>     " quick open (literally) this file

nmap <leader>w :w!<cr>                  " fast save

" clear trailing white space
nnoremap <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" prefer ripgrep if available
if executable('rg')
    set grepprg="rg --vimgrep"
endif

" save with sudo
command! W execute 'w !sudo tee %> /dev/null' <bar> edit!

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

" close if final buffer is netrw or the quickfix
augroup finalcountdown
    au!
    autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw" || &buftype == 'quickfix' |q|endif
    nmap - :Lexplore<cr>
augroup END

" read .vimlocal if available
if filereadable(expand('~/.vimlocal'))
    source ~/.vimlocal
endif
