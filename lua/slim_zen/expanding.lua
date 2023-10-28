local api = vim.api
local cmd = vim.cmd
local simple = require('slim_zen.simple_zen')

local M = {}

M.running = false
M.simple_toggled = false

function M.toggle(line1, line2)

    if not simple.running then
        simple.toggle()
        M.simple_toggled = true
    end

    if M.running then
        cmd(':normal! zE')
        if M.simple_toggled then
            simple.toggle()
            M.simple_toggled = false
        end
        M.running = false

        return
    end

    local cursor = api.nvim_win_get_cursor(0)
    api.nvim_win_set_cursor(0 , {line1 -1, 0})
    cmd(":normal! zfgg")

    api.nvim_win_set_cursor(0 , {line2 + 1, 0})
    cmd(":normal! zfG")

    api.nvim_win_set_cursor(0, cursor) -- TODO this should be middle afterwards

    M.running = true
end

return M
