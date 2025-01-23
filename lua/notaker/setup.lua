-- notaker/setup.lua
-- Author: Lien Zhu
-- Description: Logic for setup and configuration of notaker.


local _config = {
    default_keymaps = true,
}

local _setup = function (opts)
    _config = vim.tbl_deep_extend("force", _config, opts or {})
end

return {
    setup = _setup
}
