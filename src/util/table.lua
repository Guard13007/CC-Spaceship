-- medium copy, like deepcopy, but does not copy functions
local function mcopy(tab)
  if type(tab) == "table" then
    local copy = {}
    for key, value in pairs(tab) do
      copy[key] = mcopy(value)
    end
    return copy
  elseif type(tab) ~= "function" then
    return tab
  end
end

return {
  mcopy = mcopy
}
