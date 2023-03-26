local monitor = term

local result = peripheral.find("monitor")
if result then
  monitor = result
end

return monitor;