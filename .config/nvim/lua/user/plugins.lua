local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

local plugins = {
    -- Fuzzy-finder
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0', -- or branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    -- Colors
    'navarasu/onedark.nvim',
    {
        "nvim-lualine/lualine.nvim", -- Fast and easy to configure neovim statusline
        dependencies = { "kyazdani42/nvim-web-devicons", disable = false, opt = true },
    },
    -- Highlight syntax
    {
        'nvim-treesitter/nvim-treesitter',
        event = { "BufReadPre", "BufNewFile" },
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    },
    -- Highlight current context using tree-sitter
    'nvim-treesitter/nvim-treesitter-context',

    -- Add text objects via tree-sitter
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        init = function()
            -- leave it empty
        end
    },

    -- Add/change/delete surrounding delimiter pairs with ease
    {
        -- https://github.com/kylechui/nvim-surround/blob/main/doc/nvim-surround.txt
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    },
    -- Jump between buffers with ez
    'theprimeagen/harpoon',
    -- Navigate thro undo changes
    'mbbill/undotree',
    -- Git integration
    'tpope/vim-fugitive',
    -- LSP Support
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    -- Autocompletion
    'hrsh7th/nvim-cmp',

    -- Snippets
    {
        'L3MON4D3/LuaSnip',
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
            require("user.luasnip").luasnip(opts)
        end,
    },
    'rafamadriz/friendly-snippets',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',

    -- Auto-pair brackets
    'windwp/nvim-autopairs',

    -- Golang integration
    {
        "olexsmir/gopher.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },

    -- Comment plugin that supports treesitter, dot repeat, left-right/up-down motions, etc.
    {
        'numToStr/Comment.nvim',
        opts = {},
        lazy = false,
    },

    -- Treat indentation as a text object
    -- https://github.com/michaeljsmith/vim-indent-object#usage
    -- 'michaeljsmith/vim-indent-object',
}


local opts = {}
require("lazy").setup(plugins, opts)
