local network = {}
local current_protocol = "wuffy_unset"

peripheral.find("modem", rednet.open)

network.setProtocol = function (protocol)
  current_protocol = "wuffy_" .. protocol
end

network.isListening = function (message, protocol)
  if (current_protocol == protocol) then
    return true
  end
  return false
end

network.send = function (message)
  rednet.broadcast(message, current_protocol)
end

return network
