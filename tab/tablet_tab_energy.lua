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
  local width, height = term.getSize()
  term.setBackgroundColor(colors.gray)

  drawBox(13, 2, width - 1, 2, colors.gray)
  local offset = width
  offset = offset - string.len(" >")
  term.setCursorPos(offset, 2)
  term.write(" >")

  local pageCount = #pages
  offset = offset - string.len(tostring(pageCount))
  term.setCursorPos(offset, 2)
  term.write(pageCount)

  offset = offset - 1
  term.setCursorPos(offset, 2)
  term.write("/")

  offset = offset - string.len(tostring(currentPage))
  term.setCursorPos(offset, 2)
  term.write(currentPage)

  offset = offset - string.len("< ")
  term.setCursorPos(offset, 2)
  term.write("< ")

  --[[
  offset = offset - string.len("Page ")
  term.setCursorPos(offset, 2)
  term.write("Page")
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
  term.setCursorPos(2, 3)
  term.write("Page")

  term.setCursorPos(7, 3)
  term.write(currentPage)

  local offset = string.len(tostring(currentPage))
  term.setCursorPos(7 + offset, 3)
  term.write("/")

  term.setCursorPos(8 + offset, 3)
  term.write(#pages)
end

return tab