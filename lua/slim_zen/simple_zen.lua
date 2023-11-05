local opt = vim.opt
local api = vim.api
local cmd = vim.cmd

local add_padding = require('slim_zen.utils').add_padding


M = {
    focus_width = 0.4,
    windows = {},
    tab = {},
}
M.running = false


-- creating the layout for my zen mode 
function M.layout()

    -- TODO ska dessa vara här?
    opt.number = false
    opt.relativenumber = false
    opt.modified = false

    -- opt.cursorline = false
    opt.fillchars = { eob = ' ', vert = ' ' }


    local prevsplitright = opt.splitright
    local prevsplitbelow = opt.splitbelow
    opt.splitright = true
    opt.splitbelow = true


    local cursor = api.nvim_win_get_cursor(0)
    -- save the buffer
    local focused_buf = api.nvim_get_current_buf()


    -- create a new tab that we use 
    cmd("tabnew")

    M.windows.left = add_padding("leftabove vsplit", {width = 70}, "wincmd l")
    M.windows.right = add_padding("rightbelow vsplit", {width = 70}, "wincmd h")
    M.windows.top = add_padding("leftabove split", {height = 1}, "wincmd j")
    M.windows.bottom = add_padding("rightbelow split", {height = 1}, "wincmd k")

    M.windows.main = api.nvim_get_current_win()

    api.nvim_win_set_buf(M.windows.main, focused_buf)
    api.nvim_win_set_cursor(M.windows.main, cursor)

    opt.number = true
    opt.relativenumber = true

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

function M.toggle()

    if M.running then
        M.close()
        M.running = false
        -- TODO reset settings
        vim.opt.showtabline  = 1
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.cursorline = true
    else
        -- TODO set relevant settings
        -- TODO backup old settings
        vim.opt.showtabline  = 0

        M.layout()
        M.running = true
    end
end


return M
