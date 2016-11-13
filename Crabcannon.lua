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
  new.range = 200
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
      CrabcannonProjectile.new(self.x, self.y, self.direction, 25, 100)
      self.state = "waiting"
      self.baseSpeed = speed
    end
  end
end

function Crabcannon:move(dt)
  local player, dist = Player.getClosest(self)
  if dist > self.range then
    --Monster.move(self, dt)
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


-------------------------------------
-- Crabcannon projectiĺe
-------------------------------------
CrabcannonProjectile = {}
CrabcannonProjectile.__index = CrabcannonProjectile
setmetatable(CrabcannonProjectile, Projectile)

function CrabcannonProjectile.new(fromX, fromY, orientation, damage, vel)
  local new = Projectile.new(fromX, fromY, orientation, damage, vel)
  new["image"] = getImage("wall") --placeholder
  setmetatable(new, CrabcannonProjectile )
  return new
end
--[[
function CrabcannonProjectile:update(dt)
  self:move(dt)
  hit, playerHit = self:checkCollisions(dt)
  if hit then
    self:onHit(target)
  end
end
--]]
function CrabcannonProjectile:checkCollisions(dt)
  for _,player in pairs(Player.list) do
    local x1 = self.x - self.vx*dt
    local x2 = self.x
    local y1 = self.y - self.vy*dt
    local y2 = self.y
    x1 = x1 - player.x
    x2 = x2 - player.x
    y1 = y1 - player.y
    y2 = y2 - player.y
    local a = x2*x2 + y2*y2
    local b = 2*(x1*x2+y1*y2)
    local c = (x1*x1)+(y1*y1)-(player.size*player.size)
    
    local t1 = (math.sqrt(b*b - (4*a*c)) - b)/(2*a)
    local t2 = -(math.sqrt(b*b - (4*a*c)) + b)/(2*a)
    
    if (0 < t1  and t1 < 1) or (0 < t2 and t2 < 1) then
      -- We hit the player, I think...
      return true, player
    end
  end
  
  if Land.isBlocked(self.x, self.y) then
    return true, nil
  end
  
  return false
end

function CrabcannonProjectile:onHit(target)
  if target then
    target:damage(self.damage)
  else
    Land.makeHole(self.x, self.y, 10)
  end
  self.dead = true
end


function CrabcannonProjectile:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(self.image, self.x, self.y, self.angle, 1, 1, self.image:getWidth()/2, self.image:getHeight()/2)
end