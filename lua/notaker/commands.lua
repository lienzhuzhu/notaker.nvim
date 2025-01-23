-- notaker.commands
-- Lien Zhu

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
