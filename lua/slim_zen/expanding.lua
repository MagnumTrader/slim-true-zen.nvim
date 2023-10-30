local api = vim.api
local cmd = vim.cmd
local simple = require('slim_zen.simple_zen')

local M = {}

M.running = false
-- field to check if expanding mode triggered the first simple
M.simple_toggled = false

-- TODO should these be On and off functions instead?
function M.toggle(line1, line2)

    -- BUG when being in simple mode. then triggering expanding.
    -- then using simple mode toggle, we get back to the original layout 
    -- origin -> simple -> expanding -> (trigger simple mode takes us to) origin, when it should be simple
    -- maybe running shouldnt be tied to toggle



    -- TODO it can actually take range here since we havent started filtering the buffer yet, 
    -- or called simple wich are doing all the padding 
    if not simple.running then
        simple.toggle()
        M.simple_toggled = true
        -- hejsan jag skriver massa kommentarer 
    end

    if M.running then
        cmd(':normal! zE')
        if M.simple_toggled then
            simple.toggle()
            M.simple_toggled = false
        end
        cmd(':normal! zz')
        M.running = false

        return
    end

    local cursor = api.nvim_win_get_cursor(0)

    print(cursor[1])
    if cursor[1] ~= 1 then
        api.nvim_win_set_cursor(0 , {line1 -1, 0})
        cmd(":normal! zfgg")
    end

    if cursor[1] ~= api.nvim_buf_line_count(0) then
        api.nvim_win_set_cursor(0 , {line2 + 1, 0})
        cmd(":normal! zfG")
    end

    api.nvim_win_set_cursor(0, cursor) -- TODO this should be middle afterwards

    M.running = true
end

return M
