vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", '<leader>,', '<Esc>A,<Esc>')
vim.keymap.set("n", '<leader>;', '<Esc>A;<Esc>')
vim.keymap.set("n", '<leader>k', ':bn<CR>')
vim.keymap.set("n", '<leader>j', ':bp<CR>')
vim.keymap.set("n", '<leader>w', ':bd<CR>')
vim.keymap.set("n", '<leader>r', ':bp<bar>bd#<cr>')

vim.keymap.set("n", '<leader>a', 'ggVG')
vim.keymap.set("n", '<leader>q', ':HopWord<CR>')
vim.keymap.set("n", 'n', 'nzzzv')
vim.keymap.set("n", 'N', 'Nzzzv')
vim.keymap.set("n", 'J', 'mzJ`z')
vim.keymap.set("i", '<c-a>', '<esc>^i')

-- blackhole delete line
vim.keymap.set("n", '<leader>d', '"_dd')
vim.keymap.set("n", 'x', '"_x')
-- system clipboard paste
vim.keymap.set("n", '<leader>v', '"+p`]')

-- yank paste
vim.keymap.set("n", 'p', 'p`]')
vim.keymap.set("v", 'p', 'p`]')
vim.keymap.set("v", 'y', 'y`]')

-- system clipboard copy
vim.keymap.set("v", '<leader>c', '"+y`]')
vim.keymap.set("v", '<leader>v', '"+p`]')

vim.keymap.set("n", '<C-h>', '<C-w>h')
vim.keymap.set("n", '<C-j>', '<C-w>j')
vim.keymap.set("n", '<C-k>', '<C-w>k')
vim.keymap.set("n", '<C-l>', '<C-w>l')
