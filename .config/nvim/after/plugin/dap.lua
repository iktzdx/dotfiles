local ok, dap = pcall(require, "dap")
if not ok then
    return
end

-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#go-using-delve-directly
dap.adapters.delve = {
    type = 'server',
    port = '${port}',
    executable = {
        command = 'dlv',
        args = { 'dap', '-l', '127.0.0.1:${port}' },
    }
}

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
    {
        type = "delve",
        name = "Debug",
        request = "launch",
        program = "${file}"
    },
    {
        type = "delve",
        name = "Debug test", -- configuration for debugging test files
        request = "launch",
        mode = "test",
        program = "${file}"
    },
    -- works with go.mod packages and sub packages
    {
        type = "delve",
        name = "Debug test (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}"
    }
}
-- create dap highlights
vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })

-- define dap signs
vim.fn.sign_define("DapBreakpoint",
    { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition",
    { text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointRejected",
    { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
vim.fn.sign_define("DapLogPoint",
    { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" })
vim.fn.sign_define("DapStopped",
    { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

-- keymaps
vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end, { desc = "dap.toggle_breakpoint()" })
-- vim.keymap.set("n", "<leader>B", function() dap.set_breakpoint() end, { desc = "dap.set_breakpoint()" })
vim.keymap.set("n", "<leader>bf",
    function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end,
    { desc = "dap.set_breakpoint(), with condition" })
vim.keymap.set("n", "<leader>bp",
    function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end,
    { desc = "dap.set_breakpoint(log point)" })
vim.keymap.set("n", "<leader>bl", function() dap.list_breakpoints() end, { desc = "dap.list_breakpoints()" })
vim.keymap.set("n", "<leader>bc", function() dap.clear_breakpoints() end, { desc = "dap.clear_breakpoints()" })
vim.keymap.set("n", "<leader>dr", function() dap.repl.toggle() end, { desc = "dap.repl.toggle()" })
vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "dap.continue()" })
vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "dap.step_over()" })
vim.keymap.set("n", "<F11>", function() dap.step_into() end, { desc = "dap.step_into()" })
vim.keymap.set("n", "<F12>", function() dap.step_out() end, { desc = "dap.step_out()" })
-- vim.keymap.set("n", "<leader>dl", function() dap.run_last() end, { desc = "dap.run_last()" })
