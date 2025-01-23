-- notaker.keymaps
-- Lien Zhu

-- Create a new Note
vim.keymap.set("n", "<leader>nn", ":Note ", { noremap = true, silent = false })

-- Fuzzy find in NOTAKER_CORTEX_DIR
vim.keymap.set("n", "<leader>nf", "<cmd>FzfLua files cwd=$NOTAKER_CORTEX_DIR, glob=**/*.md<CR>", { noremap = true, silent = false })

local opts = { noremap = true, silent = true }

-- grep in NOTAKER_CORTEX_DIR
vim.keymap.set('n', '<leader>ng', function()
    local search_term = vim.fn.input("Ngrep: ")
    if search_term ~= "" then
        local cmd = string.format('vimgrep /%s/g $NOTAKER_CORTEX_DIR/**/*.md', search_term)
        vim.cmd(cmd)
        vim.cmd('copen')
    end
end, opts)

-- grep cursor, selection in NOTAKER_CORTEX_DIR
vim.keymap.set('n', '<leader>NG', ":lua vim.cmd('vimgrep /' .. vim.fn.expand('<cword>') .. '/g $NOTAKER_CORTEX_DIR/**/*')<CR>:copen<CR>", opts)
-- vim.api.nvim_set_keymap('v', '<leader>NG', '"zy:lua vim.cmd(\'vimgrep /\' .. vim.fn.escape(vim.fn.getreg("z"), "/") .. \'/g $NOTAKER_CORTEX_DIR/**/*\')<CR>:copen<CR>', opts)
vim.keymap.set('v', '<leader>NG', function()
    -- Get the visually selected text
    vim.cmd('noau normal! "vy')  -- Copy selection to register v without triggering autocommands
    local selected_text = vim.fn.escape(vim.fn.getreg('v'), '/\\')  -- Get and escape the text

    -- Run vimgrep with the selected text and open quickfix
    vim.cmd('vimgrep /' .. selected_text .. '/g $NOTAKER_CORTEX_DIR/**/*')
    vim.cmd('copen')
end, opts)
