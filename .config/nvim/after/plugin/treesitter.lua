require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = {
        "bash",
        "dockerfile",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
    },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,
    -- enable highlighting
    highlight = {
        -- `false` will disable the whole extension
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    -- enable indentation
    indent = { enable = true },
    -- add incremental selection
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<leader>is", -- set to `false` to disable one of the mappings
            node_incremental = "<leader>ni",
            scope_incremental = false,
            node_decremental = "<leader>nd",
        },
    },
}
