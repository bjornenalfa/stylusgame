Duckcrab = {}
local d = Duckcrab
d.__index = Duckcrab
setmetatable(d, Monster)

local claw1 = getImage("duckcrab_claw1")
local claw2 = getImage("duckcrab_claw2")
local angry = getImage("duckcrab_angry")
local angle = math.rad(38)
local dist = 35

function d.new(x, y, pointValue)
  new = Monster.new(x, y, 17, getImage("duckcrab"), pointValue)
  new.hp = 600
  new.maxhp = 600
  new.attack = 15
  new.attackRange = 40
  setmetatable(new, d)
  return new
end


function d:draw()
  love.graphics.setColor(255, 255, 255)
  
  if self.hp < self.maxhp * 0.5 then
    self.baseSpeed = 140
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
  end

  
  Monster.draw(self)
end
