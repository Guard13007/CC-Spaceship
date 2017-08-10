os.loadAPI("src/apis/consoles")
os.loadAPI("src/apis/ship")

redstone.setOutput("back", true)

settings.set("com.guard13007.cc-starship.shell.path", shell.path()..":/src/bin")
settings.set("com.guard13007.cc-starship.shell.alias", shell.aliases())
-- settings.set("com.guard13007.cc-starship.help.path", help.path())

local select_console = dofile("src/select_console.lua")

local function new_console(side)
  consoles[side] = select_console(peripheral.wrap(side))
end

-- restore previous arrangement
if fs.exists(".consoles") then
  local file = fs.open(".consoles", "r")
  local restore = textutils.unserialize(file.readAll())
  file.close()
  for side, type in pairs(restore) do
    consoles[side] = dofile("src/consoles/" .. type .. ".lua")(peripheral.wrap(side))
  end
end

for _, side in ipairs(peripheral.getNames()) do
  if (not consoles[side]) and peripheral.getType(side) == "monitor" then
    new_console(side)
  end
end

while true do
  local event, side, x, y = os.pullEventRaw()

  if event == "monitor_touch" then
    if consoles[side] then
      if x == 1 and y == 1 then
        new_console(side) -- lazy hack, might lead to memory leak?
      end
      consoles[side]:touch(side, x, y)
    else
      new_console(side)
    end
  elseif event == "peripheral" then
    if peripheral.getType(side) == "monitor" then
      new_console(side)
    end
  elseif event == "terminate" then
    redstone.setOutput("back", false)
    os.queueEvent("terminate")
    os.pullEvent() -- lazy way to exit
  else
    -- stop cross-writing from terminal and here
    local previous = term.redirect(term.native())
    print(event, side, x, y)
    term.redirect(previous)
  end
end
