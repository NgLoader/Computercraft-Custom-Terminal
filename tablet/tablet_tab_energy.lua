local monitor = require("util.monitor_util")

local tab = {
  name = "Energy",
  textColor = colors.white,
  backgroundColor = colors.blue
}

local currentPage = 1
local pages = {
  "test",
  "hey",
  "test",
  "hey",
  "test",
  "hey",
  "test",
  "hey",
  "test",
  "hey",
  "test",
  "hey",
  "test",
  "hey",
  "test",
  "hey",
  "test",
  "hey",
  "xD"
}

local function drawHeader()
  local width, height = monitor.getSize()
  monitor.setBackgroundColor(colors.gray)

  drawBox(13, 2, width - 1, 2, colors.gray)
  local offset = width
  offset = offset - string.len(" >")
  monitor.setCursorPos(offset, 2)
  monitor.write(" >")

  local pageCount = #pages
  offset = offset - string.len(tostring(pageCount))
  monitor.setCursorPos(offset, 2)
  monitor.write(pageCount)

  offset = offset - 1
  monitor.setCursorPos(offset, 2)
  monitor.write("/")

  offset = offset - string.len(tostring(currentPage))
  monitor.setCursorPos(offset, 2)
  monitor.write(currentPage)

  offset = offset - string.len("< ")
  monitor.setCursorPos(offset, 2)
  monitor.write("< ")

  --[[
  offset = offset - string.len("Page ")
  monitor.setCursorPos(offset, 2)
  monitor.write("Page")
  --]]
end

tab.openTab = function()
  drawHeader()
end

tab.closeTab = function()
end

tab.handleButton = function(button, x, y)
end

tab.handleRednetMessage = function(sender, message, protocol)
  --[[
  monitor.setCursorPos(2, 3)
  monitor.write("Page")

  monitor.setCursorPos(7, 3)
  monitor.write(currentPage)

  local offset = string.len(tostring(currentPage))
  monitor.setCursorPos(7 + offset, 3)
  monitor.write("/")

  monitor.setCursorPos(8 + offset, 3)
  monitor.write(#pages)
  --]]
end

return tab