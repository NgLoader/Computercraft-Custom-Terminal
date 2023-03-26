require("config.farm")
local monitor = require("util.monitor_util")
local button_manager = require("util.button_util")

local network = require("util.network_util")
network.setProtocol("treefarm")

local storageFull = false

--[[
  NETWORK:
    PROTOCOL: treefarm
    IN:
      tree.on
      tree.off
      tree.update
    OUT:
      tree.state.storage.full
      tree.state.storage.empty
      tree.state.on
      tree.state.off
]]--

local tab = {
  name = "TREE FARM",
  textColor = colors.white,
  backgroundColor = colors.cyan,
  network = network
}

tab.openTab = function()
  local x, y = monitor.getSize();
  button_manager.addButton('storage', 2, x - 1, 4, 4, "Loading", colors.white, colors.cyan)
  button_manager.addButton('toggle', 2, x - 1, 6, y - 1, "Loading", colors.white, colors.cyan)
  button_manager.drawAll()

  handleTick()
  update()
end

tab.closeTab = function()
  saveConfig()
end

tab.handleTick = function ()
  local power = redstone.getAnalogInput(redstone_input)
  if (power > 0 and not storageFull) then
    storageFull = true
    network.send("tree.state.storage.full")
    update()
  elseif (power == 0 and storageFull) then
    storageFull = false
    network.send("tree.state.storage.empty")
    update()
  end
end

tab.handleButton = function(button, x, y)
  local buttonToggle = button_manager.getButtonXY(x, y)
  if (buttonToggle and buttonToggle.identifier == "toggle") then
    toggle()
  end
end

tab.handleRednetMessage = function(sender, message, protocol)
  if (message == "tree.on") then
    if not running then
      toggle()
    end
  elseif (message == "tree.off") then
    if running then
      toggle()
    end
  elseif message == "tree.update" then
    network.send("tree.state.storage." .. (storageFull and "full" or "empty"))
    network.send("tree.state." .. (running and "on" or "off"))
  end
end

function toggle()
  if running then
    running = false
  else
    running = true
  end

  network.send("tree.state." .. (running and "on" or "off"))

  saveConfig()
  update()
end

function update()
  local buttonToggle = button_manager.getButton("toggle")
  if (buttonToggle) then
    buttonToggle.title = running and "On" or "Off"
    buttonToggle.update()
  end

  local buttonStorage = button_manager.getButton("storage")
  if (buttonStorage) then
    buttonStorage.title = storageFull and "Storage: Full" or "Storage: Empty"
    buttonStorage.update()
  end

  redstone.setAnalogOutput(redstone_output, running and 15 or 0)
end

function saveConfig()
  local file = fs.open("config/farm.lua", "w")
  file.write("running = " .. tostring(running))
  file.write("\nredstone_input = \"" .. tostring(redstone_input) .. "\"")
  file.write("\nredstone_output = \"" .. tostring(redstone_output) .. "\"")
  file.close()
end

return tab