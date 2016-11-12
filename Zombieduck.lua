Zombieduck = {}
local z = Zombieduck
z.__index = Monster

local foot = getImage("foot")
local count = 0
local moving = false

function z.new(x, y, r)
  new = Monster.new(x, y, r, getImage("zombieduck") )
  setmetatable(new, z)
  return new
end


function z:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(self.image, self.x, self.y, self.direction, 1, 1, 
  self.image:getWidth()/2, self.image:getHeight()/2)
  local dir = self:dirToClosestPlayer()
  love.graphics.line(self.x, self.y, self.x + math.cos(dir)*5, self.y + math.sin(dir)*5)
  if moving then
    
  else
    count = 0
end
