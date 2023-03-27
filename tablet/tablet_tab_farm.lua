local monitor = require("util.monitor_util")
local button_manager = require("util.button_util")

local network = require("util.network_util")
network.setProtocol("treefarm")

local running = false

--[[
  NETWORK:
    PROTOCOL: treefarm
    IN:
      tree.state.storage.full
      tree.state.storage.empty
      tree.state.on
      tree.state.off
    OUT:
      tree.on
      tree.off
      tree.update
]]--

local tab = {
  name = "Tree farm",
  textColor = colors.white,
  backgroundColor = colors.green,
  network = network
}

tab.openTab = function()
  local x, y = monitor.getSize();
  button_manager.addButton('storage', 2, x - 1, 4, 4, "Loading", colors.white, colors.cyan)
  button_manager.addButton('toggle', 2, x - 1, 6, y - 1, "Loading", colors.white, colors.cyan)
  button_manager.drawAll()

  network.send("tree.update")
end

tab.closeTab = function()
  button_manager.clear()
end

tab.handleButton = function(button, x, y)
  local buttonToggle = button_manager.getButtonXY(x, y)
  if (buttonToggle and buttonToggle.identifier == "toggle") then
    network.send("tree." .. (running and "off" or "on"))
  end
end

tab.handleRednetMessage = function(sender, message, protocol)
  if message == "tree.state.storage.full" then
    changeStorage(true)
  elseif message == "tree.state.storage.empty" then
    changeStorage(false)
  elseif message == "tree.state.on" then
    running = true
    changeState(true)
  elseif message == "tree.state.off" then
    running = false
    changeState(false)
  end
end

function changeStorage(type)
  local button = button_manager.getButton("storage")
  if (button) then
    button.title = "Storage: " .. (type and "Full" or "Empty")
    button.update()
  end
end

function changeState(type)
  local button = button_manager.getButton("toggle")
  if (button) then
    button.title = type and "On" or "Off"
    button.backgroundColor = running and colors.green or colors.red
    button.update()
  end
end

return tab