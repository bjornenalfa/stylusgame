Projectile = {}
Projectile.__index = Projectile

Projectile.list = {}

function Projectile.fromTemplate(x, y, angle, template)
  local new = {
    x=x,
    y=y,
    vx=math.cos(angle)*template[1],
    vy=math.sin(angle)*template[1],
    onDestroy=template[3],
    onHit=template[4],
    dead=false,
    image=template[5]
  }
  setmetatable(new, Projectile)
  table.insert(Projectile.list, new)
  
  template[2](new)
  
  return new
end

function Projectile.updateAll(dt)
  local killed = {}
  for index,p in pairs(Projectile.list) do
    p:update(dt)
    if p.dead then
      p:onDestroy()
      table.insert(killed, index)
    end
  end
  for i = #killed, 1, -1 do
    table.remove(Projectile.list, killed[i])
  end
end

function Projectile:update(dt)
  self.x = self.x + self.vx * dt
  self.y = self.y + self.vy * dt
  
  if Land.isBlocked(self.x, self.y) then
    self:onHit(nil)
  end
end

function Projectile.drawAll()
  for _,p in pairs(Projectile.list) do
    --love.graphics.draw(p.image, p.x, p.y, math.atan2(p.vy, p.vx), 1, 1)
    love.graphics.setColor(0,0,0)
    love.graphics.circle("fill", p.x, p.y, 3)
  end
end