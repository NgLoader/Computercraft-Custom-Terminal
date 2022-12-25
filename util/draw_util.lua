function drawBox(startX, startY, endX, endY, color)
  term.setBackgroundColor(color or colors.black)

  startX = math.min(startX, endX)
  startY = math.min(startY, endY)
  endX = math.max(startX, endX)
  endY = math.max(startY, endY)

  for x = startX, endX do
    for y = startY, endY do
      term.setCursorPos(x, y)
      term.write(" ")
    end
  end
end

local function drawPageButton(currentPage, pageCount)
  local width, height = term.getSize()
  term.setBackgroundColor(colors.gray)

  drawBox(13, 2, width - 1, 2, colors.gray)
  local offset = width
  offset = offset - string.len(" >")
  term.setCursorPos(offset, 2)
  term.write(" >")

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