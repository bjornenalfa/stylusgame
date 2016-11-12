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
  new["setupState"] = IS_NOT_SETUP
  setmetatable(new, MachineGun)
  return new
end

local IS_NOT_SETUP = 0
local IS_SETTING_UP = 1
local IS_SETUP = 2
local IS_TEARING_DOWN = 3


function MachineGun:fire(fromX, fromY, orientation)
  if self.cdLeft <= 0 then
    if self.setupState == IS_SETUP then
      self.firingTime = math.min(self.firingTime + 0.2, self.maxSpread/2)
      local angleOffset = (math.random(-self.firingTime, self.firingTime)/self.maxSpread)*math.pi/18
      MachineGunProjectile.new(fromX, fromY, orientation+angleOffset, self.damage, self.velocity)
      self.cdLeft = self.firingCooldown / 2
      self.fireTime = 0
    elseif self.setupState == IS_NOT_SETUP then
      self.firingTime = math.min(self.firingTime + 0.5, self.maxSpread)
      local angleOffset = (math.random(-self.firingTime, self.firingTime)/self.maxSpread)*math.pi/18
      MachineGunProjectile.new(fromX, fromY, orientation+angleOffset, self.damage, self.velocity)
      self.cdLeft = self.firingCooldown
      self.fireTime = 0
    end
  end    
end

function MachineGun:altFire(fromX, fromY, orientation)
  -- depending on state, we transition and let update(dt) do the work
  -- the states pretty much only changes how the gun is shot, perhaps

  if self.setupState == IS_NOT_SETUP then
    self.setupState = IS_SETTING_UP
  elseif self.setupState == IS_SETTING_UP or self.setupState == IS_TEARING_DOWN then
    --do nothing, maybe a screenshake
  elseif self.setupState == IS_SETUP then
    --move out of setup
    self.setupState = IS_TEARING_DOWN
  end
end

function MachineGun:update(dt)
  Weapon.update(self, dt)
  self.fireTime = self.fireTime + dt
  if self.firingTime > 0 and self.fireTime > 0.5 then
    self.firingTime = self.firingTime - dt*10
  end
  print("firingTime: "..self.firingTime)
  
  if self.setupState == IS_NOT_SETUP then
    -- do nothing
  elseif self.setupState == IS_SETUP then
    --do nothing
  elseif self.setupState == IS_SETTING_UP or self.setupState == IS_TEARING_DOWN then
    self.setupTimeLeft = self.setupTimeLeft - dx
    if self.setupTimeLeft < 0 then
      if self.setupState == IS_SETTING_UP then
        self.setupState = IS_SETUP
      else
        self.setupState = IS_NOT_SETUP
      end
      self.setupTimeLeft = self.setupTime
    end
  end
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
  love.graphics.print("firing time: "..self.firingTime, self.x - 20, self.y - 20)
end