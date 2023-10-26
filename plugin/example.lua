-- this gets loaded on the import
M = {
    focus_width = 0.4,
    windows = {},
    tab = {},
}
-- TODO här kan jag se om jag ska öppna upp den igen 
M.running = false

local opt = vim.opt
local api = vim.api
local cmd = vim.cmd

local function add_padding(command, props, move)
    -- leftabove if vnew = left, new = abpve
    -- rightbelow if vnew = right, new = below
    -- splitting, focus is now on padded window
    cmd(command)

    local new_window = vim.api.nvim_get_current_win()
    if  props.height ~= nil then
        api.nvim_win_set_height(0, props.height)
    end
    if props.width ~= nil then
        api.nvim_win_set_width(0, props.width)
    end

    -- set the width of that buffer
    opt.number = false
    opt.relativenumber = false
    opt.modified = false
    opt.cursorline = false
    -- api.nvim_buf_set_option(api.nvim_get_current_buf(), "readonly", true)
    opt.fillchars = { eob = ' ', vert = ' ' }
    -- win.left = pad_win("leftabove vnew", { width = left_padding }, "wincmd l") -- left buffer

    cmd(move)

    return new_window
end

local f = function()

    local old_fillchars = opt.fillchars

    -- disable some keymaps that will interfere with the plugin

    -- set cursorline!
    -- set nonumber
    -- set norelativenumber
--[[
options from true-zen config for buffer
local opts = {
	bo = {
		buftype = "nofile",
		bufhidden = "hide",
		modifiable = false,
		buflisted = false,
		swapfile = false,
	},
	wo = {
		cursorline = false,
		cursorcolumn = false,
		number = false,
		relativenumber = false,
		foldenable = false,
		list = false,
	},
}

        detta används idag, kommando först för att splitta, sedan också ett kommande
        för att gå tillbaka till mitten 
        win.left = pad_win("leftabove vnew", { width = left_padding }, "wincmd l") -- left buffer
        win.right = pad_win("vnew", { width = right_padding }, "wincmd h") -- right buffer
        win.top = pad_win("leftabove new", { height = top_padding }, "wincmd j") -- top buffer
        win.bottom = pad_win("rightbelow new", { height = bottom_padding }, "wincmd k") -- bottom buffer
--]]



    -- TODO how can i save all the old settings here to be reset later?
    local prevsplitright = opt.splitright
    local prevsplitbelow = opt.splitbelow

    opt.splitright = true
    opt.splitbelow = true


    -- save the buffer
    local focused_buf = api.nvim_get_current_buf()

    -- create a new tab that we use 
    cmd("tabnew")

    print(vim.api.nvim_win_get_width(0) * 0.6)

    M.windows.left = add_padding("leftabove vsplit", {width = 60}, "wincmd l")
    M.windows.right = add_padding("rightbelow vsplit", {width = 30}, "wincmd h")
    M.windows.top = add_padding("leftabove split", {height = 2}, "wincmd j")
    M.windows.bottom = add_padding("rightbelow split", {height = 2}, "wincmd k")

    local curr_win = api.nvim_get_current_win()
    api.nvim_win_set_buf(curr_win, focused_buf)

    cmd("")

    --TODO graceful shutdown, buffers ska förstöras efter här ?
    -- remap :q to shutdown the view
    -- close the window im focusing
    -- delete open buffers
        -- close current buffer that is used.
        -- list all buffers in tab, delete them
    -- close the tab


    -- api.nvim_buf_delete(empty_created_buf, {})



    -- resets all the old settings global settings

    opt.splitright = prevsplitright
    opt.splitbelow = prevsplitbelow


end


local function del_buffers_in_cur_tab()
    local windows = vim.api.nvim_tabpage_list_wins(0)
    for _, window in pairs(windows) do
        vim.api.nvim_buf_delete(vim.api.nvim_win_get_buf(window), {})
        print(vim.api.nvim_win_get_buf(window))
    end
end

vim.keymap.set('n', 'gz', f)

function M.toggle()
    
end

return M
