PickupStylus = {}
PickupStylus.__index = PickupStylus
setmetatable(PickupStylus, Pickup)

function PickupStylus.new(x, y)
  local image = getImage("powerup_slash")
  local imgW = image:getWidth()
  local imgH = image:getHeight()
  local new = Pickup.new(x - imgW / 2, y - imgH / 2, image, 1 / 2)
  setmetatable(new, PickupStylus)
  return new
end

function PickupStylus:pickup(player)
  Pickup.pickup(self)
  Stylus.startSlash(10)
end
