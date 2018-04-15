" Mark's super duper    _
" _ __   ___  _____   _(_)_ __ ___
"| '_ \ / _ \/ _ \ \ / / | '_ ` _ \
"| | | |  __/ (_) \ V /| | | | | | |
"|_| |_|\___|\___/ \_/ |_|_| |_| |_|
"

set title
set history=700
set background=dark

filetype plugin on
filetype indent on

syntax enable

let mapleader=" "
let maplocalleader=" "

set autoread                               " Carry over indenting from previous line
set wildmenu                               " Handy auto complete menu

set list
set listchars=tab:·\ ,trail:▂,extends:»,precedes:«
set infercase                              " Completion recognizes capitalisation
set smartcase
set ignorecase
set incsearch                              " Search as you type
set hidden                                 " Sometimes I don't want to save a buffer before switching

set modeline
set modelines=5
set matchtime=1
set tabstop=4
set softtabstop=4
set shiftwidth=4
set completeopt-=preview
set scrolloff=8

set spell

" Ensure vim-plug is installed...
if !filereadable(expand('~/.local/share/nvim/site/autoload/plug.vim'))
	silent !echo "Installing vim-plug..."
	silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Section: Plugins {{{1
call plug#begin('~/.local/share/nvim/plugged')

"" color schemes ---
Plug 'crusoexia/vim-monokai'

function! ColorSchemeMonokai()
	set termguicolors
	colorscheme monokai
	hi Normal ctermbg=none guibg=none
	hi Comment gui=none
	hi SignColumn ctermbg=none guibg=none
	hi LineNr ctermbg=none guibg=none ctermfg=236 guifg=#555555
	hi link GitGutterAdd Directory
	hi link GitGutterDelete Statement
	hi link GitGutterChange CursorLineNr
endfunction


"" functionality ---
Plug 'airblade/vim-gitgutter', "{{{
	nmap <leader>g :GitGutterToggle<CR>
	let g:gitgutter_override_sign_column_highlight = 0
	autocmd! BufWritePost * :GitGutter
"}}}}

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'

Plug 'tpope/vim-fugitive', "{{{
	map \b :Gblame<CR>
	map \l :Glog<CR>
	map \gs :Gstatus<CR>
"}}}

Plug 'Shougo/unite.vim' "{{{
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
	call unite#filters#matcher_default#use(['matcher_fuzzy'])
	call unite#filters#sorter_default#use(['sorter_rank'])
	call unite#custom#profile('files', 'context.smartcase', 1)
	call unite#custom#source('line,outline', 'matchers', 'matcher_fuzzy')
	call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
				\ 'ignore_pattern', join([
				\ '\.git',
				\ 'google/obj/',
				\ 'dist/',
				\ 'node_modules/',
				\ 'tmp/'
				\ ], '\|'))
	imap <silent><buffer> <C-j> <Plug>(unite_select_next_line)
	imap <silent><buffer> <C-k> <Plug>(unite_select_previous_line)
	imap <silent><buffer> <Esc> <Plug>(unite_exit)
	if executable('rg')
		let g:unite_source_grep_command = 'rg'
	endif
	endfunction
"}}}

Plug 'Shougo/unite-session'                " provide session (project) support
Plug 'Shougo/unite-outline'
Plug 'Shougo/deoplete.nvim', "{{{
	let g:deoplete#enable_at_startup = 1
	if !exists('g:deoplete#omni#input_patterns')
		let g:deoplete#omni#input_patterns = {}
	endif
	"autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
	"inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
	"inoremap <expr><TAB> pumvisible() ? "echom foo" : "echom bar"
	inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
	function! s:my_cr_function()
		return deoplete#mappings#smart_close_popup() . "\<CR>"
	endfunction
"}}}
Plug 'carlitux/deoplete-ternjs', {'do': 'npm install -g tern'}
Plug 'zchee/deoplete-clang'
Plug 'davidhalter/jedi'
Plug 'zchee/deoplete-jedi'
Plug 'tweekmonster/deoplete-clang2'

Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neosnippet.vim', "{{{
	let g:neosnippet#snippets_directory = '~/.vim/bundle/vim-snippets,~/.vim/snippets'
	let g:neosnippet#enable_snipmate_compatibility = 1
	imap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? "\<C-n>" : "\<TAB>")
	smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
	imap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
	smap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
"}}}

Plug 'w0rp/ale', "{{{
	let g:ale_linters = {
		\ 'cpp': ['clang'],
		\ 'c': ['clang']
		\}
	let g:ale_python_pylint_options = '--load-plugins pylint_django'
"}}}

Plug 'majutsushi/tagbar', "{{{
	nmap \t :TagbarToggle<CR>
"}}}

Plug 'mbbill/undotree', "{{{
	let g:undotree_WindowLayout = 4
	let g:undotree_FocusWhenToggle = 1
	nnoremap \r :UndotreeToggle<CR>
"}}}

Plug 'scrooloose/nerdtree', "{{{
	let g:NERDTreeQuitOnOpen = 0
	let g:NERDTreeShowLineNumbers = 0
	let g:NERDTreeWinPos = 'right'
	let g:NERDTreeIgnore = ['\.pyc$']
	nmap \e :NERDTreeToggle<CR>
"}}}

Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline', "{{{
	let g:airline_left_sep = '⮀'
	let g:airline_left_alt_sep = '⮁'
	let g:airline_right_sep = '⮂'
	let g:airline_right_alt_sep = '⮃'
	let g:airline_symbols = {}
	let g:airline_symbols.branch = '⭠'
	let g:airline_symbols.readonly = '⭤'
	let g:airline_symbols.linenr = '⭡'
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tabline#fnamemod = ':t'
	let g:airline_theme = 'molokai'
"}}}

Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim', "{{{

	let g:fzf_colors =
				\ {
				\ 'fg':      ['fg', 'Normal'],
				\ 'bg':      ['bg', 'Normal'],
				\ 'hl':      ['fg', 'Comment'],
				\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
				\ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
				\ 'hl+':     ['fg', 'Statement'],
				\ 'info':    ['fg', 'PreProc'],
				\ 'border':  ['fg', 'Ignore'],
				\ 'prompt':  ['fg', 'Conditional'],
				\ 'pointer': ['fg', 'Exception'],
				\ 'marker':  ['fg', 'Keyword'],
				\ 'spinner': ['fg', 'Label'],
				\ 'header':  ['fg', 'Comment']
				\ }

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
    \   'source':   reverse(<sid>buflist()),
    \   'sink':     function('<sid>bufopen'),
    \   'options':  '+m',
    \   'down':     len(<sid>buflist()) + 2
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
"}}}

" Section: Functions {{{1

function! HighlightTrailingWhitespace()
	highlight TrailingWhitespace ctermfg=204 ctermbg=161 guifg=#ff2266 guibg=#ff2266
	match TrailingWhitespace /\s\+$/
endfunction

function! StripTrailingWhitespace()
	let _s=@/
	let l = line(".")
	let c = col(".")
	%s/\s\+$//e
	let @/=_s
	call cursor(l, c)
endfunction

"}}}

" Section: Key bindings {{{1

map <C-n> :bnext<CR>                       " change buffers with ctrl+n & ctrl_p
map <C-p> :bprev<CR>

nnoremap <C-j> :lnext<CR>                  " quickfix navigation
nnoremap <C-k> :lprev<CR>

vmap <C-o> :sort<CR>                       " sort lines in visual mode with ctrl-o

map <F7> mzgg=G`z<CR>                      " magically fix indentation

nmap <leader>n :set invnumber<CR>          " toggle line numbers

vnoremap < <gv                             " stay in visual mode when shifting
vnoremap > >gv

nnoremap <leader>pu :PlugUpdate<CR>        " vim-plug shortcuts
nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>pc :PlugClean<CR>

nnoremap <leader>o :jumps<CR>              " show jumps list

nnoremap zn ]s                             " next misspelling
nnoremap zp [s                             " prev misspelling
nnoremap zf <Esc>1z=                       " replace misspelling with first suggestion
nnoremap z! :setlocal spell!<CR>           " toggle spellcheck

nnoremap <leader>ws :call StripTrailingWhitespace()<CR> " strip trailing whitespace

nnoremap <leader>ve :e $MYVIMRC<CR>        " quick open this file

if executable('rg')
	set grepprg='rg\ --vimgrep'            " use ripgrep if available
endif

"}}}

" Section: Visual {{{1
call ColorSchemeMonokai()
call HighlightTrailingWhitespace()

hi clear SpellBad                           " Italicize misspellings
hi SpellBad gui=underline cterm=italic

"}}}

" Section: .vimlocal {{{1
if filereadable(expand('~/.vimlocal'))
	source ~/.vimlocal
endif
"}}}

