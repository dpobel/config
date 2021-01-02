let mapleader=" "

call plug#begin('~/.config/nvim/plugged')
Plug 'toupeira/vim-desertink'
Plug 'scrooloose/nerdtree'
Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'majutsushi/tagbar'
Plug 'danro/rename.vim'
Plug 'isa/vim-matchit'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mhinz/vim-grepper'
Plug 'sheerun/vim-polyglot'
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'
Plug 'scrooloose/nerdcommenter'
Plug 'StanAngeloff/php.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'tobyS/vmustache'
"Plug 'tobyS/pdv'
Plug 'YaroslavMolchan/pdv'
Plug 'arnaud-lb/vim-php-namespace'
Plug 'editorconfig/editorconfig-vim'
Plug 'ap/vim-css-color'
Plug 'vim-vdebug/vdebug'
Plug 'simnalamburt/vim-mundo'
" need to be loaded after the plugins it extend
Plug 'ryanoasis/vim-devicons'
call plug#end()

set exrc   " read .nvimrc in directory where nvim is started
set secure " limit what can be done in .nvimrc

let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDTrimTrailingWhitespace = 1
let g:NERDCommentEmptyLines = 0

set incsearch
set hlsearch
set smartcase

" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

set scrolljump=5
set sidescrolloff=5
set scrolloff=5

set number
set relativenumber

set title
set hidden

set dir=~/tmp
set sm
set nobackup
set history=50

set backspace=start,eol,indent

set mouse= " nvim
set clipboard=unnamed

set cursorline

set expandtab
set ts=4
set sw=4

set list
set listchars=tab:\ \ ,nbsp:¬

set undofile
set undodir=~/tmp/.neovim/undo
set undolevels=10000

set modeline

syntax on
filetype plugin indent on

"set splitbelow
set splitright

:tnoremap <Esc> <C-\><C-n>

nnoremap <Leader><Up>    :resize +5<CR>
nnoremap <Leader><Down>  :resize -5<CR>
nnoremap <Leader><Left>  :vertical resize -5<CR>
nnoremap <Leader><Right> :vertical resize +5<CR>

nnoremap <F4> :MundoToggle<CR>
let g:mundo_right = 1

map <F2> :NERDTreeToggle<CR>
map <Leader><F2> :NERDTreeFind<CR>

let g:NERDTreeShowHidden = 1

map <F3> :TagbarToggle<CR>
let g:tagbar_width = 30
let g:tagbar_autofocus = 1
let g:tagbar_sort = 1
let g:tagbar_show_visibility = 1

map <C-g> :Grepper<cr>
map <Leader><C-g> :Grepper -cword -query<cr>

nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

let g:grepper               = {}
let g:grepper.highlight     = 1
let g:grepper.tools         = ['git', 'ag']
let g:grepper.next_tool     = '<leader>g'
let g:grepper.simple_prompt = 1
let g:grepper.dir = 'repo,cwd'
let g:grepper.side_cmd = 'botright vnew'

runtime plugin/grepper.vim

let g:grepper.tools = ['git', 'git_grep_everything', 'ag']
let g:grepper.git_grep_everything = {
\   'grepprg':    'git grep -nI --untracked --no-exclude-standard',
\   'grepformat': '%f:%l:%m',
\   'escape':     '\^$.*[]',
\ }

" set termguicolors
set bg=dark
colorscheme desertink
" colorscheme solarized

set wildignore+=*node_modules*
set wildignore+=*build*
set wildignore+=*cache*
set wildignore+=*logs*
" set wildignore+=*vendor*
"set wildignore+=tags
"set wildignore+=*coverage*

let g:gutentags_modules = ['ctags', 'gtags_cscope']
let g:gutentags_ctags_exclude_wildignore = 1
let g:gutentags_cache_dir = "~/.cache/gutentags"
let g:gutentags_define_advanced_commands = 1
let g:gutentags_project_root = ['composer.json']
" for PHP don't add aliases (ie use of a namespace) in tag files
" this make arnaud-lb/vim-php-namespace much easier to use
let g:gutentags_ctags_extra_args = ['--kinds-PHP=-a']
let g:gutentags_exclude_filetypes = ['gitcommit', 'gitrebase', 'diff']

let g:gutentags_plus_switch = 1
let g:gutentags_plug_nomap = 1

let g:ctrlp_root_markers = ['composer.json']
let g:ctrlp_open_multiple_files = '2vjr' " open up to 2 new vertical split, jump to first and open first in current window
let g:ctrlp_extensions = ['tag']
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l -U --nocolor -g ""'
endif
"let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

" find symbol
noremap <silent> <leader>s :GscopeFind s <C-R><C-W><cr>
" find definition
noremap <silent> <leader>d :GscopeFind g <C-R><C-W><cr>
" find text under cursor
noremap <silent> <Leader>f :Grepper -cword -tool git_grep_everything -noprompt<cr>

nnoremap <Leader>t :execute 'tjump' expand('<cword>')<CR>
nnoremap <Leader>wt :execute 'stjump' expand('<cword>')<CR>

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_symbols.dirty='⚡'

let g:airline#extensions#ale#enabled = 1
let g:ale_sign_column_always = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   'php': ['trim_whitespace', 'php_cs_fixer'],
\   'javascript': ['trim_whitespace', 'prettier', 'eslint'],
\   'graphql': ['trim_whitespace', 'prettier', 'eslint'],
\   'scss': ['trim_whitespace', 'prettier', 'eslint'],
\   'json': ['trim_whitespace', 'prettier'],
\   'yaml': ['trim_whitespace'],
\   'markdown': ['trim_whitespace']
\}

let g:ale_php_phpcs_standard = 'PSR2'
let g:ale_php_phpstan_level = '9'

" let g:php_cs_fixer_path = "~/bin/php-cs-fixer"
" let g:php_cs_fixer_rules = "@PSR2"

let g:pdv_template_dir = $HOME . "/.config/nvim/pdv_templates"
map <Leader><C-d> :call pdv#DocumentCurrentLine()<CR>

let g:php_namespace_sort_after_insert = 1
noremap <Leader>u :call PhpInsertUse()<CR>
noremap <Leader>e :call PhpExpandClass()<CR>
noremap <Leader>ns :call PhpSortUse()<CR>

set laststatus=2 " display airline bar all the time
"cnoremap w!! w !sudo tee % >/dev/null

map \ :nohlsearch<CR>

set pastetoggle=<ins>
nnoremap <silent> <ins> :setlocal paste!<CR>i
autocmd InsertLeave <buffer> se nopaste

autocmd VimLeavePre * :mksession! ~/tmp/stopped.vim

"let g:user_emmet_leader_key=','

"au BufRead,BufNewFile *.twig        set filetype=jinja
"au BufRead,BufNewFile *.html.twig   set filetype=htmljinja
"au BufRead,BufNewFile *.swig        set filetype=htmljinja

au BufRead,BufNewFile *.md  set ft=markdown
"au BufRead,BufNewFile *.hbt  set ft=mustache

" no line number in terminal
au TermOpen * set nonumber norelativenumber
