-- |                         _ _ _ |-  blank entries on keypad are dark gray
-- |                         1 2 3 |  entry keypad (numbers are light gray)
-- |                         4 5 6 |
-- |                         7 8 9 |
-- |                         . 0 * |
-- + - - - - - - - - - - - - - - - +

local keypad = {
  layout = {
    "123",
    "456",
    "789",
    ".0*"  -- note that . and * are overwritten
  },
  x = 13,                    -- location based on top left of input
  y = 6,
  displayLength = 3,         -- input length (actually allows more, but this is displayed)
  bg = colors.black,         -- background for entire pad
  input_fg = colors.white,   -- actual input color
  empty_fg = colors.gray,    -- empty input color
  key_fg = colors.lightGray, -- keypad coloring
  cancel_fg = colors.red,    -- cancel button color
  enter_fg = colors.green,   -- enter button color
  input = ""                 -- input is stored as text until enter is hit, then it is blanked and returned as a number
}

function keypad:new(opts)
  self = setmetatable(opts or {}, {__index = keypad})

  return self
end

function keypad:drawInput(monitor)
  monitor.setBackgroundColor(self.bg)
  if #self.input < self.displayLength then
    monitor.setTextColor(self.empty_fg)
    monitor.setCursorPos(self.x, self.y)
    monitor.write(("_"):rep(self.displayLength))
  end
  if #self.input > 0 then
    monitor.setTextColor(self.input_fg)
    monitor.setCursorPos(math.max(self.x + self.displayLength - #self.input, self.x), self.y)
    monitor.write(self.input:sub(-self.displayLength))
  end
end

function keypad:drawPad(monitor)
  monitor.setBackgroundColor(self.bg)
  monitor.setTextColor(self.key_fg)
  for i = 1, #self.layout do
    monitor.setCursorPos(self.x, self.y + i)
    monitor.write(self.layout[i])
  end
  monitor.setTextColor(self.cancel_fg)
  monitor.setCursorPos(self.x, self.y + 4)
  monitor.write(".")
  monitor.setTextColor(self.enter_fg)
  monitor.setCursorPos(self.x + 2, self.y + 4)
  monitor.write("*")
end

function keypad:touch(monitor, x, y)
  x = x - self.x
  y = y - self.y

  local c = self.layout[y]
  if c then
    c = c:sub(x + 1, x + 1)
    if c == "." then
      self.input = ""
    elseif c == "*" then
      local input = self.input
      self.input = ""
      self:drawInput(monitor)
      return tonumber(input)
    else
      self.input = self.input .. c
    end
    self:drawInput(monitor)
  end
end

setmetatable(keypad, {__call = keypad.new})

return keypad
