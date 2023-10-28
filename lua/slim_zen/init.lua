local M = {}

local zen = require('slim_zen.simple_zen')
local expanding = require('slim_zen.expanding')

M.modes = {simple = zen, expanding = expanding}

function M.setup()
    --TODO
end

function M.simple()
    -- shut down the current expanding mode instance if simple is called
    if M.modes.expanding.running then
        M.modes.expanding.toggle()
    end
    M.modes.simple.toggle()
end
function M.expanding(args)

    local line1 = args['line1']
    local line2 = args['line2']
    expanding.toggle(line1, line2)
end

-- TODO update window sizes in realtime if resize, or typing in expanding mode
return M
