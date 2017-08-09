local function start(monitor, name)
  monitor.setBackgroundColor(colors.black)
  monitor.clear()
  monitor.setTextScale(0.5)

  monitor.setTextColor(colors.blue)
  monitor.setCursorPos(1, 1)
  monitor.write("=")

  monitor.setTextColor(colors.cyan)
  monitor.setCursorPos(3, 1)
  monitor.write(name)
end

return {
  start = start
}
