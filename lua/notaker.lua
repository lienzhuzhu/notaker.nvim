-- notaker.lua
-- Author: Lien Zhu
-- Description: notaker NeoVim plugin entry point.


local _setup_mod = require("notaker.setup")

local function setup(opts)
    _setup_mod.setup(opts)
    require("notaker.commands")
    require("notaker.keymaps")
end

return {
    setup = setup,
}
