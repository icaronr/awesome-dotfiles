local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

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

local my_tasklist = awful.widget.tasklist {
  screen   = s,
  filter   = awful.widget.tasklist.filter.currenttags,
  buttons  = tasklist_buttons,
  layout   = {
      spacing_widget = {
          {
              forced_width  = 5,
              forced_height = 24,
              thickness     = 1,
              color         = '#777777',
              widget        = wibox.widget.separator
          },
          valign = 'center',
          halign = 'center',
          widget = wibox.container.place,
      },
      spacing = 1,
      layout  = wibox.layout.fixed.horizontal
  },
  -- Notice that there is *NO* wibox.wibox prefix, it is a template,
  -- not a widget instance.
  widget_template = {
      {
          wibox.widget.base.make_widget(),
          forced_height = 5,
          id            = 'background_role',
          widget        = wibox.container.background,
      },
      {
          {
              id     = 'clienticon',
              widget = awful.widget.clienticon,
          },
          margins = 5,
          widget  = wibox.container.margin
      },
      nil,
      create_callback = function(self, c, index, objects) --luacheck: no unused args
          self:get_children_by_id('clienticon')[1].client = c
      end,
      layout = wibox.layout.align.vertical,
  },
}

return my_tasklist