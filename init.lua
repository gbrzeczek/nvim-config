-- Set options
vim.opt.compatible = false
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.mouse = 'a'
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.wildmode = 'longest,list'
vim.opt.cc = '120'
vim.opt.clipboard = 'unnamedplus'
vim.opt.cursorline = true
vim.opt.ttyfast = true
vim.opt.relativenumber = true

-- Set leader key
vim.g.mapleader = ','

-- Enable filetype plugins
vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')

-- Plugin management with vim-plug
vim.cmd([[
call plug#begin()
Plug 'github/copilot.vim'
Plug 'tiagovla/tokyodark.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'dense-analysis/ale'
Plug 'nvim-neo-tree/neo-tree.nvim', {'branch': 'v2.x', 'do': ':UpdateRemotePlugins'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'MunifTanjim/nui.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'romgrk/barbar.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
call plug#end()
]])

-- Set colorscheme
vim.cmd('colorscheme tokyodark')

-- Keybindings
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Telescope bindings
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', opts)
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', opts)
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', opts)
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', opts)

-- Neotree binding
map('n', '<Leader>n', ':Neotree toggle<CR>', opts)

-- Barbar bindings
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
map('n', '<A-S-c>', '<Cmd>BufferRestore<CR>', opts)

-- Telescope config
require('telescope').setup {
    defaults = {
        file_ignore_patterns = { 'node_modules', '.git' },
        path_display = { 'truncate' }
    }
}

local cmp = require('cmp')
local luasnip = require('luasnip')

-- Code completions
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true }

  -- Leader key mappings
  buf_set_keymap('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>fo', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Language servers
local tsProbeLocations = "%APPDATA%\\npm\\node_modules\\typescript\\lib"
local ngProbeLocations = "%APPDATA%\\npm\\node_modules\\@angular\\language-server"
local cmd = {"ngserver", "--stdio", "--tsProbeLocations", tsProbeLocations, "--ngProbeLocations", ngProbeLocations}
require'lspconfig'.angularls.setup{
  capabilities = capabilities,
  cmd = cmd,
  on_new_config = function(new_config,new_root_dir)
    new_config.cmd = cmd
  end,
  on_attach = on_attach
}
require'lspconfig'.ts_ls.setup{}

