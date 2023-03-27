require("util.draw_util")
local monitor = require("util.monitor_util")
local button_manager = {}
local button_list = {}

button_manager.getButton = function (identifier)
  return button_list[identifier]
end

button_manager.getButtonXY = function (x, y)
  for index, value in pairs(button_list) do
    if (value.startX <= x and value.endX >= x and value.startY <= y and value.endY >= y) then
      return value;
    end
  end
  return nil
end

button_manager.addButton = function (identifier, startX, endX, startY, endY, title, textColor, backgroundColor)
  button_list[identifier] = {
    identifier = identifier,
    startX = startX,
    endX = endX,
    startY = startY,
    endY = endY,
    title = title,
    textColor = textColor,
    backgroundColor = backgroundColor,
    update = function () button_manager.drawButton(identifier) end
  }
end

button_manager.removeButton = function (identifier)
  button_list[identifier] = nil
end

button_manager.drawButton = function (identifier)
  local button = button_list[identifier]
  if not button then
    return
  end

  if (button.backgroundColor) then
    drawBox(button.startX, button.startY, button.endX, button.endY, button.backgroundColor)
  end

  if (button.title) then
    local textSize = string.len(button.title)
    local textRow = math.floor(((button.endY - button.startY) + 1) / 2)
    local offsetText = math.ceil(((button.endX - button.startX) + 1 - textSize) / 2)

    monitor.setCursorPos(button.startX + offsetText, button.startY + textRow)
    monitor.setBackgroundColor(button.backgroundColor or colors.black)
    monitor.setTextColor(button.textColor or colors.white)
    monitor.write(button.title)
  end
end

button_manager.drawAll = function ()
  for index, value in pairs(button_list) do
    button_manager.drawButton(index)
  end
end

button_manager.clear = function ()
  button_list = {}
end

return button_manager;