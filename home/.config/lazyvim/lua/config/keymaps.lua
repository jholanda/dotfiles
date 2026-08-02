-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

-- 1. Ctrl+S para Salvar
-- Mapeia Ctrl+S para salvar no modo Normal
vim.keymap.set('n', '<C-s>', ':w<CR>', { desc = 'Salvar arquivo' })
-- Mapeia Ctrl+S para salvar no modo de Inserção
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a', { desc = 'Salvar arquivo' })
vim.keymap.set('i', '<C-Enter>', '<C-o>:w<CR><CR>', {
  noremap = true,
  silent = true,
  desc = 'Salvar arquivo e inserir nova linha (sem sair do modo de inserção)',
})
-- 2. Ctrl+A para Selecionar Tudo
-- Mapeia Ctrl+A para selecionar todo o texto no modo Normal
vim.keymap.set('n', '<C-a>', 'ggVG', { desc = 'Selecionar todo o texto' })
