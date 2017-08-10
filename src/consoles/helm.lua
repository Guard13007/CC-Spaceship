local console = dofile("src/util/console.lua")
local keypad = dofile("src/interface/adv_keypad.lua")

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

  self.keypad:drawInput(monitor)
  self.keypad:drawPad(monitor)

  return self
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

15x10
+ - - - - - - - + - - - - - - - +
| =   H E L M     H D G   3 6 0 |  0 to 360 degrees
|                 S P D   i 5 0 |  i/w for impulse/warp (i green, w orange)
|                               |  digits are % of impulse or warp #
|                               |  (ex 3 2 is warp 3.2)
|                               |-
|           *           _ _ _ _ |-  blank entries on keypad are dark gray
|                         1 2 3 |  entry keypad, select (numbers are light gray)
|                       H 4 5 6 |  heading (lightBlue)
| 2 x                   I 7 8 9 |  impulse (green)
| + -                   W . 0 + |  or warp (orange)
+ - - - - - - - - - - - - - - - +  then type value and enter (+ green) (. is cancel, red)

* in center is our ship,
bg color represents movement capability (when there is bg color, fg is dark gray)
 red: thrusters only
 orange: impulse and thrusters only
 green: warp-capable
 black: no engine damage
+ - in bottom left are zoom controls, (in light gray)
right above it is current zoom (from 1x to 9x) (1-3 in white, 4-6 in light gray, 7-9 are red)
= in top left allows selecting a different console (is blue-colored)
 HELM text is cyan color, as are HDG and SPD
]]
