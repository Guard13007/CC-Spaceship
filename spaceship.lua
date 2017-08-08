local monitors = {
  -- side (string) = {
  --   monitor = wrapped monitor,
  --   console = console type (string)
  -- }
}

local consoles = {
  select = {}
}

function consoles.select.touch(x, y)
  --
end

while true do
  local event, side, x, y = os.pullEvent()

  if event == "monitor_touch" then
    if monitors[side] then
      consoles[monitors[side].console].touch(x, y)
    else
      monitors[side] = {
        monitor = peripheral.wrap(side),
        console = "select"
      }
    end
  end
end

--[[
Each console table additionally has a buffer it can use to write to the monitors (hopefully a window object is easy to redraw and move around?) And update methods to make sure the display is up to date.

All monitors should actually have both keyed tables so that touch events know which console to go to. Setting it up this way also allows for future expansion, such as allowing multiple copies of the same console, so different users can input different data instead of always having the same display and data.
]]

--[[
+ - - - - - - - + - - - - - - - +
| =   L I B   A C C E S S       |
|   t                           |  t: title of entry (dark gray bg)
| e                             |  e lines: entry text (white text)
| e                             |
| e                             |-
|   <   >   [ = = = ]   ^   v   |- previous/next, space bar, and scroll up / scroll down
| `   1 2 3 4 5 6 7 8 9 0 - = < |  < backspace
| T   q w e r t y u i o p [ ] \ |  T tab
| ^   a s d f g h j k l ; '   > |  ^ caps lock, > enter
| S   z x c v b n m , . / #   S |  S shift, # symbols
+ - - - - - - - - - - - - - - - +

= in top left allows selecting a different console (is blue-colored)
 LIB ACCESS text is cyan color
keyboard style: light gray keys, except white modifier/special keys
 all on dark gray bg
previous/next and scroll controls on light gray bg, black controls
dark gray bg on entry title
]]
