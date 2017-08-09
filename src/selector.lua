local console = dofile("src/util/console.lua")

local consoles -- set by function call when loaded from src/main.lua

local select_console = {
  names = fs.list("src/consoles")
}

for i = 1, #select_console.names do
  select_console.names[i] = select_console.names[i]:sub(1, -5)
end

function select_console:new(monitor)
  self = {}
  setmetatable(self, {__index = select_console})

  console.start(monitor, "SEL CONSOLE")

  monitor.setTextColor(colors.lightBlue)
  for i = 1, #self.names do
    monitor.setCursorPos(2, i + 1)
    monitor.write(self.names[i]:gsub("_", " "):upper())
  end

  return self
end

function select_console:touch(side, x, y)
  if x > 1 and x < 15 then
    local name = self.names[y - 1]
    if name then
      consoles[side] = dofile("src/consoles/" .. name .. ".lua")(peripheral.wrap(side))
    end
  end
end

setmetatable(select_console, {__call = select_console.new})

local function set_consoles(c)
  consoles = c
end

return {
  set_consoles = set_consoles,
  select_console = select_console
}
