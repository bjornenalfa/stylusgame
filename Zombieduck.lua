Zombieduck = {}
local z = Zombieduck
z.__index = Zombieduck
setmetatable(z, Monster)

local foot = getImage("foot")
local count = 0
local moving = false

function z.new(x, y, pointValue)
  new = Monster.new(x, y, 12, getImage("zombieduck") )
  new.hp = 400
  new.maxhp = 400
  setmetatable(new, z)
  return new
end


function z:draw()
  local footDistance = math.sin(self.distanceMoved*7)*14
  love.graphics.setColor(255, 255, 255)
  
  love.graphics.draw(foot, self.x, self.y, self.direction, 1, 1, footDistance+3, -2)
  love.graphics.draw(foot, self.x, self.y, self.direction, 1, 1, -footDistance+3, 8)
  love.graphics.draw(self.image, self.x, self.y, self.direction, 1, 1, 
  self.image:getWidth()/2, self.image:getHeight()/2)
  local dir = self:dirToClosestPlayer()
  --love.graphics.line(self.x, self.y, self.x + math.cos(dir)*5, self.y + math.sin(dir)*5)
  
  Monster.draw(self)
end
