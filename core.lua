local monitor = require("util.monitor_util")
require("util.draw_util")
require("config.core")

local tabs = {}
local currentTab

local hasErrorScreen = false
local running = true

local timerId

function initialize()
  monitor.clear()
  monitor.setCursorBlink(false)

  if system_type == "tablet" then
    os.setComputerLabel("System")

    tabs = require("tablet/tablet_tab")
    draw()
  else
    os.setComputerLabel("System - " .. system_type)

    local tab = require("system/system_" .. system_type)
    table.insert(tabs, tab)
    openTab(tab)
  end

  peripheral.find("modem", rednet.open)
  startEventLoop()
end

function close()
  closeTab()

  print("Goodnight")
end

function draw()
  local width, height = monitor.getSize()

  local buttonWidth = width / 2
  local buttonHeight = height / (#tabs / 2)

  for step, tab in ipairs(tabs) do
    monitor.setBackgroundColor(tab.backgroundColor)

    local offsetX = getOffsetX(step, buttonWidth)
    local offsetY = getOffsetY(step, buttonHeight)

    for x = 1, buttonWidth do
      for y = 1, buttonHeight do
        monitor.setCursorPos(offsetX + x, offsetY + y)
        monitor.write(" ")
      end
    end

    local textSize = string.len(tab.name)
    local textRow = math.floor((buttonHeight + 1) / 2)
    local offsetText = math.ceil((buttonWidth + 1 - textSize) / 2)

    monitor.setCursorPos(offsetX + offsetText, offsetY + textRow)
    monitor.setTextColor(tab.textColor)
    monitor.write(tab.name)
  end
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
  if button == 3 and system_type == "tablet" then
    if currentTab then
      closeTab()
    end
    return
  elseif currentTab then
    currentTab.handleButton(button, x, y)
    return
  end

  local width, height = monitor.getSize()

  local tabSize = #tabs
  local buttonWidth = (width / 2)
  local buttonHeight = (height / (tabSize / 2))

  for step, tab in ipairs(tabs) do
    local offsetX = getOffsetX(step, buttonWidth)
    local offsetY = getOffsetY(step, buttonHeight)

    if x >= offsetX and x <= offsetX + buttonWidth then
      if y >= offsetY and y <= offsetY + buttonHeight then
        monitor.setCursorPos(10, 10)
        xpcall(function() openTab(tab) end, handleError)
      end
    end
  end
end

function handleRednetMessage(sender, message, protocol)
  for index, value in ipairs(tabs) do
    if (value.network) then
      if (value.network.isListening(message, protocol)) then
        value.handleRednetMessage(sender, message, protocol)
      end
    end
  end
end

function handleTick()
  for index, value in ipairs(tabs) do
    if (value.handleTick) then
      value.handleTick()
    end
  end
end

function handleError(error)
  if hasErrorScreen then
    return
  end
  hasErrorScreen = true

  closeTab()

  drawBrackground(colors.red)

  local width, height = monitor.getSize()

  local text = "An error occurred"
  local textSize = string.len(text)

  local offset = math.ceil((width - textSize) / 2)

  monitor.setCursorPos(offset, 2)
  monitor.setBackgroundColor(colors.red)
  monitor.setTextColor(colors.white)
  monitor.write(text)

  local textMaxWidth = width - 6
  local textHeightOffset = 5
  for i = textHeightOffset, height do
    monitor.setCursorPos(2, i)

    local currentTextWidth = (i - textHeightOffset) * textMaxWidth
    monitor.write(string.sub(error, currentTextWidth, currentTextWidth + textMaxWidth - 1))
  end

  for i = 1, 10 do
    monitor.setCursorPos(width - 1, 2)
    monitor.setTextColor(colors.white)
    monitor.write(10 - i)
    sleep(1)
  end

  hasErrorScreen = false

  -- os.reboot()
  draw()
end

function startEventLoop()
  timerId = os.startTimer(1)
  
  while true do
    local event = {os.pullEvent()}
    local eventName = event[1]

    if eventName == "terminate" then
      close()
      break
    end

    xpcall(function ()
      if hasErrorScreen then
      elseif eventName == "timer" then
        if (event[2] == timerId) then
          os.cancelTimer(timerId)
          timerId = os.startTimer(1)
          handleTick()
        end
      elseif eventName == "rednet_message" then
        handleRednetMessage(event[2], event[3], event[4])
      elseif eventName == "mouse_click" then
        if (monitor == term) then
          handleButton(event[2], event[3], event[4])
        else
          print("Only monitor!")
        end
      elseif eventName == "monitor_touch" then
        handleButton(2, event[3], event[4])
      end
    end, handleError)
  end
end

initialize()