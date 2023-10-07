-- Normal
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "J", "mzJ`z")
-- Hold cursor in the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- open the current split into its own tab (for dap-ui)
vim.keymap.set("n", "<leader>tn", ":tabnew %<CR>")
-- close the current tab
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Open terminal in split window
vim.keymap.set("n", "<Leader>vst", ":vsplit term://zsh<CR>")
vim.keymap.set("n", "<Leader>hst", ":split term://zsh<CR>")

-- Resize window with arrows
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>")
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>")
vim.keymap.set("n", "<S-h>", ":bprevious<CR>")

-- Ctrl-F to swap tmux sessions
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Insert
-- Press jk fast to enter
vim.keymap.set("i", "jk", "<ESC>")

-- Visual --
-- Stay in indent mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Move text up and down
vim.keymap.set("v", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("v", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("v", "p", '"_dP') -- change default yank/paste behavior

-- Visual Block --
-- Move text up and down
vim.keymap.set("x", "<S-j>", ":move '>+1<CR>gv-gv")
vim.keymap.set("x", "<S-k>", ":move '<-2<CR>gv-gv")
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv")
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv")
