local console = starship.console
local keypad = starship.adv_keypad

local helm = {
  type = "helm"
}

function helm:new(monitor)
  self = {
    keypad = keypad({
      modes = {
        {
          color = colors.lightBlue,
          key = "H"
        },
        {
          color = colors.green,
          key = "I"
        },
        {
          color = colors.orange,
          key = "W"
        }
      }
    })
  }
  setmetatable(self, {__index = helm})

  console.start(monitor, "HELM")

  monitor.setBackgroundColor(colors.black)
  monitor.setTextColor(colors.cyan)
  monitor.setCursorPos(9, 1)
  monitor.write("HDG")
  monitor.setCursorPos(9, 2)
  monitor.write("SPD")
  self:updateDraw(monitor)

  self.keypad:drawInput(monitor)
  self.keypad:drawPad(monitor)

  return self
end

function helm:updateDraw(monitor)
  monitor.setBackgroundColor(colors.black)
  monitor.setTextColor(colors.white)
  monitor.setCursorPos(13, 1)
  monitor.write(ship.heading)
  monitor.setCursorPos(13, 2)

  monitor.write("a00") -- TODO fix based on ship.speed
  -- ship.speed = {
  --   type = "i",
  --   value = 0
  -- }
end

function helm:touch(side, x, y)
  local monitor = peripheral.wrap(side)
  local event = self.keypad:touch(monitor, x, y)

  if type(event) == "number" then
    -- we have received a value

    self.keypad.mode = false
    self.keypad:drawInput(monitor)
  elseif event == "cancel" then
    self.keypad.mode = false
    self.keypad:drawInput(monitor)
  end
end

setmetatable(helm, {__call = helm.new})

return helm

--[[
TODO needs weapons firing capability as well!

+ - - - - - - - + - - - - - - - +
| =   H E L M     H D G   3 6 0 |  0 to 360 degrees
|                 S P D   i 5 0 |  i/w for impulse/warp (i green, w orange)
|                               |  digits are % of impulse or warp #
|                               |  (ex 3 2 is warp 3.2)
|                               |-
|           *           _ _ _ _ |-
|                         1 2 3 |
|                       H 4 5 6 |
| 2 x                   I 7 8 9 |
| + -                   W . 0 + |
+ - - - - - - - - - - - - - - - +

* in center is our ship,
bg color represents movement capability (when there is bg color, fg is dark gray)
 red: thrusters only
 orange: impulse and thrusters only
 green: warp-capable
 black: no engine damage
+ - in bottom left are zoom controls, (in light gray)
right above it is current zoom (from 1x to 9x) (1-3 in white, 4-6 in light gray, 7-9 are red)
= in top left allows selecting a different console (is blue-colored)
 HELM text is cyan color, as are HDG and SPD (but their values are white)
]]
