
if vim.g.loaded_simple_zen then
  return
end
vim.g.loaded_simple_zen = true

local command = vim.api.nvim_create_user_command
-- create the commands needed to use keybindings

command("SlimZen", function ()
    require('slim_zen.slim_zen_mode').toggle()
end, {})

command("SlimZenExpanding", function ()
    require('simple_zen').Expanding()
    -- this one for updateing the window and counting the rows
    -- autocmd CursorMoved * lua require("zen-mode.view").fix_layout()
    -- from folke zen
end, {range = true})



