-- r2pdf.commands.lua
-- Author: Lien Zhu
-- Description: This file contains user and auto commands.
-- https://github.com/nvim-neorocks/nvim-best-practices


---@class R2PDFsubcommand
---@field impl fun(args:string[], opts: table) The command implementation
---@field complete? fun(subcmd_arg_lead: string): string[] (optional) Command completions callback, taking the lead of the subcommand's arguments

---@type table<string, R2PDFsubcommand>
local subcommand_tbl = {
    render = {
        impl = require("r2pdf.rendering").render_pdf,
    },
    hot = {
        impl = require("r2pdf.setup").toggle_live,
    },
}

-- Run the (sub)command
---@param opts table :h lua-guide-commands-create
local function my_cmd(opts)
    local fargs = opts.fargs
    local subcommand_key = fargs[1]
    -- Get the subcommand's arguments, if any
    local args = #fargs > 1 and vim.list_slice(fargs, 2, #fargs) or {}
    local subcommand = subcommand_tbl[subcommand_key]
    if not subcommand then
        vim.notify("R2PDF: Unknown command: " .. subcommand_key, vim.log.levels.ERROR)
        return
    end
    -- Invoke the subcommand
    subcommand.impl(args, opts)
end


-- Register `my_cmd` to be invoked by user command 
vim.api.nvim_create_user_command("R2PDF", my_cmd, {
    nargs = "+",
    desc = "R2PDF user command with subcommand parsing",
    complete = function(arg_lead, cmdline, _)
        -- Get the subcommand.
        local subcmd_key, subcmd_arg_lead = cmdline:match("^['<,'>]*R2PDF[!]*%s(%S+)%s(.*)$")
        if subcmd_key
            and subcmd_arg_lead
            and subcommand_tbl[subcmd_key]
            and subcommand_tbl[subcmd_key].complete
        then
            return subcommand_tbl[subcmd_key].complete(subcmd_arg_lead)
        end
        -- Check if cmdline is a subcommand
        if cmdline:match("^['<,'>]*R2PDF[!]*%s+%w*$") then
            -- Filter subcommands that match
            local subcommand_keys = vim.tbl_keys(subcommand_tbl)
            return vim.iter(subcommand_keys)
                :filter(function(key)
                    return key:find(arg_lead) ~= nil
                end)
                :totable()
        end
    end,
    bang = true, -- If you want to support ! modifiers
})


-- R2PDF render autocommand
local timer = nil
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.Rmd",
  --pattern = { "rmd", "markdown" },
  callback = function()
    if timer then
      timer:stop()
    end
    timer = vim.loop.new_timer()
    timer:start(100, 0, vim.schedule_wrap(function()
        vim.cmd("R2PDF render")
    end))
  end,
})


-- Function to create and open a note file
local function create_note(args)
    local cortex_dir = os.getenv("NOTAKER_CORTEX_DIR")

    if not cortex_dir or cortex_dir == "" then
        vim.api.nvim_err_writeln("Environment variable NOTAKER_CORTEX_DIR is not set")
        return
    end

    local filename = cortex_dir .. "/" .. args.args .. ".md"

    vim.cmd("edit " .. vim.fn.fnameescape(filename))
end

vim.api.nvim_create_user_command(
    "Note",
    create_note,
    { nargs = 1, complete = "file" } -- Command options (requires one argument)
)
