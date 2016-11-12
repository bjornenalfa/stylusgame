Projectile = {}
Projectile.__index = Projectile

Projectile.list = {}

Projectile.templates = {}
Projectile.templates.bullet={200,
                              4,
                              (function(this) print("fire!!!") end),
                              (function(this) end),
                              (function(this, target) this.dead=true end),
                              (function(this) end),
                              --Image.getImage("planetexplosion1")
                              }

function Projectile.fromTemplate(x, y, angle, template)
  local new = {
    x=x,
    y=y,
    vx=math.cos(angle)*template[1],
    vy=math.sin(angle)*template[1],
    remainingLifetime=template[2],
    onDestroy=template[4],
    onHit=template[5],
    onTimeout=template[6],
    dead=false,
    image=template[7]
  }
  setmetatable(new, Projectile)
  table.insert(Projectile.list, new)
  
  template[3](new)
  
  return new
end

function Projectile.updateAll(dt)
  local killed = {}
  for index,p in pairs(Projectile.list) do
    if p.remainingLifetime <= dt then
      p:onTimeout()
      tables.insert(killed, index)
    else
      p:update(dt)
      if p.dead then
        tables.insert(killed, index)
        p:onDestroy()
      end
    end
    
    for i = #killed, 1, -1 do
      tables.remove(Projectile.list, killed[i])
    end
  end
end

function Projectile:update(dt)
  self.remainingLifetime = self.remainingLifetime - dt
  self.x = self.x + self.vx * dt
  self.y = self.y + self.vy * dt
  
  if Land.isBlocked(self.x, self.y) then
    self.onHit(nil)
  end
end

function Projectile.drawAll()
  for _,p in Projectile.list do
    -- love.graphics.draw(p.image, p.x, p.y, 
  end
end