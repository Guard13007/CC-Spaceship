-- |                       _ _ _ _ |-  blank entries on keypad are dark gray
-- |                       Z 1 2 3 |  entry keypad (numbers are light gray)
-- |                       A 4 5 6 |  custom mode keys on side with custom
-- |                       B 7 8 9 |   colors (here labeled ZABC)
-- |                       C . 0 * |  note: ABC is 123, Z = 0 and is not intended
-- + - - - - - - - - - - - - - - - +   to be used unless absolutely needed

local keypad = {
  layout = {
    "123",
    "456",
    "789",
    ".0*"  -- note that . and * are overwritten
  },
  x = 12,                    -- location based on top left of input
  y = 6,
  displayLength = 4,         -- input length (actually allows more, but this is displayed)
  bg = colors.black,         -- background for entire pad
  input_fg = colors.white,   -- actual input color
  empty_fg = colors.gray,    -- empty input color
  key_fg = colors.lightGray, -- keypad coloring
  cancel_fg = colors.red,    -- cancel button color
  enter_fg = colors.green,   -- enter button color
  mode = false,              -- if custom modes are set, this is the current one
  modes = {},                -- where custom modes go
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

  if self.mode then
    monitor.setTextColor(self.mode.color)
    monitor.setCursorPos(self.x, self.y)
    monitor.write(self.mode.key)
  end
end

function keypad:drawPad(monitor)
  monitor.setBackgroundColor(self.bg)
  monitor.setTextColor(self.key_fg)
  for i = 1, #self.layout do
    monitor.setCursorPos(self.x + 1, self.y + i)
    monitor.write(self.layout[i])
  end
  monitor.setTextColor(self.cancel_fg)
  monitor.setCursorPos(self.x + 1, self.y + 4)
  monitor.write(".")
  monitor.setTextColor(self.enter_fg)
  monitor.setCursorPos(self.x + 3, self.y + 4)
  monitor.write("*")

  for i = 0, #self.modes do
    if self.modes[i] then -- check to stop zero-ith from breaking things
      monitor.setTextColor(self.modes[i].color)
      monitor.setCursorPos(self.x, self.y + 1 + i)
      monitor.write(self.modes[i].key)
    end
  end
end

function keypad:touch(monitor, x, y)
  x = x - self.x
  y = y - self.y
  if x == 0 then
    local mode = self.modes[y - 1]
    if mode then
      self.mode = mode
      self:drawInput(monitor)
      return "modeswitch"
    end
  else
    local c = self.layout[y]
    if c then
      c = c:sub(x, x)
      if c == "." then
        self.input = ""
        return "cancel"
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
end

setmetatable(keypad, {__call = keypad.new})

return keypad
