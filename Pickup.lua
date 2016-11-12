Pickup = {}
Pickup.__index = Pickup

Pickup.list = {}

function Pickup.new(x_, y_, image_, scale_) 
  local new = {
    x=x_,
    y=y_,
    image = image_,
    scale = scale_,
    dead = false
  }
  setmetatable(new, Pickup)
  table.insert(Pickup.list, new)
  return new
end

function Pickup.updateAll(dt)
  dead = {}
  for i,p in pairs(Pickup.list) do
    p:update(dt)
    if p.dead then
      table.insert(dead, i)
    end
  end
  for i = #dead, 1, -1 do
    p = Pickup.list[dead[i]]
    table.remove(Pickup.list, dead[i])
  end
end

function Pickup:update(dt)
  for _,p in pairs(Player.list) do
    local testX = self.scale * self.image:getWidth() / 2 + p.size / 2
    local testY = self.scale * self.image:getHeight() / 2 + p.size / 2
    if math.abs(p.x - self.x) < testX / 2 and math.abs(p.y - self.y) < testY / 2 then
      self:pickup(p)
    end
  end
end

-- for children...
function Pickup:pickup(player)
  self.dead = true
end

function Pickup.drawAll()
  for _,p in pairs(Pickup.list) do
    p:draw()
  end
end

function Pickup:draw()
  local imgW = self.image:getWidth()
  local imgH = self.image:getHeight()
  love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale, imgW/2, imgH/2)
end
