-- this gets loaded on the import



M = {
    num = 0
    -- keep the  state of lualine
}

local f = function()
    print('hej M.num is:  ' .. M.num)
    M.num = M.num + 1
end

local function reset_m()
    M.num = 0 
end

vim.keymap.set('n', 'gz', f)
vim.keymap.set('n', 'gt', reset_m)


-- TODO, jag kan göra en enkel todo app:?
-- th






























