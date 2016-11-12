Crabduck = {}
local c = Crabduck
c.__index = Crabduck
setmetatable(c, Monster)

local img1 = getImage("crabduck1")
local img2= getImage("crabduck2")
local img3 = getImage("crabduck3")

function c.new(x, y, r)
  new = Monster.new(x, y, r, getImage("crabduck1"))
  setmetatable(new, c)
  new.baseSpeed = new.baseSpeed * 1.4
  return new
end


function c:draw()
  love.graphics.setColor(255, 255, 255)
  local footDistance = math.sin(self.distanceMoved*24)
  local img
  if footDistance < -0.5 then
    img = img2
  elseif footDistance < 0.5 then
    img = img1
  else
    img = img3
  end
  
--  love.graphics.draw(foot, self.x, self.y, self.direction, 1, 1, footDistance+3, -2)
--  love.graphics.draw(foot, self.x, self.y, self.direction, 1, 1, -footDistance+3, 8)
  love.graphics.draw(img, self.x, self.y, self.direction, 1, 1, 
  self.image:getWidth()/2, self.image:getHeight()/2)
  local dir = self:dirToClosestPlayer()
  
  love.graphics.line(self.x, self.y, self.x + math.cos(dir)*5, self.y + math.sin(dir)*5)
end
