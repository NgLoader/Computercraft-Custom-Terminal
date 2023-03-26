local tabs = {}

for index, value in ipairs(fs.list("tablet")) do
  if not (value == "tablet_tab.lua") then
    table.insert(tabs, require("tablet/" .. string.gsub(value, ".lua", "")))
  end
end

return tabs