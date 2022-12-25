local tabs = {}

for index, value in ipairs(fs.list("tab")) do
  table.insert(tabs, require("tab/" .. string.gsub(value, ".lua", "")))
end

return tabs