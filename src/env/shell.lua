local shell = {
  searchpath = settings.get("com.guard13007.cc-starship.shell.path", "."),
  alias = settings.get("com.guard13007.cc-starship.shell.alias", {})
}

function shell.resolveProgram(command)
  if not command then return nil end

  -- alias first
  if shell.alias[command] then
    command = shell.alias[command]
  end

  -- if global path, use it directly
  local start = command:sub(1, 1)
  if start == "/" or start == "\\" then
    local path = command
    if fs.exists(path) and not fs.isDir(path) then
      return path
    end
    return nil
  end

  -- look in the path variable
  for path in shell.searchpath:gmatch("[^:]+") do
    path = fs.combine(path, command)
    if fs.exists(path) and not fs.isDir(path) then
      return path
    end
  end

  return nil
end

function shell.path()
  return shell.searchpath
end

function shell.setPath(path)
  shell.searchpath = path
end

function shell.aliases()
  return shell.alias
end

function shell.setAlias(name, result)
  shell.alias[name] = result
end

function shell.clearAlias(name)
  shell.alias[name] = nil
end

--[[
    BELOW THIS POINT ARE LAZY COMPATIBILITY FUNCTIONS
--]]

function shell.exit()
end

function shell.dir()
  return "/"
end

function shell.setDir(dir)
end

function shell.resolve(path)
  return path
end

function shell.programs(showHidden)
  return {} -- supposed to be files in dir + files in all paths
end

function shell.getRunningProgram()
  return "/src/env/shell.lua" -- sorta correct-ish
end

function shell.run(...)
  local command = {...}
  local path = shell.resolveProgram(command[1])
  if path then
    table.remove(command, 1)
    pcall(os.run(_G, path, unpack(command)))
  else
    pcall(os.run(_G, unpack(command)))
  end
end

function shell.openTab(...) -- nope
  return shell.run(...)
end

function shell.switchTab(id)
end

function shell.complete(prefix)
  return {}
end

function shell.completeProgram(prefix)
  return {}
end

function shell.setCompletionFunction(path, fn)
end

function shell.getCompletionInfo()
  return {}
end

return shell
