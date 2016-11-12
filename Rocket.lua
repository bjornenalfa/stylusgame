Rocket = {}

Rocket.__index = Rocket
setmetatable(Rocket, Weapon)

function Rocket.new(firingCooldown, dmg)
  firingCooldown = firingCooldown or 2
  dmg = dmg or 70
  local new = Weapon.new(firingCooldown, dmg)
  setmetatable(new, Rocket)
  
  return new
end

function Rocket:fire(fromX, fromY, orientation)
  RocketProjectile.new(fromX, fromY, orientation)
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