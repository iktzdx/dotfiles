local ok, builtin = pcall(require, 'telescope.builtin')
if not ok then
    return
end

-- Search thro project files
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
-- Search only in git files
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
-- Live grep
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
-- Lists open buffers
vim.keymap.set('n', '<leader>pb', builtin.buffers)

-- Vim help?
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
