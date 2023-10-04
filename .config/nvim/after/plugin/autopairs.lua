local opts = {
    fast_wrap = {},
    disable_filetype = { "TelescopePrompt", "vim" },
}

require("nvim-autopairs").setup(opts)

-- local cmp_autopairs = require "nvim-autopairs.completion.cmp"
-- require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)
