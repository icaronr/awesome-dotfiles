local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- xrandr module
local xrandr = require("xrandr")


local mykeys = gears.table.join(
  awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
            {description="show help", group="awesome"}),
  awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
            {description = "view previous", group = "tag"}),
  awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
            {description = "view next", group = "tag"}),
  awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
            {description = "go back", group = "tag"}),

  awful.key({ modkey,           }, "j",
      function ()
          awful.client.focus.byidx( 1)
      end,
      {description = "focus next by index", group = "client"}
  ),
  awful.key({ modkey,           }, "k",
      function ()
          awful.client.focus.byidx(-1)
      end,
      {description = "focus previous by index", group = "client"}
  ),
  awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
            {description = "show main menu", group = "awesome"}),

  -- Layout manipulation
  awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
            {description = "swap with next client by index", group = "client"}),
  awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
            {description = "swap with previous client by index", group = "client"}),
  awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
            {description = "focus the next screen", group = "screen"}),
  awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
            {description = "focus the previous screen", group = "screen"}),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
            {description = "jump to urgent client", group = "client"}),
  awful.key({ modkey,           }, "Tab",
      function ()
          awful.client.focus.history.previous()
          if client.focus then
              client.focus:raise()
          end
      end,
      {description = "go back", group = "client"}),
  awful.key({ modkey }, "a",
      function ()
          awful.layout.set(awful.layout.suit.corner.nw)
          for _, c in ipairs(client.get()) do
              if c.maximized then
                  c.maximized = not c.maximized
                  c:raise()
              end 
          end
      end,
     {description = "show all open windows of workspace", group = "client"}),

  -- Standard program
  awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
            {description = "open a terminal", group = "launcher"}),
  awful.key({ modkey,           }, "z", function () awful.spawn(terminal) end,
            {description = "open a terminal", group = "launcher"}),
  awful.key({ modkey, "Control" }, "r", awesome.restart,
            {description = "reload awesome", group = "awesome"}),
  awful.key({ modkey, "Shift"   }, "q", awesome.quit,
            {description = "quit awesome", group = "awesome"}),

  awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)                 end,
            {description = "increase master width factor", group = "layout"}),
  awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)                 end,
            {description = "decrease master width factor", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true)        end,
            {description = "increase the number of master clients", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true)        end,
            {description = "decrease the number of master clients", group = "layout"}),
  awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)           end,
            {description = "increase the number of columns", group = "layout"}),
  awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)           end,
            {description = "decrease the number of columns", group = "layout"}),
  awful.key({ modkey     }, "b", function () awful.spawn(browser)          end,
            {description = "launch Browser", group = "launcher"}),
  awful.key({ modkey, "Control"}, "Escape", function () awful.spawn("/usr/bin/rofi -show drun -modi drun") end,
            {description = "launch rofi", group = "launcher"}),
  awful.key({ modkey,           }, "e", function () awful.spawn("/usr/bin/thunar")            end,
            {description = "launch filemanager", group = "launcher"}),
  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                       end,
            {description = "select previous", group = "layout"}),
  awful.key({                   }, "Print", function () awful.spawn("/usr/bin/i3-scrot -d")   end,
            {description = "capture a screenshot", group = "screenshot"}),
  awful.key({"Control"          }, "Print", function () awful.spawn("/usr/bin/i3-scrot -w")   end,
            {description = "capture a screenshot of active window", group = "screenshot"}),
  awful.key({"Shift"            }, "Print", function () awful.spawn("/usr/bin/i3-scrot -s")   end,
            {description = "capture a screenshot of selection", group = "screenshot"}),

  awful.key({ modkey, "Control" }, "n",
            function ()
                local c = awful.client.restore()
                -- Focus restored client
                if c then
                    client.focus = c
                    c:raise()
                end
            end,
            {description = "restore minimized", group = "client"}),

  -- Prompt
  awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
            {description = "run prompt", group = "launcher"}),

  awful.key({ modkey }, "ö",
            function ()
                awful.prompt.run {
                  prompt       = "Run Lua code: ",
                  textbox      = awful.screen.focused().mypromptbox.widget,
                  exe_callback = awful.util.eval,
                  history_path = awful.util.get_cache_dir() .. "/history_eval"
                }
            end,
            {description = "lua execute prompt", group = "awesome"}),
  -- Menubar
  awful.key({ modkey }, "o", function() menubar.show() end,
            {description = "show the menubar", group = "launcher"}),
  -- Xrandr
  awful.key({ modkey }, "p", function() xrandr.xrandr() end,
            {description = "xrandr display", group = "xrandr"}),
  -- ALSA volume control
  awful.key({ }, "XF86AudioRaiseVolume",
      function ()
          os.execute(string.format("amixer -q set %s 2%%+", "Master"))
       end,
          {description = "volume up", group = "hotkeys"}),
  awful.key({ }, "XF86AudioLowerVolume",
      function ()
          os.execute(string.format("amixer -q set %s 2%%-", "Master"))
      end,
      {description = "volume down", group = "hotkeys"}),
  awful.key({ }, "XF86AudioMute",
      function ()
          os.execute(string.format("amixer -q set %s toggle", "Master"))
      end,
      {description = "toggle mute", group = "hotkeys"}),
  awful.key({ altkey, "Control" }, "m",
      function ()
          os.execute(string.format("amixer -q set %s 100%%", "Master"))
      end,
      {description = "volume 100%", group = "hotkeys"}),
  awful.key({ altkey, "Control" }, "0",
      function ()
          os.execute(string.format("amixer -q set %s 0%%", "Master"))
      end,
      {description = "volume 0%", group = "hotkeys"}),
  -- Brightness
  awful.key({ }, "XF86MonBrightnessUp",
      function ()
          os.execute(string.format("xbacklight +10"))
       end,
          {description = "Brightness up", group = "hotkeys"}),
  awful.key({ }, "XF86MonBrightnessDown",
      function ()
          os.execute(string.format("xbacklight -10"))
      end,
      {description = "Brightness down", group = "hotkeys"})
)

return mykeys