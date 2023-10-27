local M = {
}

function M.simple()
    require('slim_zen.slim_zen_mode').toggle()
    print(vim.inspect(M.keymaps))
end

function M.expanding()
    print('Not yet implemented!')
end

vim.keymap.set('n', 'gz', M.simple)

vim.keymap.set('n', 'gt', M.expanding)

return M
