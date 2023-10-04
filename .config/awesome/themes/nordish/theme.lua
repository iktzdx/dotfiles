-------------------------------
--  "nordish" awesome theme  --
--   By Daniel K. (dnlklmts)   --
-- https://github.com/arcticicestudio/nord --
-------------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources   = require("beautiful.xresources")
local dpi          = xresources.apply_dpi

local gfs          = require("gears.filesystem")
local themes_path  = gfs.get_dir("config")

-- {{{ Main
local theme        = {}
theme.wallpaper    = themes_path .. "themes/nordish/bg.jpg"
-- theme.wallpaper = '~/Pictures/Wallpapers/our_dream.png'
-- theme.wallpaper    = "~/Pictures/Wallpapers/red-sky.png"


-- {{{ Styles
-- theme.font       = "Meslo LG S 8"
theme.font                  = "FiraCode Nerd Font Bold 8"

-- {{{ Colors
theme.fg_normal             = "#ECEFF4"
theme.fg_focus              = "#81a1c1"
theme.fg_urgent             = "#D08770"
theme.bg_normal             = "#2e3440"
theme.bg_focus              = "#3b4252"
theme.bg_urgent             = "#3b4252"
theme.bg_systray            = theme.bg_normal

-- {{{ Tasklist colors
theme.tasklist_fg_normal    = "#eceff4"
theme.tasklist_bg_normal    = "#2e3440"
theme.tasklist_fg_focus     = "#d8dee9"
theme.tasklist_bg_focus     = "#3b4252"

-- {{{ Borders
theme.useless_gap           = dpi(10)
theme.border_width          = 2
theme.border_normal         = "#2e3440" -- nord00
theme.border_focus          = "#3b4252" -- nord01
theme.border_marked         = "#D08770" -- nord12

-- {{{ Widgets
theme.fg_widget             = "#ECEFF4"
theme.bg_widget             = "#1e222b"

-- {{{ Mouse finder
theme.mouse_finder_color    = "#CC9393"

-- {{{ Taglist
local taglist_square_size   = dpi(4)
theme.taglist_fg_empty      = "#4c566a"

theme.taglist_squares_sel   = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal)

-- {{{ Layout
theme.layout_floating       = themes_path .. "themes/nordish/layouts/floating.png"
theme.layout_tile           = themes_path .. "themes/nordish/layouts/tile.png"
theme.layout_tileleft       = themes_path .. "themes/nordish/layouts/tileleft.png"
theme.layout_max            = themes_path .. "themes/nordish/layouts/max.png"
theme.layout_centerfair     = themes_path .. "themes/nordish/layouts/centerfair.png"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
