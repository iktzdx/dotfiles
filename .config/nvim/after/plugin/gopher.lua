require("gopher").setup {
    commands = {
        go = "go",
        gomodifytags = "gomodifytags",
        gotests = "/home/kurisumasu/.local/bin/gotests", -- also you can set custom command path
        impl = "impl",
        iferr = "iferr",
    },
}

vim.keymap.set("n", "<leader>tj", "<cmd> GoTagAdd json <CR>")
vim.keymap.set("n", "<leader>ty", "<cmd> GoTagAdd yaml <CR>")

vim.keymap.set("n", "<leader>ie", "<cmd> GoIfErr <CR>")
