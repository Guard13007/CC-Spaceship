local console = starship.console
local String = starship.String
local keyboard = starship.keyboard
local shell = starship.shell

local terminal = {
  index = 1,
  type = "terminal"
}

function terminal:new(monitor)
  self = {
    keyboard = {},
    window = {}
  }
  setmetatable(self, {__index = terminal})

  for i = 1, 9 do
    self.keyboard[i] = keyboard({input_y = 5, text_bg = colors.black, scrollKeys = true})
    self.window[i] = window.create(monitor, 1, 2, 15, 4, true)
  end

  console.start(monitor, "TERMINAL    1")

  self.keyboard[self.index]:drawKeyboard(monitor)

  return self
end

function terminal:switchTerm(monitor, id)
  self.index = id
  monitor.setBackgroundColor(colors.black)
  monitor.setTextColor(colors.cyan)
  monitor.setCursorPos(15, 1)
  monitor.write(self.index)

  self.window[self.index].redraw()
  self.keyboard[self.index]:drawKeyboard(monitor)
  self.keyboard[self.index]:drawInput(monitor)
end

function terminal:touch(side, x, y)
  local monitor = peripheral.wrap(side)
  local event = self.keyboard[self.index]:touch(monitor, x, y)

  if event == "enter" then
    local command = String.split(self.keyboard[self.index].input)
    self.keyboard[self.index].input = ""
    self.keyboard[self.index]:drawInput(monitor)

    local path = shell.resolveProgram(command[1])
    term.redirect(self.window[self.index])
    if path then
      table.remove(command, 1)
      pcall(os.run({shell = shell}, path, unpack(command)))
    else
      pcall(os.run({}, "rom/programs/shell", unpack(command)))
    end
    term.redirect(term.native())

  elseif event == "left" then
    if self.index > 1 then
      self:switchTerm(monitor, self.index - 1)
    end
  elseif event == "right" then
    if self.index < 9 then
      self:switchTerm(monitor, self.index + 1)
    end
  end
end

setmetatable(terminal, {__call = terminal.new})

return terminal
