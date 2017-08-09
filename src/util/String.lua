local function split(str)
  local tab = {}
  for word in str:gmatch("%S+") do
    table.insert(tab, word)
  end
  return tab
end

return {
  split = split
}
