-- r2pdf.lua
-- Author: Lien Zhu
-- Description: r2pdf NeoVim plugin entry point.


local _setup = require("r2pdf.setup")

local function setup(opts)
    _setup.update_config(opts)
    require("r2pdf.commands")
end

return {
    setup = setup,
    print_config = _setup.print_config,
}
