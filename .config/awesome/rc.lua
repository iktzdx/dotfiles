-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")
require("battery")
local net_widgets = require("net_widgets")
local lain = require("lain")
local sharedtags = require("sharedtags")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors,
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err),
        })
        in_error = false
    end)
end
-- }}}

-- Notification icon sizing
naughty.config.defaults["icon_size"] = 50
naughty.config.defaults["bg"] = "#212426"
naughty.config.defaults["max_height"] = 640
naughty.config.defaults["max_width"] = 360

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(awful.util.getdir("config") .. "themes/nordish/theme.lua")

-- This is used later as the default terminal and editor to run.
editor = "nvim" or os.getenv("EDITOR")
terminal = "alacritty"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    --- awful.layout.suit.tile.bottom,
    --- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    --- awful.layout.suit.fair.horizontal,
    --- awful.layout.suit.spiral,
    --- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    --- awful.layout.suit.max.fullscreen,
    --- awful.layout.suit.magnifier,
    --- awful.layout.suit.corner.nw,
    --- awful.layout.suit.corner.ne,
    --- awful.layout.suit.corner.sw,
    --- awful.layout.suit.corner.se,
    -- lain.layout.termfair,
    lain.layout.termfair.center,
    -- lain.layout.cascade,
    --- lain.layout.cascade.tile,
    --- lain.layout.centerwork,
    --- lain.layout.centerwork.horizontal,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create separator widget
spacer = wibox.widget.textbox()
spacer:set_text(" : ")

-- Create battery text widget
batterywidget = wibox.widget.textbox()

-- Wireless widget
net_wireless = net_widgets.wireless({
    interface = "wlp7s0",
    indent = 4,
})
net_wired = net_widgets.indicator({
    interfaces = { "enp8s0" },
    skiproutes = false,
    timeout = 5,
})
net_vpn = net_widgets.indicator({
    interfaces = { "tun0" },
    skipvpncheck = false,
    skiproutes = false,
    skipcmdline = false,
    timeout = 5,
})
net_internet = net_widgets.internet({
    timeout = 5,
    showconnected = true,
})

