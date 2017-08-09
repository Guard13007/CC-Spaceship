local console = dofile("src/util/console.lua")
local keyboard = dofile("src/interface/keyboard.lua")

local lib_access = {
  library = fs.list("library")
}

function lib_access:new(monitor)
  self = {
    entry = false,
    keyboard = keyboard({input_x = 2, input_y = 2, displayLength = 13, scrollKeys = true})
  }
  setmetatable(self, {__index = lib_access})

  console.start(monitor, "LIB ACCESS")

  self.keyboard:drawKeyboard(monitor)

  return self
end

function lib_access:clear(monitor)
  monitor.setBackgroundColor(colors.black)
  for i = 3, 5 do
    monitor.setCursorPos(1, i)
    monitor.write("               ")
  end
end

function lib_access:drawEntry(monitor)
  self:clear(monitor)

  -- drawing title using keyboard
  local input = self.keyboard.input
  self.keyboard.input = self.entry.title
  self.keyboard:drawInput(monitor)
  self.keyboard.input = input

  monitor.setBackgroundColor(colors.black)
  monitor.setTextColor(colors.white)
  for i = 0, 2 do
    local line = self.entry.lines[self.entry.lineNumber + i]
    if line then
      monitor.setCursorPos(1, i + 3)
      monitor.write(line)
    end
  end
end

function lib_access:loadEntry(index)
  self.entry = {
    title = self.library[index],
    lines = {},
    lineNumber = 1,
    index = index
  }
  local file = fs.open("library/" .. self.entry.title, "r")
  local line = file.readLine()
  while line do
    table.insert(self.entry.lines, line)
    line = file.readLine()
  end
  file.close()
end

function lib_access:touch(side, x, y)
  local monitor = peripheral.wrap(side)
  local event = self.keyboard:touch(monitor, x, y)

  if event == "enter" then
    local input = self.keyboard.input:lower()
    for index, name in ipairs(self.library) do
      if name:lower():find(input) then
        self:loadEntry(index)
        break
      end
    end
    if self.entry then
      self.keyboard.input = ""
    else
      -- no entry found
      self.entry = {
        title = "Not Found",
        lines = {
          "That entry does",
          "not exist in",
          "the lib comp."
        },
        lineNumber = 1,
        index = 0
      }
    end
    self:drawEntry(monitor)
  elseif event == "left" then
    if self.entry and self.entry.index > 1 then
      self:loadEntry(self.entry.index - 1)
      self:drawEntry(monitor)
    end
  elseif event == "right" then
    if self.entry and self.entry.index < #lib_access.library then
      self:loadEntry(self.entry.index + 1)
      self:drawEntry(monitor)
    end
  elseif event == "up" then
    if self.entry and self.entry.lineNumber > 1 then
      self.entry.lineNumber = self.entry.lineNumber - 1
      self:drawEntry(monitor)
    end
  elseif event == "down" then
    if self.entry and self.entry.lineNumber < (#self.entry.lines - 2) then
      self.entry.lineNumber = self.entry.lineNumber + 1
      self:drawEntry(monitor)
    end
  else
    if self.entry then
      self.entry = false
      self:clear(monitor)
    end
  end
end

setmetatable(lib_access, {__call = lib_access.new})

return lib_access
