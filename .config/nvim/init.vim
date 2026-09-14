let mapleader=" "

call plug#begin('~/.config/nvim/plugged')
" Dependencies of neo-tree.nvim
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim', {'branch': 'v3.x'}

" LSP and friends
Plug 'neovim/nvim-lspconfig'
Plug 'mason-org/mason.nvim'

Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'} " Replace <CurrentMajor> by the latest released major (first number of latest release)

Plug 'windwp/nvim-autopairs'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'w0rp/ale'

Plug 'lewis6991/gitsigns.nvim'


Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'folke/flash.nvim'
Plug 'tpope/vim-surround'
Plug 'preservim/tagbar'
Plug 'AndrewRadev/tagalong.vim'
Plug 'Yggdroot/indentLine'
" Plug 'andymass/vim-matchup'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"Plug 'sheerun/vim-polyglot'

Plug 'yssl/QFEnter'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'branch': 'main'}

Plug 'catgoose/nvim-colorizer.lua'

Plug 'simnalamburt/vim-mundo'
Plug 'mhinz/vim-startify'

Plug 'EdenEast/nightfox.nvim'
" TODO: test it more
" Plug 'navarasu/onedark.nvim'

" Plug 'github/copilot.vim'
" Plug 'olimorris/codecompanion.nvim'
Plug 'milanglacier/minuet-ai.nvim'
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

-- Setup language servers.
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.ts_ls.setup { capabilities = capabilities }
lspconfig.biome.setup { capabilities = capabilities }
lspconfig.bashls.setup { capabilities = capabilities }
lspconfig.stylelint_lsp.setup {
    capabilities = capabilities,
    filetypes = { "css", "scss", "typescript", "typescriptreact" },
}
-- lspconfig.eslint.setup {}
-- lspconfig.typos_lsp.setup {}

-- Treesitter (branche `main`) : le plugin n'installe que les parsers et les
-- queries, toutes les fonctionnalités sont fournies par Neovim lui-même.
local ts_languages = {
  'bash', 'css', 'diff', 'dockerfile', 'graphql', 'html', 'javascript',
  'json', 'lua', 'markdown', 'markdown_inline', 'php', 'query', 'sql',
  'tsx', 'typescript', 'vim', 'vimdoc',
}
require('nvim-treesitter').install(ts_languages)

-- Remplace `highlight.enable` : `auto_install` n'existe plus, seules les
-- langues installées ci-dessus sont colorées.
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if lang and vim.treesitter.language.add(lang) then
      vim.treesitter.start(args.buf, lang)
    end
  end,
})


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

require('lualine').setup({
  theme = 'powerline',
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat', 'filetype', 'lsp_status' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
})

require('gitsigns').setup()

-- use flash.nvim as a replacement of easymotion's s only
require('flash').setup({ modes = { char = { enabled = false } } })
vim.keymap.set({ 'n', 'o' }, 's', function() require('flash').jump() end, { desc = 'Flash jump' })

require('colorizer').setup({
  filetypes = { '*' },
  user_default_options = {
    mode = 'background',
    css = true, -- rgb(), hsl(), var(--name), couleurs nommées…
    tailwind = true,
  },
})


-- show source in diagnostics
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#show-source-in-diagnostics
vim.diagnostic.config({
  virtual_lines  = true,
  -- virtual_text = {
  --  source = "always",  -- Or "if_many"
  -- },
  -- float = {
  --  source = "always",  -- Or "if_many"
  --},
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

require("nvim-autopairs").setup {}

-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

require('minuet').setup({
  provider = 'gemini',
  -- Utilisation du texte fantôme (ghost text) style Copilot
  virtualtext = {
    auto_trigger_ft = {'*'}, -- Active sur tous les types de fichiers
    keymap = {
      -- Identique à copilot.vim :
      accept = '<Tab>',       -- Accepter toute la suggestion (comme Copilot)
      dismiss = '<C-]>',      -- Fermer la suggestion
      next = '<M-]>',         -- Suggestion suivante (Alt + ])
      prev = '<M-[>',         -- Suggestion précédente (Alt + [)
      accept_line = '<C-l>',  -- Accepter seulement la ligne (bonus pratique)
    },
  },
  provider_options = {
    gemini = {
      model = 'gemini-flash-lite-latest', -- Très rapide et parfait pour le Ghost Text
      optional = {
        generationConfig = {
          maxOutputTokens = 512,
        },
      },
    },
  },
})

EOF

set exrc   " read .nvimrc in directory where nvim is started
set secure " limit what can be done in .nvimrc

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
set ignorecase
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
nnoremap <silent> <C-k> <cmd>lua vim.diagnostic.jump({ count = -1, float = true })<CR>
nnoremap <silent> <C-j> <cmd>lua vim.diagnostic.jump({ count = 1, float = true })<CR>

let g:ale_disable_lsp = 1
let g:ale_linters_explicit = 1 " ALE ne sert que de fixer, les diagnostics viennent du LSP
let g:ale_fix_on_save = 1
let g:ale_biome_options = '--use-editorconfig=true'
let g:ale_fixers = {
\   'php': ['trim_whitespace', 'php_cs_fixer'],
\   'javascript': ['trim_whitespace', 'prettier', 'biome'],
\   'javascriptreact': ['trim_whitespace', 'prettier', 'biome'],
\   'typescript': ['trim_whitespace', 'prettier', 'biome'],
\   'typescriptreact': ['trim_whitespace', 'prettier', 'biome'],
\   'graphql': ['trim_whitespace', 'prettier', 'biome'],
\   'scss': ['trim_whitespace', 'prettier', 'biome'],
\   'json': ['trim_whitespace', 'prettier'],
\   'yaml': ['trim_whitespace'],
\   'markdown': ['trim_whitespace']
\}

let g:ale_scss_stylelint_use_global = 1

let g:ale_php_phpcs_standard = 'PSR2'
let g:ale_php_phpstan_level = '9'

" press <Tab> to expand or jump in a snippet. These can also be mapped separately
" via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
" imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
" -1 for jumping backwards.
" inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

" snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
" snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

" For changing choices in choiceNodes (not strictly necessary for a basic setup).
imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'

set laststatus=2 " display airline bar all the time
cnoremap w!! w !sudo tee % >/dev/null

map \ :nohlsearch<CR>

"set pastetoggle=<ins>
nnoremap <silent> <ins> :setlocal paste!<CR>i
autocmd InsertLeave <buffer> se nopaste

au BufRead,BufNewFile *.md  set ft=markdown
