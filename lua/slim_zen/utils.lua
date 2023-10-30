local cmd = vim.cmd
local api = vim.api

local M = {}

-- TODO move to utils
-- splitting and adding the padding to a window
-- Returning the new windows identifying integer
--
-- commands:
-- "leftabove [newtype]" (vnew = left, new = above)
-- "rightbelow [newtype]" (vnew = right, new = below)
-- 
-- props:
-- height or width alloed. specifies how large the padding window should be.
-- no error handling, use width for vertical splits and height for horizontal
--
-- move:
-- Move to be made after window is created, 
-- created left, move right with "wincmd l"
-- created top, move down with "wincmd j"
-- created right, move left with "wincmd h"
-- created bottom, move up with "wincmd k"
-- TODO. set init window variable to M, then we just move back to it without specifying move commands
--
-- example adding padding to the left and above
-- M.windows.left = add_padding("leftabove vsplit", {width = 60}, "wincmd l")
-- M.windows.right = add_padding("rightbelow vsplit", {width = 60}, "wincmd h")
-- M.windows.top = add_padding("leftabove split", {height = 2}, "wincmd j")
-- M.windows.bottom = add_padding("rightbelow split", {height = 2}, "wincmd k")
--
--
-- returns the created window id
-- Credit, insperation for function: https://github.com/pocco81/true-zen.nvim
function M.add_padding(command, props, move)


    -- TODO if focus_props exists, utgå ifrån den och padda allt runt omkring
    -- annars låt användaren padda alla enskilda 
    cmd(command) -- creates the new split
    if  props.height ~= nil then
        api.nvim_win_set_height(0, props.height)
    end
    if props.width ~= nil then
        api.nvim_win_set_width(0, props.width)
    end

    local new_window = vim.api.nvim_get_current_win()
    -- moves back to the intended focus window
    cmd(move)


    -- TODO seperate creation of windows and sizing them
    return new_window

end

function M.pad_test(windows, size)
    -- Pass the windows from main module

end

return M
