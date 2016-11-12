Laser = {}
Laser.__index = Laser
setmetatable(Laser, Weapon)

function Laser.new(cooldown, d)
  cooldown = cooldown or 2.5
  d = d or 25
  local new = Weapon.new(cooldown)
  new["damage"] = d
  setmetatable(new, Laser)
  return new
end

function Laser:fire(fromX, fromY, orientation)
  if self.cdLeft <= 0 then
    LaserProjectile.new(fromX, fromY, orientation, 10, 0)
    self.cdLeft = self.firingCooldown
  end
end



LaserProjectile = {}
LaserProjectile.__index = LaserProjectile
setmetatable(LaserProjectile, Projectile)

local LIFETIME = 1

function LaserProjectile.new(fromX, fromY, orientation, damage, vel)
  local new = Projectile.new(fromX, fromY,orientation, damage, vel)
  setmetatable(new, LaserProjectile)
  new["timeout"] = LIFETIME
  new["stopX"] = 0
  new["stopY"] = 0
  new:fire()
  return new
end

function LaserProjectile:fire()
  local isHit = false
  local x = self.x
  local y = self.y
  local dis = 3
  local dx = math.cos(self.angle) * dis
  local dy = math.sin(self.angle) * dis
  while not isHit do
    x = x + dx
    y = y + dy
    if Land.isBlocked(x, y) then
      isHit = true
      self.stopX = x
      self.stopY = y
    end
    -- aslo need a check over all monsters
  end
  Sound.play("laser_shoot")
  Screenshake.new(2, 5)
end

function LaserProjectile:update(dt)
  self.timeout = self.timeout - dt
  if self.timeout <= 0 then
    self.dead = true
  end
end

function LaserProjectile:draw()
  love.graphics.setLineWidth(2)
  
  love.graphics.setColor(50, 150, 250, 255*self.timeout/LIFETIME)
  love.graphics.line(self.x, self.y, self.stopX, self.stopY)
  love.graphics.setLineWidth(1)
end

  