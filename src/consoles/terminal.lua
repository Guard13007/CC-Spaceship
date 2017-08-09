local console = dofile("src/util/console.lua")
local String = dofile("src/util/String.lua")
local keyboard = dofile("src/interface/keyboard.lua")

local terminal = {}

function terminal:new(monitor)
  self = {
    type = "terminal",
    keyboard = keyboard({input_y = 5, text_bg = colors.black, scrollKeys = true}),
    window = window.create(monitor, 1, 2, 15, 4, true)
  }
  setmetatable(self, {__index = terminal})

  console.start(monitor, "TERMINAL")

  self.keyboard:drawKeyboard(monitor)

  return self
end

function terminal:clear(monitor)
  monitor.setBackgroundColor(colors.black)
  for i = 2, 5 do
    monitor.setCursorPos(1, i)
    monitor.write("               ")
  end
end

function terminal:touch(side, x, y)
  local monitor = peripheral.wrap(side)
  local event = self.keyboard:touch(monitor, x, y)

  if event == "enter" then
    local command = String.split(self.keyboard.input)
    self.keyboard.input = ""

    term.redirect(self.window)
    pcall(os.run({}, unpack(command)))
    term.redirect(term.native())
  -- NOTE could use left and right to access multiple terminals...
  -- elseif event == "left" then
  --   if self.entry and self.entry.index > 1 then
  --     self:loadEntry(self.entry.index - 1)
  --     self:drawResult(monitor)
  --   end
  -- elseif event == "right" then
  --   if self.entry and self.entry.index < #terminal.library then
  --     self:loadEntry(self.entry.index + 1)
  --     self:drawResult(monitor)
  --   end
  -- NOTE would be nice to have command result history...
  elseif event == "up" then
    -- if self.entry and self.entry.lineNumber > 1 then
    --   self.entry.lineNumber = self.entry.lineNumber - 1
    --   self:drawResult(monitor)
    -- end
  elseif event == "down" then
    -- if self.entry and self.entry.lineNumber < (#self.entry.lines - 2) then
    --   self.entry.lineNumber = self.entry.lineNumber + 1
    --   self:drawResult(monitor)
    -- end
  else
    -- if self.entry then
    --   self.entry = false
    --   self:clear(monitor)
    -- end
  end
end

setmetatable(terminal, {__call = terminal.new})

return terminal
