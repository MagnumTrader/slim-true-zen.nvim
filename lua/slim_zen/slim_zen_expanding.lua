local api = vim.api
local command = api.nvim_create_user_command

command("Nameasdf", function (args)
    local line1 = args['line1']
    local line2 = args['line2']
    print(line1 .. "to " .. line2)
end, {
        range = true,
        bar = true
    })
