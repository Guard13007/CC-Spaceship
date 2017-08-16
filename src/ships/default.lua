local default = {
  -- values that are simulated
  position = vector:new(),
  velocity = vector:new(),
  -- values used to adjust simulation
  targetHeading = 360,
  targetSpeed = 0,
  -- values used to display simulation
  heading = 360,
  speed = {
    type = "i",
    value = 0
  }
}

-- TODO have a way to calculate heading and speed from velocity

function default:new(opts)
  self = setmetatable(opts or {}, {__index = default})

  return self
end

setmetatable(default, {__call = default.new})

return default
