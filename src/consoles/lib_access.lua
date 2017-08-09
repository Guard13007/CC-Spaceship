local console = dofile("src/util/console.lua")
local keyboard = dofile("src/interface/keyboard.lua")

local lib_access = {}

function lib_access:new(monitor)
  self = {
    keyboard = keyboard({input_x = 2, input_y = 2, displayLength = 13, scrollKeys = true})
  }
  setmetatable(self, {__index = lib_access})

  console.start(monitor, "LIB ACCESS")

  -- if self.entry then
  --   print("TODO")
  -- end

  -- self.keyboard:drawInput(monitor) -- should do fuck all
  self.keyboard:drawKeyboard(monitor)

  return self
end

function lib_access:touch(side, x, y)
  return self.keyboard:touch(peripheral.wrap(side), x, y) -- TODO instead of 'events' just have keyboard return an 'event' (an action taken by the touch)
end

setmetatable(lib_access, {__call = lib_access.new})

return lib_access

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
