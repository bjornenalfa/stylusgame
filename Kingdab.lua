Kingdab = {}
local d = Kingdab
d.__index = Kingdab
setmetatable(d, Monster)

local claw1 = getImage("duckcrab_claw1")
local claw2 = getImage("duckcrab_claw2")
local angry = getImage("kingdab_angry")
local angle = math.rad(36)
local dist = 46
local wing1 = getImage("kingdab_wing1")
local wing2 = getImage("kingdab_wing2")

local cannon1 = getImage("crabduck_cannon1")
local cannon2 = getImage("crabduck_cannon2")
local cannon3 = getImage("crabduck_cannon3")
local cannon4 = getImage("crabduck_cannon4")

local cannonWidth = cannon1:getWidth()/2
local cannonHeight = cannon1:getHeight()/2

local speed = 70

function d.new(x, y)
  new = Monster.new(x, y, 25, getImage("kingdab_base") )
  new.hp = 5000
  new.maxhp = 5000
  new.cannonCooldown = 4
  new.angryCooldown = 20
  new.angryDuration = 5
  new.counter = 0
  new.state = "waiting"
  new.baseSpeed = speed
  new.attack = 30
  new.attackRange = 45
  setmetatable(new, d)
  return new
end

function d:update(dt)
  if self.state == "angry" then
    self.moved = false
    self:turnToGoal(dt)
    self.vx = math.cos(self.direction) * self.baseSpeed
    self.vy = math.sin(self.direction) * self.baseSpeed
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
    self.stopTimer = 0
    dx = self.vx * dt
    dy = self.vy * dt
    self.distanceMoved = self.distanceMoved + math.sqrt(dx^2+dy^2)
  else
    Monster.update(self, dt)
  end
  self.cannonCooldown = self.cannonCooldown - dt
  self.angryCooldown = self.angryCooldown - dt
  if self.cannonCooldown < 0 then
    CrabcannonProjectile.new(self.x, self.y, self.direction-math.rad(30), 25, 200)
    CrabcannonProjectile.new(self.x, self.y, self.direction+math.rad(30), 25, 200)
    CrabcannonProjectile.new(self.x, self.y, self.direction-math.rad(15), 25, 200)
    CrabcannonProjectile.new(self.x, self.y, self.direction+math.rad(15), 25, 200)
    CrabcannonProjectile.new(self.x, self.y, self.direction, 25, 200)
    
    self.cannonCooldown = 4
  end
  if self.angryCooldown < 0 then
    self.state = "angry"
    self.baseSpeed = 140
    self.angryDuration = 5
    self.angryCooldown = 20
    Sound.play("wing2")
  end
  if self.state == "angry" then
    self.angryDuration = self.angryDuration - dt
    if self.angryDuration < 0 then
      self.state = "waiting"
      self.baseSpeed = speed
    end
  end 
  
end

function d:draw()
  love.graphics.setColor(255, 255, 255)
  
  if self.state == "angry" then
    love.graphics.draw(angry, self.x, self.y, self.direction, 1, 1, 
      angry:getWidth()/2, angry:getHeight()/2)
    local dir = self:dirToClosestPlayer()
    --love.graphics.line(self.x, self.y, self.x + math.cos(dir)*5, self.y + math.sin(dir)*5)
    local claw1x = self.x+math.cos(self.direction+angle)*dist
    local claw1y = self.y+math.sin(self.direction+angle)*dist
    local claw2x = self.x+math.cos(self.direction-angle)*dist
    local claw2y = self.y+math.sin(self.direction-angle)*dist
    local claw = time % 0.20 < 0.10 and claw1 or claw2
    love.graphics.draw(claw, claw1x, claw1y, Monster.dirToClosestPlayer({x=claw1x, y=claw1y}), 1, 1, 9, 9)
    love.graphics.draw(claw, claw2x, claw2y, Monster.dirToClosestPlayer({x=claw2x, y=claw2y}), 1, 1, 9, 9)
    local wing = time % 0.5 < 0.25 and wing1 or wing2
    love.graphics.draw(wing, self.x, self.y, self.direction, 1, 1, 
      wing:getWidth()/2, wing:getHeight()/2)
  else
    love.graphics.draw(self.image, self.x, self.y, self.direction, 1, 1, 
      self.image:getWidth()/2, self.image:getHeight()/2)
    local dir = self:dirToClosestPlayer()
    --love.graphics.line(self.x, self.y, self.x + math.cos(dir)*5, self.y + math.sin(dir)*5)
    local claw1x = self.x+math.cos(self.direction+angle)*dist
    local claw1y = self.y+math.sin(self.direction+angle)*dist
    local claw2x = self.x+math.cos(self.direction-angle)*dist
    local claw2y = self.y+math.sin(self.direction-angle)*dist
    local claw = time % 0.5 < 0.25 and claw1 or claw2
    love.graphics.draw(claw, claw1x, claw1y, Monster.dirToClosestPlayer({x=claw1x, y=claw1y}), 1, 1, 9, 9)
    love.graphics.draw(claw, claw2x, claw2y, Monster.dirToClosestPlayer({x=claw2x, y=claw2y}), 1, 1, 9, 9)
    love.graphics.draw(wing1, self.x, self.y, self.direction, 1, 1, 
      wing1:getWidth()/2, wing1:getHeight()/2)
  end

  local cannonX = self.x + math.cos(self.direction) * (-20)
  local cannonY = self.y + math.sin(self.direction) * (-20)
  love.graphics.draw(cannon1, cannonX, cannonY, self.direction-math.rad(30), 1, 1, 
    cannonWidth, cannonHeight)
  love.graphics.draw(cannon1, cannonX, cannonY, self.direction+math.rad(30), 1, 1, 
    cannonWidth, cannonHeight)
  love.graphics.draw(cannon1, cannonX, cannonY, self.direction-math.rad(15), 1, 1, 
    cannonWidth, cannonHeight)
  love.graphics.draw(cannon1, cannonX, cannonY, self.direction+math.rad(15), 1, 1, 
    cannonWidth, cannonHeight)
  love.graphics.draw(cannon1, cannonX, cannonY, self.direction, 1, 1, 
    cannonWidth, cannonHeight)
  
  Monster.draw(self)
end
