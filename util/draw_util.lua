local monitor = require("util.monitor_util")

function drawBox(startX, startY, endX, endY, color)
  monitor.setBackgroundColor(color or colors.black)

  startX = math.min(startX, endX)
  startY = math.min(startY, endY)
  endX = math.max(startX, endX)
  endY = math.max(startY, endY)

  for x = startX, endX do
    for y = startY, endY do
      monitor.setCursorPos(x, y)
      monitor.write(" ")
    end
  end
end

local function drawPageButton(currentPage, pageCount)
  local width, height = monitor.getSize()
  monitor.setBackgroundColor(colors.gray)

  drawBox(13, 2, width - 1, 2, colors.gray)
  local offset = width
  offset = offset - string.len(" >")
  monitor.setCursorPos(offset, 2)
  monitor.write(" >")

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

function drawBrackground(color)
  local width, height = monitor.getSize()

  if color then
    monitor.setBackgroundColor(color)
  else
    monitor.setBackgroundColor(colors.black)
  end

  for x = 1, width do
    for y = 1, height do
      monitor.setCursorPos(x, y)
      monitor.write(" ")
    end
  end
end

function drawTabTitle(tab)
  local width, height = monitor.getSize()
  local textSize = string.len(tab.name)

  local offset = 5;
  --local offset = math.ceil((width - textSize) / 2)

  monitor.setBackgroundColor(colors.gray)
  for x = 2, width - 1 do
    monitor.setCursorPos(x, 2)
    monitor.write(" ")
  end

  monitor.setCursorPos(offset - 2, 2)
  monitor.setBackgroundColor(colors.lightGray)
  monitor.write(" ")

  monitor.setCursorPos(offset - 1, 2)
  monitor.setBackgroundColor(colors.black)
  monitor.write(" ")

  monitor.setCursorPos(offset, 2)
  monitor.setBackgroundColor(colors.black)
  monitor.setTextColor(colors.white)
  monitor.write(tab.name)

  monitor.setCursorPos(offset + textSize, 2)
  monitor.setBackgroundColor(colors.black)
  monitor.write(" ")

  monitor.setCursorPos(offset + textSize + 1, 2)
  monitor.setBackgroundColor(colors.lightGray)
  monitor.write(" ")
end