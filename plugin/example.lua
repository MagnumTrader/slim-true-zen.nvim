-- this gets loaded on the import
M = {
    focus_width = 0.4,
    windows = {},
    tab = {},
    -- curfile, if i change file in zen mode, should that be applied to the window i came from?
}
-- TODO här kan jag se om jag ska öppna upp den igen 
M.running = false



local opt = vim.opt
local api = vim.api
local cmd = vim.cmd

-- splitting and adding the padding to a window
-- leftabove if vnew = left, new = above
-- rightbelow if vnew = right, new = below
-- 
-- returns the created window id
-- Credit insperation for function: https://github.com/pocco81/true-zen.nvim

local function add_padding(command, props, move)
    opt.number = false
    opt.relativenumber = false
    opt.modified = false
    opt.cursorline = false
    -- api.nvim_buf_set_option(api.nvim_get_current_buf(), "readonly", true)
    opt.fillchars = { eob = ' ', vert = ' ' }

    cmd(command)

    local new_window = vim.api.nvim_get_current_win()

    if  props.height ~= nil then
        api.nvim_win_set_height(0, props.height)
    end
    if props.width ~= nil then
        api.nvim_win_set_width(0, props.width)
    end

    -- moves back to the intended focus window
    cmd(move)


    return new_window

    --TODO, ska man verkligen vara anvarig för detta? kanske bättre att välja left top bot right?
    --if left move = l if top move = j
    --[[        detta används idag, kommando först för att splitta, sedan också ett kommande
        för att gå tillbaka till mitten 
        win.left = pad_win("leftabove vnew", { width = left_padding }, "wincmd l") -- left buffer
        win.right = pad_win("vnew", { width = right_padding }, "wincmd h") -- right buffer
        win.top = pad_win("leftabove new", { height = top_padding }, "wincmd j") -- top buffer
        win.bottom = pad_win("rightbelow new", { height = bottom_padding }, "wincmd k") -- bottom buffer

    --]]
end


-- creating the layout for my zen mode 
function M.layout()


    local old_fillchars = opt.fillchars

    -- set the width of that buffer
    -- win.left = pad_win("leftabove vnew", { width = left_padding }, "wincmd l") -- left buffer

    -- TODO how can i save all the old settings here to be reset later?
    local prevsplitright = opt.splitright
    local prevsplitbelow = opt.splitbelow

    opt.splitright = true
    opt.splitbelow = true


    -- save the buffer
    local focused_buf = api.nvim_get_current_buf()

    -- create a new tab that we use 
    cmd("tabnew")

    -- Calculating width of window, implement this instead
    --print(vim.api.nvim_win_get_width(0) * 0.6)

    --TODO i should actually decide in the config how large the focus window should be, and then align accordingly if < window then = window width
    M.windows.left = add_padding("leftabove vsplit", {width = 60}, "wincmd l")
    M.windows.right = add_padding("rightbelow vsplit", {width = 60}, "wincmd h")
    M.windows.top = add_padding("leftabove split", {height = 2}, "wincmd j")
    M.windows.bottom = add_padding("rightbelow split", {height = 2}, "wincmd k")

    local curr_win = api.nvim_get_current_win()
    api.nvim_win_set_buf(curr_win, focused_buf)

    opt.splitright = prevsplitright
    opt.splitbelow = prevsplitbelow
end

function M.close()
    -- do closing stuff
    -- if only tab, probably not right
    local buf_to_del = vim.api.nvim_win_get_buf(M.windows.left)
    vim.api.nvim_buf_delete(buf_to_del, {force=true})
    cmd('tabclose')
end

function M.restore_settings()
end
function M.save_settings()
    --settings to save,
end
function M.update()
    -- If M.width ~= win.width{update}
    -- If M.height ~= win.height{update}
end
function M.toggle()

    if M.running then
        -- do stuff to shut down
        -- close all windows, clean up buffers
        -- restore settings.

        -- M.restore_settings()
        M.close()
        M.running = false
    else
        -- save settings
        -- M.save_settings()
        -- set custom settings
        -- start everything up
        -- M.save_settings

        vim.opt.showtabline  = 0

        M.layout()
        M.running = true
    end

    --TODO graceful shutdown, buffers ska förstöras efter här ?
    -- remap :q to shutdown the view
    -- close the window im focusing
    -- delete open buffers
        -- close current buffer that is used.
        -- list all buffers in tab, delete them
    -- close the tab
end

vim.keymap.set('n', 'gz', M.toggle)


-- other mode narrow
-- folds uses zf - creation  zo - open zc - close ze remove all before closure

return M
