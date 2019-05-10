local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local lain = require("lain")

-- {{{ Variables 
local wibar_width = 36
-- }}}


-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil
    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}



-- Create a textclock widget
mytextclock = wibox.widget.textclock("%H:%M ")
-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

darkblue    = beautiful.bg_focus
blue        = "#9EBABA"
red         = "#EB8F8F"
separator = wibox.widget.textbox(' <span color="' .. blue .. '">| </span>')
spacer = wibox.widget.textbox(' <span color="' .. blue .. '"> </span>')

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
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
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    local wallpaper = '~/Pictures/Wallpaper/sunset_gran_canaria_spain.jpg' 
    gears.wallpaper.maximized('~/Pictures/Wallpaper/sunset_gran_canaria_spain.jpg', s, true)

end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "::", "{}", ">_", "@", "**"}, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist({
        screen = s, 
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        layout = wibox.layout.flex.vertical
    })
	
    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = tasklist_buttons,
        layout   = {
            spacing_widget = {
                {
                    shape        = gears.shape.circle,
                    forced_width  = 4,
                    forced_height = 4,
                    thickness     = 3,
                    color         = '#777777',
                    widget        = wibox.widget.separator
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            spacing = 20,
            layout  = wibox.layout.fixed.vertical
        },
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            {
                {
                    id     = 'clienticon',
                    widget = awful.widget.clienticon,
                },
                margins = 4,
                widget  = wibox.container.margin,
            },
            id              = 'background_role',
            forced_width    = wibar_width,
            forced_height   = wibar_width,
            widget          = wibox.container.background,
            create_callback = function(self, c, index, objects) --luacheck: no unused
                self:get_children_by_id('clienticon')[1].client = c
            end,
        },
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "left", screen = s, width = wibar_width })

    local wifi_icon = wibox.widget.imagebox()
    local eth_icon = wibox.widget.imagebox()
    local net = lain.widget.net {
        notify = "off",
        wifi_state = "on",
        eth_state = "on",
        settings = function()
            local eth0 = net_now.devices.eth0
            if eth0 then
                if eth0.ethernet then
                    local eth_icon = wibox.widget.imagebox()
                    eth_icon:set_image(ethernet_icon_filename)
                else
                    eth_icon:set_image()
                end
            end

            local wlan0 = net_now.devices.wlp3s0
            if wlan0 then
                if wlan0.wifi then
                    local signal = wlan0.signal
                    if signal < -83 then
                        wifi_icon:set_image(wifi_weak_filename)
                    elseif signal < -70 then
                        wifi_icon:set_image(wifi_mid_filename)
                    elseif signal < -53 then
                        wifi_icon:set_image(wifi_good_filename)
                    elseif signal >= -53 then
                        wifi_icon:set_image(wifi_great_filename)
                    end
                else
                    wifi_icon:set_image()
                end
            end
        end
}
    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.vertical,
        { -- Left widgets
            layout = wibox.layout.fixed.vertical,
            s.mytaglist,
        },
        s.mytasklist, -- Middle widget
        
        { -- Right widgets
            layout = wibox.layout.fixed.vertical,
            --net,
            s.mylayoutbox,
        },
    }

    s.mytopbox = awful.wibar({ position = "top", screen = s })

    s.mytopbox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mypromptbox,
        },
        net,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            mykeyboardlayout,
            separator,
            mytextclock,
            separator,
            s.mylayoutbox
        },
    }
end)
