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
         baseSpeed = 50,
         turningSpeed = 2.5,
         direction = Monster.dirToClosestPlayer({x = x, y = y}),
         gX = 0,
         gY = 0,
         r = r,
         image = image,
         hp = 100,
         maxhp = 100,
         distanceMoved = 0,
         dead = false,
         moved = false -- might not be needed
  }
  setmetatable(new, Monster)
  table.insert(m.list, new)
  return new
end

function Monster.pointInMonster(x, y)
  for _,v in pairs(Monster.list) do
    if (v.x-x)*(v.x-x)+(v.y-y)*(v.y-y) < v.r*v.r then
      return v
    end
  end
  return false
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
  if self.moved then
    --perhaps do stuff with animation
    --also rotation 'mon.r'
  end
  dx = self.vx * dt
  dy = self.vy * dt
  self.distanceMoved = self.distanceMoved + math.sqrt(dx^2+dy^2)
  self.x = self.x + dx
  self.y = self.y + dy
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
  local dirToClosest = self:dirToClosestPlayer() % (math.pi*2)
  local dirDiff = dirToClosest - dir
  if math.abs(dirDiff) < math.pi then
    self.direction = dir + dirDiff * math.max(self.turningSpeed ^ -dt, 1)
  else
    if dirDiff >= 0 then
      self.direction = dir - (dirDiff + math.pi) % (math.pi*2) * math.max(self.turningSpeed ^ -dt, 1)
    else
      self.direction = dir + ((dirDiff + 2*math.pi) % (math.pi*2)) * math.max(self.turningSpeed ^ -dt, 1)
    end
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
    if self.hp <= 0 then
      self.dead = true
    end
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
  love.graphics.draw(self.image, self.x, self.y, self.direction, 1, 1, 
    self.image:getWidth()/2, self.image:getHeight()/2)
  local dir = self:dirToClosestPlayer()
  love.graphics.line(self.x, self.y, self.x + math.cos(dir)*5, self.y + math.sin(dir)*5)
  --[[ draw out health if wanted
  love.graphics.setColor(255, 0, 0, 100)
  love.graphics.rectangle("fill", mon.x - 20, mon.y - 40, 40, 10)
  love.graphics.rectange("fill", mon.x - 20, mon.y - 40 , 40*(mon.hp/mon.maxhp), 10)
  --]]
end
    
    