Projectile = {}
Projectile.__index = Projectile

Projectile.list = {}

function Projectile.new(x, y, angle, damage, speed)
  local new = {
    x=x,
    y=y,
    angle = angle,
    vx=math.cos(angle)*speed,
    vy=math.sin(angle)*speed,
    dead=false
  }
  setmetatable(new, Projectile)
  table.insert(Projectile.list, new)
  
  --if new.vx == 0 then print(new.vy) end
  
  return new
end

function Projectile.updateAll(dt)
  local killed = {}
  for index,p in pairs(Projectile.list) do
    p:update(dt)
    if p.dead then
      table.insert(killed, index)
    end
  end
  for i = #killed, 1, -1 do
    table.remove(Projectile.list, killed[i])
  end
end

function Projectile:move(dt)
  self.x = self.x + self.vx * dt
  self.y = self.y + self.vy * dt
end

function Projectile:checkCollisions(dt)
  if Land.isBlocked(self.x, self.y) then
    self:onHit(nil)
  end
  
  for _,mon in pairs(Monster.list) do
    local x1 = self.x - self.vx*dt
    local x2 = self.x
    local y1 = self.y - self.vy*dt
    local y2 = self.y
    x1 = x1 - mon.x
    x2 = x2 - mon.x
    y1 = y1 - mon.y
    y2 = y2 - mon.y
    local a = x2*x2 + y2*y2
    local b = 2*(x1*x2+y1*y2)
    local c = (x1*x1)+(y1*y1)-(mon.r*mon.r)
    
    local t1 = (math.sqrt(b*b - (4*a*c)) - b)/(2*a)
    local t2 = -(math.sqrt(b*b - (4*a*c)) + b)/(2*a)
    
    if (0 < t1  and t1 < 1) or (0 < t2 and t2 < 1) then
      -- We hit the monster, I think...
      mon:damage(10)
    end
  end
end

function Projectile:update(dt)
  self:move(dt)
  self:checkCollisions(dt)
end

function Projectile.drawAll()
  for _,p in pairs(Projectile.list) do
    p:draw()
  end
end

function Projectile:draw()
  love.graphics.setColor(0,0,0)
  love.graphics.circle("fill", self.x, self.y, 3)
end

function Projectile:onHit(target)
  if target ~= nil then
    target:damage(self.damage)
  end
  dead=true
end