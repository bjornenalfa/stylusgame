Monster = {}
local m = Monster
m.__index = m
m.list = {}

--The class for the monsters running around, possibly abstract

function Monster.new(x, y, r, image)
  new = {x = x,
         y = y,
         vx = 0,
         vy = 0,
         baseSpeed = 10,
         turningSpeed = 0.5,
         direction = Monster.dirToClosestPlayer({x = x, y = y}),
         gX = 0,
         gY = 0,
         r = r,
         image = image,
         hp = 100,
         maxhp = 100,
         dead = false,
         moved = false -- might not be needed
  }
  setmetatable(new, Monster)
  table.insert(m.list, new)
  return new
end

function Monster.updateAll(dt)
  dead = {}
  for i,mon in pairs(m.list) do
    mon:update(dt)
    if mon.dead then
      table.insert(dead, i)
    end
  end
  for i = #dead, 1, -1 do
    mon = m.list[dead[i]]
    mon:die()
    table.remove(m.list, dead[i])
  end
end

function Monster:update(dt)
  self.moved = false
  self:turnToGoal(dt)
  self:move(dt)
  if mon.moved then
    --perhaps do stuff with animation
    --also rotation 'mon.r'
  end
  mon.x = mon.x + mon.vx * dt
  mon.y = mon.y + mon.vy * dt
end
  
function Monster:dirToClosestPlayer()
  local closest = Player.getClosest(self)
  return math.atan2(closest.y - self.y, closest.x - self.x)
end

function Monster:turnToGoal(dt)
  local closest = Player.getClosest(self)
  self.gX = closest.x
  self.gY = closest.y
  local dir = self.direction
  local dirToClosest = self:dirToClosestPlayer()
  local dirDiff = dirToClosest - dir
  if math.abs(dirDiff) < math.pi then
    self.direction = dir + dirDiff * self.turningSpeed * dt
  else
    dirDiff = (dirDiff - math.pi) % (math.pi*2)
    self.direction = dir - dirDiff * self.turningSpeed * dt
  end
  self.direction = self.direction % (math.pi*2)
end
  
function Monster:move(dt)
  self.vx = math.cos(self.direction) * self.baseSpeed * dt
  self.vy = math.sin(self.direction) * self.baseSpeed * dt
  self.x = self.x + self.vx
  self.y = self.y + self.vy
  self.moved = true 
end

function Monster:damage(damage)
  damage = math.floor(damage+0.5)
  if damage > 0 then
    self.hp = self.hp - damage
  end
end

function Monster:die()
  -- perhaps reward the player or something
end

function Monster.drawAll()
  for i,mon in pairs(m.list) do
    mon:draw()
  end
end
    
function Monster:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(mon.image, mon.x, mon.y, mon.direction, 1, 1, mon.image:getWidth()/2, mon.image:getHeight()/2)
  --[[ draw out health if wanted
  love.graphics.setColor(255, 0, 0, 100)
  love.graphics.rectangle("fill", mon.x - 20, mon.y - 40, 40, 10)
  love.graphics.rectange("fill", mon.x - 20, mon.y - 40 , 40*(mon.hp/mon.maxhp), 10)
  --]]
end
    
    