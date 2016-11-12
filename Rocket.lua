Rocket = {}

Rocket.__index = Rocket
setmetatable(Rocket, Weapon)

function Rocket.new(firingCooldown, dmg)
  firingCooldown = firingCooldown or 2
  print("cd: "..firingCooldown)
  dmg = dmg or 70
  local new = Weapon.new(firingCooldown, dmg)
  setmetatable(new, Rocket)
  
  return new
end

function Rocket:fire(fromX, fromY, orientation)
  print("trying to fire...")
  if self.cdLeft <= 0 then
    print("firing (cd: "..self.cdLeft..")")
    RocketProjectile.new(fromX, fromY, orientation)
    self.cdLeft = self.firingCooldown
  else
    print("on CD (cd: "..self.cdLeft..")")
  end
end

function Rocket:update(dt) Weapon.update(self, dt) end


RocketProjectile = {}

RocketProjectile.__index = RocketProjectile
setmetatable(RocketProjectile, Projectile)

function RocketProjectile.new(x, y, angle, damage, speed)
  damage = damage or 70
  speed = speed or 200
  local new = Projectile.new(x, y, angle, damage, speed)
  
  setmetatable(new, RocketProjectile)
end

function RocketProjectile:onHit(target)
  -- TODO: replace with splash damage
  if target ~= nil then
    target:damage(self.damage)
  end
  dead=true
end

function RocketProjectile:draw()
  local tmp = love.graphics.getColor()
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(getImage("missile"), self.x, self.y, math.atan2(self.vy, self.vx))
end
