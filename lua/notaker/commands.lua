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

    -- Extract the directory path from the filename
    local dir = vim.fn.fnamemodify(filename, ":h")

    -- Ensure the directory exists, create it if necessary
    if vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, "p") -- "p" creates intermediate directories as needed
    end

    vim.cmd("edit " .. vim.fn.fnameescape(filename))
end

vim.api.nvim_create_user_command(
    "Note",
    create_note,
    { nargs = 1, complete = "file" } -- Command options (requires one argument)
)
