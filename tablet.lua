require("util/draw_util")

local tabs = require("tab/tablet_tab")
local currentTab

local hasErrorScreen = false
local running = true

function initialize()
  term.clear()
  term.setCursorBlink(false)
  draw()

  peripheral.find("modem", rednet.open)
  startEventLoop()
end

function close()
  closeTab()

  print("Goodnight")
end

function draw()
  local width, height = term.getSize()

  local buttonWidth = width / 2
  local buttonHeight = height / (#tabs / 2)

  for step, tab in ipairs(tabs) do
    term.setBackgroundColor(tab.backgroundColor)

    local offsetX = getOffsetX(step, buttonWidth)
    local offsetY = getOffsetY(step, buttonHeight)

    for x = 1, buttonWidth do
      for y = 1, buttonHeight do
        term.setCursorPos(offsetX + x, offsetY + y)
        term.write(" ")
      end
    end

    local textSize = string.len(tab.name)
    local textRow = math.floor((buttonHeight + 1) / 2)
    local offsetText = math.ceil((buttonWidth + 1 - textSize) / 2)

    term.setCursorPos(offsetX + offsetText, offsetY + textRow)
    term.setTextColor(tab.textColor)
    term.write(tab.name)
  end
end

function drawBrackground(color)
  local width, height = term.getSize()

  if color then
    term.setBackgroundColor(color)
  else
    term.setBackgroundColor(colors.black)
  end

  for x = 1, width do
    for y = 1, height do
      term.setCursorPos(x, y)
      term.write(" ")
    end
  end
end

function drawTabTitle(tab)
  local width, height = term.getSize()
  local textSize = string.len(tab.name)

  local offset = 5;
  --local offset = math.ceil((width - textSize) / 2)

  term.setBackgroundColor(colors.gray)
  for x = 2, width - 1 do
    term.setCursorPos(x, 2)
    term.write(" ")
  end

  term.setCursorPos(offset - 2, 2)
  term.setBackgroundColor(colors.lightGray)
  term.write(" ")

  term.setCursorPos(offset - 1, 2)
  term.setBackgroundColor(colors.black)
  term.write(" ")

  term.setCursorPos(offset, 2)
  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.white)
  term.write(tab.name)

  term.setCursorPos(offset + textSize, 2)
  term.setBackgroundColor(colors.black)
  term.write(" ")

  term.setCursorPos(offset + textSize + 1, 2)
  term.setBackgroundColor(colors.lightGray)
  term.write(" ")
end

function getOffsetX(step, width)
  if step % 2 == 0 then
    return width
  end
  return 0
end

function getOffsetY(step, height)
  return math.floor((step - 1) / 2) * height
end

function openTab(tab)
  if tab then
    closeTab()
    drawBrackground()
    drawTabTitle(tab)

    currentTab = tab
    tab.openTab()
  end
end

function closeTab()
  if currentTab then
    xpcall(currentTab.closeTab, handleError)

    currentTab = nil
    draw()
  end
end

function handleButton(button, x, y)
  if button == 3 then
    if currentTab then
      closeTab()
    end
    return
  elseif currentTab then
    currentTab.handleButton(button, x, y)
    return
  end

  local width, height = term.getSize()

  local tabSize = #tabs
  local buttonWidth = (width / 2)
  local buttonHeight = (height / (tabSize / 2))

  for step, tab in ipairs(tabs) do
    local offsetX = getOffsetX(step, buttonWidth)
    local offsetY = getOffsetY(step, buttonHeight)

    if x >= offsetX and x <= offsetX + buttonWidth then
      if y >= offsetY and y <= offsetY + buttonHeight then
        term.setCursorPos(10, 10)
        xpcall(function() openTab(tab) end, handleError)
      end
    end
  end
end

function handleRednetMessage(sender, message, protocol)
  for index, value in ipairs(tabs) do
    value.handleRednetMessage(sender, message, protocol)
  end
end

function handleError(error)
  if hasErrorScreen then
    return
  end
  hasErrorScreen = true

  closeTab()

  drawBrackground(colors.red)

  local width, height = term.getSize()

  local text = "An error occurred"
  local textSize = string.len(text)

  local offset = math.ceil((width - textSize) / 2)

  term.setCursorPos(offset, 2)
  term.setBackgroundColor(colors.red)
  term.setTextColor(colors.white)
  term.write(text)

  local textMaxWidth = width - 6
  local textHeightOffset = 5
  for i = textHeightOffset, height do
    term.setCursorPos(2, i)

    local currentTextWidth = (i - textHeightOffset) * textMaxWidth
    term.write(string.sub(error, currentTextWidth, currentTextWidth + textMaxWidth - 1))
  end

  for i = 1, 10 do
    term.setCursorPos(width - 1, 2)
    term.setTextColor(colors.white)
    term.write(10 - i)
    sleep(1)
  end

  hasErrorScreen = false

  -- os.reboot()
  draw()
end

function startEventLoop()
  while true do
    local event = {os.pullEvent()}
    local eventName = event[1]

    if eventName == "terminate" then
      close()
      break
    end

    xpcall(function ()
      if hasErrorScreen then
      elseif eventName == "rednet_message" then
        handleRednetMessage(event[2], event[3], event[4])
      elseif eventName == "mouse_click" then
        handleButton(event[2], event[3], event[4])
      end
    end, handleError)
  end
end

initialize()