vim.g.netrw_liststyle = 3
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- options
local opt = vim.opt
opt.relativenumber = true
opt.number = true
opt.autoread = true   -- automatically reload modified files
opt.wildmenu = true   -- handle autocompletion menu

-- utility functions for key mappings
function ToggleLineNumbering()
  vim.o.number = not vim.o.number
  vim.o.relativenumber = vim.o.number
end

-- keymappings
local keymap = vim.keymap

keymap.set('n', '<leader>n', ':lua ToggleLineNumbering()<CR>', {desc="Toggle line numbering"})

keymap.set('', '<C-n>', ':bnext<CR>', {desc="Jump to next buffer"})
keymap.set('', '<C-p>', ':bprev<CR>', {desc="Jump to previous buffer"})

keymap.set('', '<C-h>', '<C-W>h', {desc="Focus window left"})
keymap.set('', '<C-j>', '<C-W>j', {desc="Focus window down"})
keymap.set('', '<C-k>', '<C-W>k', {desc="Focus window up"})
keymap.set('', '<C-l>', '<C-W>l', {desc="Focus window right"})

keymap.set('n', '<leader>pu', ':Lazy update<CR>', {desc="Update plugins managed by Lazy"})
keymap.set('n', '<leader>pi', ':Lazy install<CR>', {desc="Install missing plugins managed by Lazy"})
keymap.set('n', '<leader>pc', ':Lazy clean<CR>', {desc="Clean plugins managed by Lazy"})

keymap.set('n', '<leader>w', ':w!<CR>', {desc="Quicksave"})

keymap.set('n', '<F7>', 'mzgg=G`z<CR>', {desc="Auto-format entire document"})
keymap.set('v', '<C-o>', ':sort<CR>', {desc="Sort selected lines alphanumerically"})