-- Battery widget
batterywidget_timer = timer({ timeout = 1 })
batterywidget_timer:connect_signal("timeout", function()
    batterywidget:set_text(batteryInfo("BAT0"))
end)
batterywidget_timer:start()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t)
        awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({}, 3, client_menu_toggle_fn()),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end)
)

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Add tags to each screen
local tags = sharedtags({
    { name = "🌐", screen = 1, layout = awful.layout.suit.max },
    { name = "MGS", screen = 1, layout = lain.layout.termfair.center },
    { name = "DEV", screen = 1, layout = awful.layout.suit.tile },
    { name = "TXT", screen = 1, layout = awful.layout.suit.max },
    { name = "IMG", screen = 1, layout = awful.layout.suit.max },
    { name = "VM", screen = 1, layout = awful.layout.suit.floating },
    { name = "👾", screen = 1, layout = awful.layout.suit.floating },
})

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 3, function()
            awful.layout.inc(-1)
        end),
        awful.button({}, 4, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 5, function()
            awful.layout.inc(-1)
        end)
    ))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style = {
            tasklist_disable_icon = true,
        },
    })

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
    })

    -- Add widgets to the wibox
    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        {             -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spacer,
            wibox.container.margin(net_wireless, 0, 0, 4, 2),
            spacer,
            wibox.container.margin(net_wired, 0, 0, 4, 2),
            spacer,
            wibox.container.margin(net_vpn, 0, 0, 4, 2),
            spacer,
            wibox.container.margin(net_internet, 0, 0, 4, 2),
            spacer,
            mykeyboardlayout,
            spacer,
            wibox.container.margin(batterywidget, 0, 0, 4, 2),
            spacer,
            wibox.container.margin(wibox.widget.systray(), 4, 2, 4, 2),
            mytextclock,
            s.mylayoutbox,
        },
    })
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({}, 3, function()
        mymainmenu:toggle()
    end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
    awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
    awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
    awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
    awful.key({ modkey }, "j", function()
        awful.client.focus.byidx(1)
    end, { description = "focus next by index", group = "client" }),
    awful.key({ modkey }, "k", function()
        awful.client.focus.byidx(-1)
    end, { description = "focus previous by index", group = "client" }),
    awful.key({ modkey }, "w", function()
        mymainmenu:show()
    end, { description = "show main menu", group = "awesome" }),

    -- Volume Keys
    awful.key({}, "XF86AudioRaiseVolume", function()
        awful.util.spawn("amixer set Master 5%+")
    end),
    awful.key({}, "XF86AudioLowerVolume", function()
        awful.util.spawn("amixer set Master 5%-")
    end),
    awful.key({}, "XF86AudioMute", function()
        awful.util.spawn("amixer set Master toggle")
    end),
    --   awful.key({}, "XF86AudioMicMute",        function ()
    awful.key({ modkey }, "F4", function()
        awful.util.spawn("pactl set-source-mute 1 toggle")
    end),

    -- Media Keys
    awful.key({}, "XF86AudioPlay", function()
        awful.util.spawn("mpc toggle")
    end),
    awful.key({}, "XF86AudioNext", function()
        awful.util.spawn("mpc next")
    end),
    awful.key({}, "XF86AudioPrev", function()
        awful.util.spawn("mpc prev")
    end),
    awful.key({}, "XF86AudioStop", function()
        awful.util.spawn("mpc stop")
    end),

    -- Brightness
    -- awful.key({}, "XF86MonBrightnessDown", function ()
    awful.key({ modkey }, "F5", function()
        awful.util.spawn("light -U 10")
    end),
    -- awful.key({}, "XF86MonBrightnessUp", function ()
    awful.key({ modkey }, "F6", function()
        awful.util.spawn("light -A 10")
    end),

    -- Screenshot
    awful.key({}, "Print", function()
        awful.util.spawn("flameshot gui")
    end),

    -- Messengers
    awful.key({ modkey, "Shift" }, "t", function()
        awful.util.spawn("telegram-desktop")
    end),
    -- File Manager
    awful.key({ modkey }, "e", function()
        awful.util.spawn("thunar")
    end),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function()
        awful.client.swap.byidx(1)
    end, { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function()
        awful.client.swap.byidx(-1)
    end, { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, "Control" }, "j", function()
        awful.screen.focus_relative(1)
    end, { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "k", function()
        awful.screen.focus_relative(-1)
    end, { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey }, "Tab", function()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end, { description = "go back", group = "client" }),

    -- Standard program
    awful.key({ modkey }, "Return", function()
        awful.spawn(terminal)
    end, { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey }, "l", function()
        awful.tag.incmwfact(0.05)
    end, { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey }, "h", function()
        awful.tag.incmwfact(-0.05)
    end, { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function()
        awful.tag.incnmaster(1, nil, true)
    end, { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift" }, "l", function()
        awful.tag.incnmaster(-1, nil, true)
    end, { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function()
        awful.tag.incncol(1, nil, true)
    end, { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l", function()
        awful.tag.incncol(-1, nil, true)
    end, { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey }, "space", function()
        awful.layout.inc(1)
    end, { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space", function()
        awful.layout.inc(-1)
    end, { description = "select previous", group = "layout" }),

    awful.key({ modkey, "Control" }, "n", function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            client.focus = c
            c:raise()
        end
    end, { description = "restore minimized", group = "client" }),

    -- Prompt
    awful.key({ modkey }, "r", function()
        awful.screen.focused().mypromptbox:run()
    end, { description = "run prompt", group = "launcher" }),

    awful.key({ modkey }, "x", function()
        awful.prompt.run({
            prompt = "Run Lua code: ",
            textbox = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval",
        })
    end, { description = "lua execute prompt", group = "awesome" })
)

clientkeys = gears.table.join(
    awful.key({ modkey }, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, "Shift" }, "c", function(c)
        c:kill()
    end, { description = "close", group = "client" }),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle, function(p)
        awful.placement.centered(p, nil)
    end, { description = "toggle floating", group = "client", floating = true }),
    awful.key({ modkey, "Control" }, "Return", function(c)
        c:swap(awful.client.getmaster())
    end, { description = "move to master", group = "client" }),
    awful.key({ modkey }, "o", function(c)
        c:move_to_screen()
    end, { description = "move to screen", group = "client" }),
    awful.key({ modkey }, "t", function(c)
        c.ontop = not c.ontop
    end, { description = "toggle keep ontop", group = "client" }),
    awful.key({ modkey }, "n", function(c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
    end, { description = "minimize", group = "client" }),
    awful.key({ modkey }, "m", function(c)
        c.maximized = not c.maximized
        c:raise()
    end, { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control" }, "m", function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift" }, "m", function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(
        globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end, { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end, { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end, { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = tags[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end, { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        client.focus = c
        c:raise()
    end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            -- turn off margin
            size_hints_honor = false,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        },
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",   -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
            },
            class = {
                "Arandr",
                "Gpick",
                "Kruler",
                "MessageWin", -- kalarm.
                "Sxiv",
                "Wpa_gui",
                "pinentry",
                "veromix",
                "xtightvncviewer",
                "VirtualBox Manager",
            },

            name = {
                "Event Tester", -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "pop-up",      -- e.g. Google Chrome's (detached) Developer Tools.
            },
        },
        properties = { floating = true },
    },

    -- Add titlebars to normal clients and dialogs
    { rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = false } },
    -- { rule = { instance = "firefox" }, properties = { tag = tags["🌐"] } },
    { rule = { instance = "xreader" },              properties = { tag = tags["DEV"] } },
    {
        rule = { class = "mpv" },
        properties = { tag = tags["👾"] },
        callback = function(cli)
            awful.placement.centered(cli, nil)
        end,
    },
    -- {
    -- 	rule = { class = "Alacritty" },
    -- 	properties = { floating = true, width = 960, height = 480 },
    -- 	callback = function(t)
    -- 		awful.placement.centered(t, nil)
    -- 	end,
    -- },
    {
        rule_any = {
            name = { "Open Folder", "Choose Files", "Save As", "Open Document" },
            type = { "dialog", "splash" },
        },
        properties = { floating = true },
        callback = function(w)
            awful.placement.centered(w, nil)
        end,
    },
    { rule = { class = "Steam" }, properties = { tag = tags["👾"] } },
    { rule = { class = "keepassxc" }, properties = { floating = true } },
    {
        rule_any = { class = { "Telegram", "TelegramDesktop" } },
        properties = { tag = tags["MGS"] }
    },
    {
        rule_any = { class = { "pachca", "pachca" } },
        properties = { tag = tags["MGS"] }
    },
    {
        rule_any = { class = { "transmission-gtk", "Transmission-gtk" } },
        properties = { tag = tags["👾"] }
    },
    {
        rule_any = {
            class = { "Gajim" },
            role = { "roster", "messages" },
        },
        properties = { tag = tags["MGS"] },
    },
    {
        rule_any = { class = { "VirtualBox", "VirtualBox Manager", "VirtualBox Machine" } },
        properties = { tag = tags["VM"] },
        callback = function(vb)
            awful.placement.centered(vb, nil)
        end,
    },
    {
        rule_any = { class = { "obsidian", "obsidian" } },
        properties = { tag = tags["TXT"] },
    },
    {
        rule_any = { class = { "gimp", "Gimp" } },
        properties = { tag = tags["IMG"] },
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c):setup({
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal,
        },
        {     -- Middle
            { -- Title
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c),
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal,
        },
        { -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal(),
        },
        layout = wibox.layout.align.horizontal,
    })
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
    c.opacity = 1
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    c.opacity = 1
end)

awful.spawn.with_shell(
    'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;'
    .. 'xrdb -merge <<< "awesome.started:true";'
    .. "picom --experimental-backends --config /home/kurisumasu/.config/picom/picom.conf -b;"
--    .. "picom -b;"
-- 'easyeffects --gapplication-service &'
)
-- }}}
