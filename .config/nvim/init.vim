let mapleader=" "

call plug#begin('~/.config/nvim/plugged')
Plug 'toupeira/vim-desertink'
Plug 'scrooloose/nerdtree'
Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'majutsushi/tagbar'
Plug 'AndrewRadev/tagalong.vim'
Plug 'danro/rename.vim'
Plug 'Yggdroot/indentLine'
Plug 'isa/vim-matchit'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
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
" Plug 'galooshi/vim-import-js'
Plug 'kristijanhusak/vim-js-file-import', {'do': 'npm install'}
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
Plug 'editorconfig/editorconfig-vim'
Plug 'ap/vim-css-color'
" Plug 'vim-vdebug/vdebug'
Plug 'moll/vim-bbye'
Plug 'simnalamburt/vim-mundo'
Plug 'mhinz/vim-startify'
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
" need to be loaded after the plugins it extend
Plug 'ryanoasis/vim-devicons'
call plug#end()

set exrc   " read .nvimrc in directory where nvim is started
set secure " limit what can be done in .nvimrc

let g:js_file_import_use_fzf = 1
let g:js_file_import_string_quote = '"'

lua require("lsp-config")

let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
"nmap s <Plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDTrimTrailingWhitespace = 1
let g:NERDCommentEmptyLines = 0

let g:indentLine_char = '┊'

let g:startify_change_to_dir = 0
let g:startify_update_oldfiles = 1

function! s:gitModifiedUntracked()
    let files = systemlist('git ls-files -m -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

let g:startify_lists = [
        \ { 'type': 'sessions',  'header': ['    Sessions']       },
        \ { 'type': 'dir',       'header': ['    MRU '. getcwd()] },
        \ { 'type': function('s:gitModifiedUntracked'),  'header': ['    git untracked and modified']},
        \ ]
let g:startify_session_sort = 1
let g:startify_session_before_save = [
        \ 'echo "Cleaning up before saving…"',
        \ 'silent! NERDTreeClose'
        \ ]
let g:startify_session_persistence = 1

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

" make current full screen
nmap <F11> :only<CR>
" make current buffer full height at the far right
nmap <F10> <C-W>L
" make current buffer full with at the bottom
nmap <F9> <C-W>J

" let's try to use it the right way
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

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

""""""""""
" Firevim
" disable by default and enabled on github and gitlab
let g:firenvim_config = {
    \ 'globalSettings': {
        \ 'alt': 'all',
    \  },
    \ 'localSettings': {
        \ '.*': {
            \ 'cmdline': 'neovim',
            \ 'content': 'text',
            \ 'priority': 0,
            \ 'selector': 'textarea',
            \ 'takeover': 'never',
        \ },
    \ }
\ }

let fc = g:firenvim_config['localSettings']
let fc['.*gitlab.com.*'] = { 'takeover': 'always', 'priority': 1 }
let fc['.*github.com.*'] = { 'takeover': 'always', 'priority': 1 }

au BufEnter gitlab.com_*.txt set filetype=markdown

let g:gutentags_modules = ['ctags', 'gtags_cscope']
let g:gutentags_ctags_exclude_wildignore = 1
let g:gutentags_cache_dir = "~/.cache/gutentags"
let g:gutentags_define_advanced_commands = 1
let g:gutentags_project_root = ['pnpm-lock.yaml', 'composer.json', 'package.json']
" for PHP don't add aliases (ie use of a namespace) in tag files
" this make arnaud-lb/vim-php-namespace much easier to use
let g:gutentags_ctags_extra_args = ['--kinds-PHP=-a']
let g:gutentags_exclude_filetypes = ['gitcommit', 'gitrebase', 'diff']

let g:gutentags_plus_switch = 1
let g:gutentags_plug_nomap = 1

let g:fzf_layout = { 'down': '40%' }

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep -l --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

noremap <silent> <C-p> :Files<cr>
noremap <silent> <C-g> :Ag<cr>
noremap <expr> <A-g> ':GGrep '.expand('<cword>').'<cr>'
noremap <silent> <leader><C-b> :Buffers<cr>
noremap <silent> <leader><C-t> :Tags<cr>
noremap <expr> <leader><C-g> ':Ag '.expand('<cword>').'<cr>'


" find symbol
noremap <silent> <leader>s :GscopeFind s <C-R><C-W><cr>
" find definition
noremap <silent> <leader>d :GscopeFind g <C-R><C-W><cr>

nnoremap <Leader>t :execute 'tjump' expand('<cword>')<CR>
nnoremap <Leader>wt :execute 'stjump' expand('<cword>')<CR>

nnoremap <expr> <Leader>mdn ':!firefox https://developer.mozilla.org/en-US/search?q='.expand('<cword>').'<cr>'
nnoremap <expr> <Leader>duck ':!firefox https://duckduckgo.com/?q='.expand('<cword>').'<cr>'

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
\   'javascriptreact': ['trim_whitespace', 'prettier', 'eslint'],
\   'typescript': ['trim_whitespace', 'prettier', 'eslint'],
\   'typescriptreact': ['trim_whitespace', 'prettier', 'eslint'],
\   'graphql': ['trim_whitespace', 'prettier', 'eslint'],
\   'scss': ['trim_whitespace', 'prettier', 'eslint'],
\   'json': ['trim_whitespace', 'prettier'],
\   'yaml': ['trim_whitespace'],
\   'markdown': ['trim_whitespace']
\}

let g:ale_scss_stylelint_use_global = 1

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
