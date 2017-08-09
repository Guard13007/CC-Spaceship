-- | `   1 2 3 4 5 6 7 8 9 0 - = < |- < backspace
-- | T   q w e r t y u i o p [ ] \ |  T tab
-- | ^   a s d f g h j k l ; '   > |  ^ caps lock, > enter
-- | S   z x c v b n m , . / #   S |  S shift, # symbols
-- |   <   >   [ _ _ _ ]   ^   v   |  left/right, spacebar, and up/down

local keyboard = {
  -- these are possible layouts depending on modifier keys being pressed
  lowercase = {        -- neither key pressed
    "` 1234567890-=",
    "T qwertyuiop[]\\",
    "  asdfghjkl;'  ",
    "  zxcvbnm,./#  ",
    "     [___]     "
  },
  uppercase = {        -- shift only
    "~ !@#$%^&*()_+",
    "T QWERTYUIOP{}|",
    "  ASDFGHJKL:\"  ",
    "  ZXCVBNM<>?#  ",
    "     [___]     "
  },
  capslock = {         -- caps only
    "` 1234567890-=",
    "T QWERTYUIOP[]\\",
    "  ASDFGHJKL;'  ",
    "  ZXCVBNM,./#  ",
    "     [___]     "
  },
  shiftcaps = {        -- shift+caps
    "~ !@#$%^&*()_+",
    "T qwertyuiop{}|",
    "  asdfghjkl:\"  ",
    "  zxcvbnm<>?#  ",
    "     [___]     "
  }
}

function keyboard:new(opts)
  self = {
    input_x = 1,             -- location of input line
    input_y = 1,
    displayLength = 15,      -- displayed length of input line
    empty_bg = colors.black, -- color of empty area of input line
    text_bg = colors.gray,   -- text coloring
    text_fg = colors.white,
    input = "",              -- actual input
    caps = false,            -- modifier key states
    shift = false,
    scrollKeys = false       -- left/right/up/down keys near spacebar?
  }
  setmetatable(self, {__index = keyboard})

  for k,v in pairs(opts) do
    self[k] = v
  end

  return self
end

function keyboard:getActive()
  local active = "lowercase"
  if self.shift then
    active = "uppercase"
    if self.caps then
      active = "shiftcaps"
    end
  elseif self.caps then
    active = "capslock"
  end
  return self[active]
end

function keyboard:drawInput(monitor)
  -- clear previously displayed input
  monitor.setBackgroundColor(self.empty_bg)
  monitor.setCursorPos(self.input_x, self.input_y)
  monitor.write((" "):rep(self.displayLength))
  -- draw current input
  monitor.setBackgroundColor(self.text_bg)
  monitor.setTextColor(self.text_fg)
  monitor.setCursorPos(self.input_x, self.input_y)
  monitor.write(self.input:sub(-self.displayLength))
end

function keyboard:drawKeyboard(monitor)
  monitor.setBackgroundColor(colors.gray)
  monitor.setTextColor(colors.lightGray)

  local active = self:getActive()
  for i = 1, #active do
    monitor.setCursorPos(1, i + 5)
    monitor.write(active[i])
  end

  monitor.setTextColor(colors.white)
  monitor.setCursorPos(15, 6) -- backspace
  monitor.write("<")
  monitor.setCursorPos(15, 8) -- enter
  monitor.write(">")

  -- TODO indicate when capslock and shift are pressed by inverting their colors
  if self.caps then
    monitor.setBackgroundColor(colors.white)
    monitor.setTextColor(colors.gray)
  -- else
  --   monitor.setBackgroundColor(colors.gray)
  --   monitor.setTextColor(colors.white)
  end
  monitor.setCursorPos(1, 8)  -- capslock
  monitor.write("^")

  if self.shift then
    monitor.setBackgroundColor(colors.white)
    monitor.setTextColor(colors.gray)
  else
    monitor.setBackgroundColor(colors.gray)
    monitor.setTextColor(colors.white)
  end
  monitor.setCursorPos(1, 9)  -- left shift
  monitor.write("S")
  monitor.setCursorPos(15, 9) -- right shift
  monitor.write("S")

  if self.scrollKeys then
    monitor.setBackgroundColor(colors.lightGray)
    monitor.setTextColor(colors.black)
    monitor.setCursorPos(1, 10)
    monitor.write(" < > ")
    monitor.setCursorPos(11, 10)
    monitor.write(" ^ v ")
  end
end

function keyboard:touch(monitor, x, y)
  if x == 1 and y == 8 then
    self.caps = not self.caps
    self:drawKeyboard(monitor)
  elseif y == 9 and (x == 1 or x == 15) then -- shift
    self.shift = not self.shift
    self:drawKeyboard(monitor)
  elseif x == 15 and y == 6 then             -- backspace
    self.input = self.input:sub(1, -2)
    self:drawInput(monitor)
  elseif x == 15 and y == 8 then             -- enter
    return "enter"
  elseif x == 1 and y == 7 then              -- T (tab)
    self.input = self.input .. "  "
    self:drawInput(monitor)
    return -- prevent adding a T below
  elseif x == 13 and y == 9 then
    -- NOTE # (symbols) does nothing for now
  elseif x > 5 and x < 11 and y == 10 then   -- spacebar
    self.input = self.input .. " "
    self:drawInput(monitor)
    return -- prevent adding the characters making up the keyboard
  elseif self.scrollKeys and y == 10 then
    if x == 2 then
      return "left"
    elseif x == 4 then
      return "right"
    elseif x == 12 then
      return "up"
    elseif x == 14 then
      return "down"
    end
  end

  local c = self:getActive()[y - 5]
  if c then
    c = c:sub(x, x)
    if not (c == " ") then
      self.input = self.input .. c
      self:drawInput(monitor)
      if self.shift then
        self.shift = false
        self:drawKeyboard(monitor)
      end
    end
  end
end

setmetatable(keyboard, {__call = keyboard.new})

return keyboard
