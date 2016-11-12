Laser = {}
Laser.__index = Laser
setmetatable(Laser, Weapon)

function Laser.new(cooldown, d)
  cooldown = cooldown or 2.5
  d = d or 25
  local new = Weapon.new(cooldown)
  new["image"] = getImage("weapons/laser_gun")
  new["damage"] = d
  new.image = getImage("weapons/laser_gun")
  setmetatable(new, Laser)
  
  Laser.altFireDelay = 2
  return new
end

function Laser:fire(fromX, fromY, orientation)
  if self.cdLeft <= 0 then
    LaserProjectile.new(fromX, fromY, orientation, 10, 0)
    self.cdLeft = self.firingCooldown
  end
end

function Laser:update(dt)
  if self.altFireTimer == nil then
    Weapon.update(self, dt)
  else
    self.altFireTimer = self.altFireTimer - dt
    if self.altFireTimer <= 0 then
      LaserProjectile.new(self.player.x, self.player.y, self.player.orientation, 300, 1)
      self.player.movementImpair = false
      self.altFireTimer = nil
    end
  end
end

function Laser:altFire(player)
  if self.altFireTimer == nil then
    self.altFireTimer = self.altFireDelay
    self.player.movementImpair = true
  end
end

function Laser:draw()
  if self.altFireTimer == nil then
    Weapon.draw(self)
  else
    Weapon.draw(self)
    local lw = love.graphics.getLineWidth()
    local r,g,b = love.graphics.getColor()
    love.graphics.setLineWidth(1)
    love.graphics.setColor(255, 0, 0, 255*(1 - (self.altFireTimer/self.altFireDelay)))
    love.graphics.line(self.player.x, self.player.y, self.player.x + 2000*math.cos(self.player.orientation), self.player.y + 2000*math.sin(self.player.orientation))
    love.graphics.setLineWidth(lw)
    love.graphics.setColor(r,g,b)
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
    local hitMonster = Monster.pointInMonster(x, y)
    if hitMonster then
      hitMonster:damage(self.damage)
      isHit = true
      break
    end
    if Land.isBlocked(x, y) then
      isHit = true
      break
    end
  end
  self.stopX = x
  self.stopY = y
  Sound.play("laser_shoot")
  Screenshake.new(0.5, 0.5)
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
  