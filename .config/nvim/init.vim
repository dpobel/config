let mapleader=" "

call plug#begin('~/.config/nvim/plugged')
" Dependencies of neo-tree.nvim
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim', {'branch': 'v3.x'}

" LSP and friends
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'

Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'} " Replace <CurrentMajor> by the latest released major (first number of latest release)

Plug 'windwp/nvim-autopairs'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'w0rp/ale'

Plug 'freddiehaddad/feline.nvim'
Plug 'lewis6991/gitsigns.nvim'

Plug 'github/copilot.vim'

Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'preservim/tagbar'
Plug 'AndrewRadev/tagalong.vim'
Plug 'danro/rename.vim'
Plug 'Yggdroot/indentLine'
Plug 'andymass/vim-matchup'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"Plug 'sheerun/vim-polyglot'

Plug 'yssl/QFEnter'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'scrooloose/nerdcommenter'

Plug 'editorconfig/editorconfig-vim'

Plug 'ap/vim-css-color'

Plug 'moll/vim-bbye'

Plug 'simnalamburt/vim-mundo'
Plug 'mhinz/vim-startify'

Plug 'EdenEast/nightfox.nvim'
" TODO: test it more
Plug 'navarasu/onedark.nvim'
" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

Plug 'nvim-tree/nvim-web-devicons'
call plug#end()

set termguicolors
set bg=dark
" colorscheme nightfox

lua << EOF
require('nightfox').setup({
  options = {
    styles = {
      conditionals = "bold",
      keywords = "bold",
      operators = "bold",
      types = "bold",
    }
  }
})
vim.cmd("colorscheme nightfox")

-- language servers
require("mason").setup()

-- Treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "lua", "vim", "vimdoc", "query", "typescript", "tsx", "javascript", "css", "sql", "graphql", "bash", "json", "dockerfile", "diff", "php" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  matchup = {
    enable = true,              -- mandatory, false will disable the whole extension
    disable = { },  -- optional, list of language that will be disabled
    -- [options]
  },
}

-- Setup language servers.
local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.tsserver.setup {}
lspconfig.rust_analyzer.setup {
  -- Server-specific settings. See `:help lspconfig-setup`
  settings = {
    ['rust-analyzer'] = {},
  },
}


-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>E', vim.diagnostic.setqflist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

require("neo-tree").setup({
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = true,
    },
  }
})

require('feline').setup()
-- require('feline').use_theme()

require('gitsigns').setup()


-- show source in diagnostics
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#show-source-in-diagnostics
vim.diagnostic.config({
  virtual_text = {
    source = "always",  -- Or "if_many"
  },
  float = {
    source = "always",  -- Or "if_many"
  },
})



-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    require('luasnip').lsp_expand(args.body)
  end,
},
window = {
  -- completion = cmp.config.window.bordered(),
  -- documentation = cmp.config.window.bordered(),
},
mapping = cmp.mapping.preset.insert({
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
}),
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  { name = 'luasnip' }, -- For luasnip users.
}, {
  { name = 'buffer' },
})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
mapping = cmp.mapping.preset.cmdline(),
sources = {
  { name = 'buffer' }
}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
mapping = cmp.mapping.preset.cmdline(),
sources = cmp.config.sources({
  { name = 'path' }
}, {
  { name = 'cmdline' }
})
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')['tsserver'].setup {
  capabilities = capabilities
}
require('lspconfig')['bashls'].setup {
  capabilities = capabilities
}

require("nvim-autopairs").setup {}

-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

EOF

set exrc   " read .nvimrc in directory where nvim is started
set secure " limit what can be done in .nvimrc

let g:js_file_import_use_fzf = 1
let g:js_file_import_string_quote = '"'

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
" commented to be able to use modals in neo-tree
" nnoremap <up> <nop>
" nnoremap <down> <nop>
" nnoremap <left> <nop>
" nnoremap <right> <nop>
" inoremap <up> <nop>
" inoremap <down> <nop>
" inoremap <left> <nop>
" inoremap <right> <nop>

nnoremap <Leader><Up>    :resize +5<CR>
nnoremap <Leader><Down>  :resize -5<CR>
nnoremap <Leader><Left>  :vertical resize -5<CR>
nnoremap <Leader><Right> :vertical resize +5<CR>

nnoremap <F4> :MundoToggle<CR>
let g:mundo_right = 1

map <F2> :Neotree toggle<CR>
map <Leader><F2> :Neotree reveal<CR>
map <F5> :Neotree source=buffers toggle<CR>
map <F6> :Neotree source=git_status toggle<CR>

map <F3> :TagbarToggle<CR>
let g:tagbar_width = 30
let g:tagbar_autofocus = 1
let g:tagbar_sort = 1
let g:tagbar_show_visibility = 1

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

let g:fzf_layout = { 'down': '40%' }

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep -l --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

noremap <silent> <C-p> :Files<cr>
noremap <silent> <C-g> :Ag<cr>
noremap <silent> <leader><C-b> :Buffers<cr>
noremap <silent> <leader><C-t> :Tags<cr>
noremap <expr> <leader><C-g> ':Ag '.expand('<cword>').'<cr>'

" quickfix close 
noremap <silent> <leader>q :cclose<cr>

nnoremap <Leader>t :execute 'tjump' expand('<cword>')<CR>
nnoremap <Leader>wt :execute 'stjump' expand('<cword>')<CR>

nnoremap <expr> <Leader>mdn ':!firefox https://developer.mozilla.org/en-US/search?q='.expand('<cword>').'<cr>'
nnoremap <expr> <Leader>duck ':!firefox https://duckduckgo.com/?q='.expand('<cword>').'<cr>'

let g:ale_sign_column_always = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

let g:ale_disable_lsp = 1
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

" press <Tab> to expand or jump in a snippet. These can also be mapped separately
" via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
" -1 for jumping backwards.
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

" For changing choices in choiceNodes (not strictly necessary for a basic setup).
imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'

set laststatus=2 " display airline bar all the time
cnoremap w!! w !sudo tee % >/dev/null

map \ :nohlsearch<CR>

set pastetoggle=<ins>
nnoremap <silent> <ins> :setlocal paste!<CR>i
autocmd InsertLeave <buffer> se nopaste

au BufRead,BufNewFile *.md  set ft=markdown

" no line number in terminal
au TermOpen * set nonumber norelativenumber
