Rocket = {}

Rocket.__index = Rocket
setmetatable(Rocket, Weapon)

function Rocket.new(firingCooldown, dmg)
  firingCooldown = firingCooldown or 0.5
  dmg = dmg or 30
  local new = Weapon.new(firingCooldown, dmg)
  new["image"] = getImage("weapons/bazooka")
  setmetatable(new, Rocket)
  
  return new
end

function Rocket:fire(fromX, fromY, orientation)
  if self.cdLeft <= 0 then
    Sound.play("missile_shoot")
    RocketProjectile.new(fromX, fromY, orientation)
    self.cdLeft = self.firingCooldown
  end
end

function Rocket:update(dt) Weapon.update(self, dt) end


RocketProjectile = {}

RocketProjectile.__index = RocketProjectile
setmetatable(RocketProjectile, Projectile)

function RocketProjectile.new(x, y, angle, damage, speed)
  damage = damage or 0
  speed = speed or 200
  local new = Projectile.new(x, y, angle, damage, speed)
  
  setmetatable(new, RocketProjectile)
  
  new.explosionDamage = 50
  new.explosionSize = 50
end

function RocketProjectile:onHit(target)
  self.dead = true
  Explosions.new(self.x, self.y, 0.5, self.explosionSize, true)
  for _,monster in pairs(Monster.list) do
    local x = monster.x - self.x
    local y = monster.y - self.y
    local r = monster.r + self.explosionSize
    if x*x + y*y <= r*r then
      monster:damage(self.explosionDamage)
    end
  end
end

function RocketProjectile:draw()
  love.graphics.setColor(255,255,255,255)
  local img = getImage("missile")
  love.graphics.draw(img, self.x, self.y, math.atan2(self.vy, self.vx), 1, 1, img:getWidth()/2, img:getHeight()/2)
end
