
            -- ▜█▙
         -- █▄     ▄█▄
        -- ████▄ ▄████▄
       -- ██▀█████▀▀███▄
      -- ██   ▀█▀   ▀███▄
  -- ▄▄▄██ █████████▄▀███▄▄▄▄
  -- ▀███  ███    ███ ▀█████▀
        -- █████████▀  ▄▄▄
        -- ███▀██▄    ▀▀███
        -- ███  ▀██▄▄  ▄███
         -- ▀▀    ▀██████▀
            -- ▜█▙

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- options
local opt = vim.opt
opt.relativenumber = true
-- opt.number = true
opt.autoread = true   -- automatically reload modified files
opt.wildmenu = true   -- handle autocompletion menu

opt.wrap = false

opt.modelines = 5
opt.matchtime = 1
opt.tabstop = 2
opt.shiftwidth = 2
opt.autoindent = true
opt.scrolloff = 7
opt.spell = true                           -- enable spellcheck

opt.ignorecase = true                      -- ignore case while searching
opt.smartcase = true                       -- ...unless mixed case is used in search terms

opt.backspace = "indent,eol,start"         -- allow backspace on indent, eol, or insert mode start position
opt.cursorline = true
opt.swapfile = false                       -- disable swap file

-- highlight trailing white space
vim.fn.matchadd('errorMsg', [[\s\+$]])


-- use system clipboard as default register
opt.clipboard:append("unnamedplus")

-- utility functions for key mappings
function ToggleLineNumbering()
  vim.o.number = not vim.o.number
  vim.o.relativenumber = vim.o.number
end

-- keymappings
local keymap = vim.keymap

keymap.set('', '<C-n>', ':bnext<CR>', {desc="Jump to next buffer"})
keymap.set('', '<C-p>', ':bprev<CR>', {desc="Jump to previous buffer"})

keymap.set('', '<C-h>', '<C-W>h', {desc="Focus window left"})
keymap.set('', '<C-j>', '<C-W>j', {desc="Focus window down"})
keymap.set('', '<C-k>', '<C-W>k', {desc="Focus window up"})
keymap.set('', '<C-l>', '<C-W>l', {desc="Focus window right"})

keymap.set('v', '<C-o>', ':sort<CR>', {desc="Sort selected lines alphanumerically"})
keymap.set('n', '<F7>', 'mzgg=G`z<CR>', {desc="Auto-format entire document"})

keymap.set('n', '<leader>pu', ':Lazy update<CR>', {desc="Update plugins managed by Lazy"})
keymap.set('n', '<leader>pi', ':Lazy install<CR>', {desc="Install missing plugins managed by Lazy"})
keymap.set('n', '<leader>pc', ':Lazy clean<CR>', {desc="Clean plugins managed by Lazy"})

keymap.set('n', 'zn', ']s', {desc="Jump to next misspelling"})
keymap.set('n', 'zp', '[s', {desc="Jump to previous misspelling"})
keymap.set('n', 'zf', '<Esc>1z=', {desc="Replace misspelling with firest suggested from dictionary"})

keymap.set('n', '<leader>n', ':lua ToggleLineNumbering()<CR>', {desc="Toggle line numbering"})
keymap.set('n', '<leader>w', ':w!<CR>', {desc="Quicksave"})

-- prefer ripgrep if available
if vim.fn.executable('rg') == 1 then
	vim.o.grepprg = 'rg --vimgrep'
end

-- :W to save with sudo
-- vim.api.nvim_create_user_command('')
