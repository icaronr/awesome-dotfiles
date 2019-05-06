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


local tlist = awful.popup {
  widget = awful.widget.tasklist {
      screen   = screen[1],
      filter   = awful.widget.tasklist.filter.allscreen,
      buttons  = tasklist_buttons,
      style    = {
          shape = gears.shape.partially_rounded_rect,
      },
      layout   = {
          spacing = 10,
          forced_num_rows = 1,
          layout = wibox.layout.flex.vertical
      },
      widget_template = {
          {
              {
                  id     = 'clienticon',
                  widget = awful.widget.clienticon,
              },
              margins = 2,
              widget  = wibox.container.margin,
          },
          id              = 'background_role',
          forced_width    = 32,
          forced_height   = 32,
          widget          = wibox.container.background,
          create_callback = function(self, c, index, objects) --luacheck: no unused
              self:get_children_by_id('clienticon')[1].client = c
          end,
      },
  },
  border_color = '#777777',
  border_width = 0,
  ontop        = false,
  placement    = awful.placement.left,
  shape        = gears.shape.partially_rounded_rect
}

return tlist