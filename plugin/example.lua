-- this gets loaded on the import
M = {
    num = 0
    -- keep center window and buffer id.
    -- keep pref state
    -- keep the  state of lualine
}

-- TODO skapa buffrar som inte är modifierbara
function In(v)
        print(vim.inspect(v))
end
local function split_window(window, direction)
    vim.api.nvim_set_current_win(window)
    vim.cmd('vsplit')
end
local function resize_window(measurements)
    measurements.height = 1;
end
local f = function()

    -- TODO how can i save all the old settings here to be reset later?
    local prevsplitright = vim.opt.splitright
    local prevsplitbelow = vim.opt.splitbelow

    -- save the buffer
    local focused_buf = vim.api.nvim_get_current_buf()

    -- create a new tab that we use 
    vim.cmd("tabnew")
    -- regular split, 
    vim.opt.splitright = false
    local empty_created_buf = vim.api.nvim_win_get_buf(vim.api.nvim_get_current_win())
    vim.cmd('vsplit')
    -- insert buffer to window
    -- split with empty buf

    -- verkar vara en setting om vilket håll jag ska splitta åt , kan använda denn inställning för att centrera

    vim.opt.splitright = true
    vim.cmd('vsplit')

    local curr_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(curr_win, focused_buf)



    --TODO graceful shutdown, buffers ska förstöras efter här ?
       -- remap :q to shutdown the view
    -- close the window im focusing
    -- delete open buffers
    -- close the tab


    -- vim.api.nvim_buf_delete(empty_created_buf, {})



    -- resets all the old settings global settings

    vim.opt.splitright = prevsplitright
    vim.opt.splitbelow = prevsplitbelow
end

function M.reset_m()
    M.num = 0
    print(M.asd)
end


vim.keymap.set('n', 'gz', f)
vim.keymap.set('n', 'gt', M.reset_m)
return M





























