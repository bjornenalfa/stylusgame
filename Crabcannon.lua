Crabcannon = {}
local c = Crabcannon
c.__index = Crabcannon
setmetatable(c, Monster)

local img1 = getImage("crabduck1")
local img2= getImage("crabduck2")
local img3 = getImage("crabduck3")

local cannon1 = getImage("crabduck_cannon1")
local cannon2 = getImage("crabduck_cannon2")
local cannon3 = getImage("crabduck_cannon3")
local cannon4 = getImage("crabduck_cannon4")

local speed = 100

function c.new(x, y)
  new = Monster.new(x, y, 19, getImage("crabduck1"))
  new.counter = 0
  new.state = "waiting"
  new.baseSpeed = speed
  setmetatable(new, c)
  return new
end

function c:update(dt)
  Monster.update(self, dt)
  self.counter = self.counter + dt
  if self.state == "waiting" then
    if self.counter > 5 then
      self.counter = 0
      self.state = "charging"
      self.baseSpeed = 0
    end
  elseif self.state == "charging" then
    if self.counter > 1 then
      self.counter = 0
      --CannonProjectile.new()
      self.state = "waiting"
      self.baseSpeed = speed
    end
  end
end
  

function c:draw()
  love.graphics.setColor(255, 255, 255)
  if self.state == "charging" then
    love.graphics.draw(img1, self.x, self.y, self.direction, 1, 1, self.image:getWidth()/2, self.image:getHeight()/2)
    if 0.1 > self.counter then
      love.graphics.draw(cannon2, self.x, self.y, self.direction, 1, 1, cannon1:getWidth()/2, cannon1:getHeight()/2)
    elseif 0.2 > self.counter then
      love.graphics.draw(cannon3, self.x, self.y, self.direction, 1, 1, cannon1:getWidth()/2, cannon1:getHeight()/2)
    elseif self.counter > 0.2 then
      love.graphics.draw(cannon4, self.x, self.y, self.direction, 1, 1, cannon1:getWidth()/2, cannon1:getHeight()/2)
    end
    
  elseif self.state == "waiting" then
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
    love.graphics.draw(img, self.x, self.y, self.direction, 1, 1, self.image:getWidth()/2, self.image:getHeight()/2)
    love.graphics.draw(cannon1, self.x, self.y, self.direction, 1, 1, cannon1:getWidth()/2, cannon1:getHeight()/2)
  end
  
  local dir = self:dirToClosestPlayer()
  love.graphics.line(self.x, self.y, self.x + math.cos(dir)*5, self.y + math.sin(dir)*5)
  Monster.draw(self)
end
