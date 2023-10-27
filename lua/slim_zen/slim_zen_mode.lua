M = {
    focus_width = 0.4,
    windows = {},
    tab = {},
}
M.running = false
local opt = vim.opt
local api = vim.api
local cmd = vim.cmd

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
local function add_padding(command, props, move)

    -- TODO ska dessa vara här?
    opt.number = false
    opt.relativenumber = false
    opt.modified = false
    opt.cursorline = false
    opt.fillchars = { eob = ' ', vert = ' ' }

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

    return new_window

end


-- creating the layout for my zen mode 
function M.layout()

    vim.api.nvim_create_user_command('Testing', 'echo "hellow world"', {})
    -- TODO how can i save all the old settings here to be reset later?
    local prevsplitright = opt.splitright
    local prevsplitbelow = opt.splitbelow
    opt.splitright = true
    opt.splitbelow = true


    local cursor = api.nvim_win_get_cursor(0)
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

    M.windows.main = api.nvim_get_current_win()

    api.nvim_win_set_buf(M.windows.main, focused_buf)
    api.nvim_win_set_cursor(M.windows.main, cursor)


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
        vim.opt.showtabline  = 1
    else
        vim.opt.showtabline  = 0

        M.layout()
        M.running = true
    end
end


return M
