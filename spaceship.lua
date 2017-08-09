local monitors = {} -- keys are peripheral sides, values are wrapped monitors

local consoles = {
  -- dynamically assigned keys are peripheral sides, values are console names
  select = {
    names = {
      "lib_access"
    }
  },
  lib_access = {
    -- entry = {},
    input = "",
    keyboard = {
      lowercase = {
        "` 1234567890-=",
        "T qwertyuiop[]\\",
        "  asdfghjkl;' ",
        "  zxcvbnm,./# ",
        "     [___]"
      },
      shift = {
        "~ !@#$%^&*()_+",
        "T QWERTYUIOP{}|",
        "  ASDFGHJKL:\" ",
        "  ZXCVBNM<>?# ",
        "     [___]"
      },
      capslock = {
        "` 1234567890-=",
        "T QWERTYUIOP[]\\",
        "  ASDFGHJKL;' ",
        "  ZXCVBNM,./# ",
        "     [___]"
      },
      shiftcaps = {
        "~ !@#$%^&*()_+",
        "T qwertyuiop{}|",
        "  asdfghjkl:\" ",
        "  zxcvbnm<>?# ",
        "     [___]"
      }
    }
  }
}

function consoles.select.new(monitor)
  monitor.setBackgroundColor(colors.black)
  monitor.clear()
  monitor.setTextScale(0.5)

  monitor.setTextColor(colors.blue)
  monitor.setCursorPos(1, 1)
  monitor.write("=")

  monitor.setTextColor(colors.cyan)
  monitor.setCursorPos(3, 1)
  monitor.write("SEL CONSOLE")

  monitor.setTextColor(colors.lightBlue)
  for i = 1, #consoles.select.names do
    monitor.setCursorPos(2, i + 1)
    monitor.write(consoles.select.names[i]:gsub("_", " "):upper())
  end
end

function consoles.select.touch(side, x, y)
  if x > 1 and x < 15 then
    local console_name = consoles.select.names[y - 1]
    if console_name then
      consoles[side] = console_name
      consoles[console_name].new(monitors[side])
    end
  end
end

function consoles.lib_access.new(monitor)
  monitor.setBackgroundColor(colors.black)
  monitor.clear()
  monitor.setTextScale(0.5)

  monitor.setTextColor(colors.blue)
  monitor.setCursorPos(1, 1)
  monitor.write("=")

  monitor.setTextColor(colors.cyan)
  monitor.setCursorPos(3, 1)
  monitor.write("LIB ACCESS")

  -- if consoles.lib_access.entry then
  --   print("TODO")
  -- end

  if #consoles.lib_access.input > 0 then
    monitor.setBackgroundColor(colors.gray)
    monitor.setTextColor(colors.white)
    monitor.setCursorPos(2, 2)
    monitor.write(consoles.lib_access.input)
  end

  monitor.setBackgroundColor(colors.gray)
  monitor.setTextColor(colors.lightGray)
  for i = 1, #consoles.lib_access.keyboard.lowercase do
    monitor.setCursorPos(1, i + 5)
    monitor.write(consoles.lib_access.keyboard.lowercase[i])
  end
  monitor.setTextColor(colors.white)
  monitor.setCursorPos(1, 8)
  monitor.write("^")
  monitor.setCursorPos(1, 9)
  monitor.write("S")
  monitor.setCursorPos(15, 6)
  monitor.write("<")
  monitor.setCursorPos(15, 8)
  monitor.write(">")
  monitor.setCursorPos(15, 9)
  monitor.write("S")
  -- | `   1 2 3 4 5 6 7 8 9 0 - = < |- < backspace
  -- | T   q w e r t y u i o p [ ] \ |  T tab
  -- | ^   a s d f g h j k l ; '   > |  ^ caps lock, > enter
  -- | S   z x c v b n m , . / #   S |  S shift, # symbols
  -- |   <   >   [ _ _ _ ]   ^   v   |  previous/next, space bar, and scroll up / scroll down
  monitor.setBackgroundColor(colors.lightGray)
  monitor.setTextColor(colors.black)
  monitor.setCursorPos(1, 10)
  monitor.write(" < > ")
  monitor.setCursorPos(11, 10)
  monitor.write(" ^ v ")
  -- "` 1234567890-=",
  -- "T qwertyuiop[]\\",
  -- "  asdfghjkl;'",
  -- "  zxcvbnm,./#"
  -- "     [___]"
end

function consoles.lib_access.touch(side, x, y)
  if x == 1 and y == 1 then
    consoles[side] = "select"
    consoles.select.new(monitors[side])
  end
  -- TODO finish writing input handling
end

--[[
+ - - - - - - - + - - - - - - - +
| =   L I B   A C C E S S       |
|   t                           |  t: title of entry (dark gray bg)
| e                             |  e lines: entry text (white text)
| e                             |
| e                             |-
| `   1 2 3 4 5 6 7 8 9 0 - = < |- < backspace
| T   q w e r t y u i o p [ ] \ |  T tab
| ^   a s d f g h j k l ; '   > |  ^ caps lock, > enter
| S   z x c v b n m , . / #   S |  S shift, # symbols
|   <   >   [ _ _ _ ]   ^   v   |  previous/next, space bar, and scroll up / scroll down
+ - - - - - - - - - - - - - - - +
]]

while true do
  local event, side, x, y = os.pullEvent()

  if event == "monitor_touch" then
    if monitors[side] then
      consoles[consoles[side]].touch(side, x, y)
    else
      monitors[side] = peripheral.wrap(side)
      consoles[side] = "select"
      consoles.select.new(monitors[side])
    end
  end
end
