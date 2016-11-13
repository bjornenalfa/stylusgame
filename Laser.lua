Laser = {}
Laser.__index = Laser
setmetatable(Laser, Weapon)

function Laser.new(cooldown, d)
  cooldown = cooldown or 1
  d = d or 25
  local new = Weapon.new(cooldown)
  new["image"] = getImage("weapons/laser_gun")
  new["damage"] = d
  new.image = getImage("weapons/laser_gun")
  setmetatable(new, Laser)
  
  Laser.altFireDelay = 1.5
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
      LaserProjectile.new(self.player.x, self.player.y, self.player.orientation, 300, 1, true)
      Sound.play("laser3")
      self.player.movementImpair = false
      self.altFireTimer = nil
    end
  end
end

function Laser:altFire(player)
  if self.altFireTimer == nil then
    Sound.play("laser4")
    self.altFireTimer = self.altFireDelay
    self.player.movementImpair = true
  end
end

function Laser:draw()
  Weapon.draw(self)
  if self.altFireTimer ~= nil then
    local lw = love.graphics.getLineWidth()
    local r,g,b = love.graphics.getColor()
    love.graphics.setLineWidth(1)
    love.graphics.setColor(255, 0, 0, 255*(1 - (self.altFireTimer/self.altFireDelay)))
    
    local dx = 10*math.cos(self.player.orientation)
    local dy = 10*math.sin(self.player.orientation)
    local tx = self.player.x
    local ty = self.player.y
    for _ = 0, 200, 1 do
      tx = tx + dx
      ty = ty + dy
      if Land.isBlocked(tx, ty) then break end
    end
    love.graphics.line(self.player.x, self.player.y, tx, ty)
    love.graphics.setLineWidth(lw)
    love.graphics.setColor(r,g,b)
  end
end


LaserProjectile = {}
LaserProjectile.__index = LaserProjectile
setmetatable(LaserProjectile, Projectile)

local LIFETIME = 1

function LaserProjectile.new(fromX, fromY, orientation, damage, vel, isPiercing)
  local new = Projectile.new(fromX, fromY,orientation, damage, vel)
  setmetatable(new, LaserProjectile)
  new["timeout"] = LIFETIME
  new["stopX"] = 0
  new["stopY"] = 0
  new.isPiercing = isPiercing or nil
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
      if not self.isPiercing then
        isHit = true
        break
      end
    end
    if Land.isBlocked(x, y) then
      isHit = true
      break
    end
  end
  self.stopX = x
  self.stopY = y
  Sound.play("laser2")
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
  