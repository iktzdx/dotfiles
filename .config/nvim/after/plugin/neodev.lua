local ok, neodev = pcall(require, "neodev")
if not ok then
    return
end

neodev.setup({
    -- add any options here, or leave empty to use the default settings
    library = { plugins = { "nvim-dap-ui" }, types = true },
})
