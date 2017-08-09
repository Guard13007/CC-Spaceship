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
      caps = false,        -- key state
      shift = false,       -- key state
      lowercase = {        -- neither key pressed
        "` 1234567890-=",
        "T qwertyuiop[]\\",
        "  asdfghjkl;' ",
        "  zxcvbnm,./# ",
        "     [___]"
      },
      uppercase = {        -- shift only
        "~ !@#$%^&*()_+",
        "T QWERTYUIOP{}|",
        "  ASDFGHJKL:\" ",
        "  ZXCVBNM<>?# ",
        "     [___]"
      },
      capslock = {         -- caps only
        "` 1234567890-=",
        "T QWERTYUIOP[]\\",
        "  ASDFGHJKL;' ",
        "  ZXCVBNM,./# ",
        "     [___]"
      },
      shiftcaps = {        -- shift+caps
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
    local name = consoles.select.names[y - 1]
    if name then
      consoles[side] = name
      consoles[name].new(monitors[side])
    end
  end
end

function consoles.lib_access.getKeyboardName()
  local selected = "lowercase"
  if consoles.lib_access.keyboard.shift then
    selected = "uppercase"
    if consoles.lib_access.keyboard.caps then
      selected = "shiftcaps"
    end
  elseif consoles.lib_access.keyboard.caps then
    selected = "capslock"
  end
  return selected
end

function consoles.lib_access.drawInput(monitor)
  if not monitor then
    for console, name in pairs(consoles) do
      if name == "lib_access" then
        consoles.lib_access.drawInput(monitors[console])
      end
    end
    return true
  end
  if #consoles.lib_access.input > 0 then
    monitor.setBackgroundColor(colors.black)
    monitor.setCursorPos(2, 2)
    monitor.write("              ") -- 14 spaces to clear previous

    monitor.setBackgroundColor(colors.gray)
    monitor.setTextColor(colors.white)
    monitor.setCursorPos(2, 2)
    monitor.write(consoles.lib_access.input)
  end
end

function consoles.lib_access.drawKeyboard(monitor)
  local selected = consoles.lib_access.getKeyboardName()
  if not monitor then
    for console, name in pairs(consoles) do
      if name == "lib_access" then
        consoles.lib_access.drawKeyboard(monitors[console])
      end
    end
    return true
  end
  monitor.setBackgroundColor(colors.gray)
  monitor.setTextColor(colors.lightGray)
  for i = 1, #consoles.lib_access.keyboard[selected] do
    monitor.setCursorPos(1, i + 5)
    monitor.write(consoles.lib_access.keyboard[selected][i])
  end
  monitor.setTextColor(colors.white)
  monitor.setCursorPos(1, 8) -- capslock
  monitor.write("^")
  monitor.setCursorPos(1, 9) -- left shift
  monitor.write("S")
  monitor.setCursorPos(15, 6) -- backspace
  monitor.write("<")
  monitor.setCursorPos(15, 8) -- enter
  monitor.write(">")
  monitor.setCursorPos(15, 9) -- right shift
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

  consoles.lib_access.drawInput(monitor)
  consoles.lib_access.drawKeyboard(monitor)
end

function consoles.lib_access.touch(side, x, y)
  if x == 1 and y == 1 then
    consoles[side] = "select"
    consoles.select.new(monitors[side])
  elseif x == 1 and y == 8 then              -- capslock
    consoles.lib_access.keyboard.caps = not consoles.lib_access.keyboard.caps
    consoles.lib_access.drawKeyboard()
  elseif y == 9 and (x == 1 or x == 15) then -- shift
    consoles.lib_access.keyboard.shift = not consoles.lib_access.keyboard.shift
    consoles.lib_access.drawKeyboard()
  elseif x == 15 and y == 6 then             -- backspace
    consoles.lib_access.input = consoles.lib_access.input:sub(1, -2)
    consoles.lib_access.drawInput()
  elseif x == 15 and y == 8 then             -- enter
    -- TODO handle search
  elseif x == 1 and y == 7 then              -- T (tab)
    consoles.lib_access.input = consoles.lib_access.input .. "  "
    consoles.lib_access.drawInput()
  elseif x == 13 and y == 9 then
    -- # (symbols) does nothing for now
  elseif x > 5 and x < 11 and y == 10 then   -- spacebar
    consoles.lib_access.input = consoles.lib_access.input .. " "
    consoles.lib_access.drawInput()
  -- TODO right here is where previous/next entry and scroll buttons need to be handled
  else
    local c = consoles.lib_access.keyboard[consoles.lib_access.getKeyboardName()][y - 5]
    if c then
      c = c:sub(x, x)
      if not c == " " then
        consoles.lib_access.input = consoles.lib_access.input .. c
        consoles.lib_access.drawInput()
      end
    end
  end
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

-- TODO make fn for switching consoles, fn for drawing a keyboard, separated instances of things, make startup function check for existing monitors and set them all to select mode
--  make it possible to load a file specifying which monitors were using which screens and automatically restore previous "session"

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
  elseif event == "peripheral" then
    if peripheral.getType(side) then
      monitors[side] = peripheral.wrap(side)
      consoles[side] = "select"
      consoles.select.new(monitors[side])
    end
  else
    print(event, side, x, y)
  end
end
