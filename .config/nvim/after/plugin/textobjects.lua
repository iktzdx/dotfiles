require 'nvim-treesitter.configs'.setup {
    textobjects = {
        swap = {
            enable = true,
            swap_next = {
                ["<leader>na"] = "@parameter.inner", -- swap parameters/arguments with next
                ["<leader>nm"] = "@function.outer",  -- swap function/method with next

            },
            swap_previous = {
                ["<leader>pa"] = "@parameter.inner", -- swap parameters/arguments with previous
                ["<leader>pm"] = "@function.outer",  -- swap function/method with previous
            }
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplits
            goto_next_start = {
                ["]f"] = { query = "@call.outer", desc = "move cursor to the beginning of the next function call" },
                ["]m"] = { query = "@function.outer", desc =
                "move cursor to the beginning of the next method definition" },
                ["]c"] = { query = "@class.outer", desc = "move cursor to the beginning of the next class" },
                ["]i"] = { query = "@conditional.outer", desc =
                "move cursor to the beginning of the next conditional" },
                ["]l"] = { query = "@loop.outer", desc = "move cursor to the beginning of the next loop" },
                ["]s"] = { query = "@scope", query_group = "locals", desc =
                "move cursor to the beginning of the next scope" },
                ["]z"] = { query = "@fold", query_group = "folds", desc =
                "move cursor to the beginning of the next fold" },
            },
            goto_next_end = {
                ["]F"] = { query = "@call.outer", desc = "move cursor to the end of the next function call" },
                ["]M"] = { query = "@function.outer", desc =
                "move cursor to the end of the next method definition" },
                ["]C"] = { query = "@class.outer", desc = "move cursor to the end of the next class" },
                ["]I"] = { query = "@conditional.outer", desc =
                "move cursor to the end of the next conditional" },
                ["]L"] = { query = "@loop.outer", desc = "move cursor to the end of the next loop" },
            },
            goto_previous_start = {
                ["[f"] = { query = "@call.outer", desc = "move cursor to the beginning of the previous function call" },
                ["[m"] = { query = "@function.outer", desc =
                "move cursor to the beginning of the previous method definition" },
                ["[c"] = { query = "@class.outer", desc = "move cursor to the beginning of the previous class" },
                ["[i"] = { query = "@conditional.outer", desc =
                "move cursor to the beginning of the previous conditional" },
                ["[l"] = { query = "@loop.outer", desc = "move cursor to the beginning of the previous loop" },
            },
            goto_previous_end = {
                ["[F"] = { query = "@call.outer", desc = "move cursor to the end of the previous function call" },
                ["[M"] = { query = "@function.outer", desc =
                "move cursor to the end of the previous method definition" },
                ["[C"] = { query = "@class.outer", desc = "move cursor to the end of the previous class" },
                ["[I"] = { query = "@conditional.outer", desc =
                "move cursor to the end of the previous conditional" },
                ["[L"] = { query = "@loop.outer", desc = "move cursor to the end of the previous loop" },
            },
        },
        select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
                -- You can also use captures from other query groups like `locals.scm`
                ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                -- Target block
                ["ab"] = { query = "@block.outer", desc = "Select outer part of a block" },
                ["ib"] = { query = "@block.inner", desc = "Select inner part of a block" },
                -- Target class
                ["ac"] = { query = "@class.outer", desc = "select outer part of a class" },
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                -- Target function/method definition
                ["am"] = { query = "@function.outer", desc = "select outer part of a function definition" },
                ["im"] = { query = "@function.inner", desc = "select inner part of a function definition" },
                -- Target arguments/parameters
                ["aa"] = { query = "@parameter.outer", desc = "select outer part of a parameters/arguments" },
                ["ia"] = { query = "@parameter.inner", desc = "select inner part of a parameters/arguments" },
                -- Target function call
                ["af"] = { query = "@call.outer", desc = "select outer part of a function call" },
                ["if"] = { query = "@call.inner", desc = "select inner part of a function call" },
                -- Target loop
                ["al"] = { query = "@loop.outer", desc = "select outer part of a loop" },
                ["il"] = { query = "@loop.inner", desc = "select inner part of a loop" },
                -- Target conditional
                ["ai"] = { query = "@conditional.outer", desc = "select outer part of a conditional" },
                ["ii"] = { query = "@conditional.inner", desc = "select inner part of a conditional" },
                -- Target statement
                ["ae"] = { query = "@conditional.outer", desc = "select outer part of a statement" },
            },
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
                ['@parameter.outer'] = 'v', -- charwise
                ['@function.outer'] = 'V',  -- linewise
                ['@class.outer'] = '<c-v>', -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true of false
            include_surrounding_whitespace = true,
        },
    },
}

local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
