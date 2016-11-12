MachineGun = {}
MachineGun.__index = MachineGun
setmetatable(MachineGun, Weapon)

function MachineGun.new(cooldown, d, speed)
  local new = Weapon.new(cooldown)
  new["damage"] = d
  new["velocity"] = speed
  new["firingTime"] = 0
  --new["fireSpread"] = 0
  new["maxSpread"] = 5
  new["fireTime"] = 0
  new["setupTime"] = 3
  new["setupTimeLeft"] = new.setupTime
  setmetatable(new, MachineGun)
  return new
end

function MachineGun:fire(fromX, fromY, orientation)
  if self.cdLeft <= 0 then
    self.firingTime = math.min(self.firingTime + 0.5, self.maxSpread)
    local angleOffset = (math.random(-self.firingTime, self.firingTime) / self.maxSpread) * math.pi/18
    
    MachineGunProjectile.new(fromX, fromY, orientation+angleOffset, self.damage, self.velocity)
    self.cdLeft = self.firingCooldown
    self.fireTime = 0
  end    
end

function MachineGun:update(dt)
  Weapon.update(self, dt)
  self.fireTime = self.fireTime + dt
  if self.firingTime > 0 and self.fireTime > 0.5 then
    self.firingTime = self.firingTime - dt*10
  end
  print("firingTime: "..self.firingTime)
end

MachineGunProjectile = {}
MachineGunProjectile.__index = MachineGunProjectile
setmetatable(MachineGunProjectile, Projectile)

function MachineGunProjectile.new(fromX, fromY, orientation, damage, vel)
  local new = Projectile.new(fromX, fromY, orientation, damage, vel)
  new["image"] = getImage("shot")
  setmetatable(new, MachineGunProjectile)
  return new
end

function MachineGunProjectile:update(dt)
  local dx = self.vx--math.cos(self.angle) * self.vel
  local dy = self.vy--math.sin(self.angle) * self.vel
  local steps = 5
  for i = 0, steps, 1 do
    self.x = self.x + dx / steps
    self.y = self.y + dy / steps
    if Land.isBlocked(self.x, self.y) then
      self.dead = true
      break
    end
  end
end

function MachineGunProjectile:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(self.image, self.x, self.y, self.orientation)--, self.image:getWidth()/2, self.image:getHeight()/2)
end