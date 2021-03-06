MachineGun = {}
MachineGun.__index = MachineGun
setmetatable(MachineGun, Weapon)

function MachineGun.new(cooldown, d, speed)
  cooldown = cooldown or 0.1
  d = d or 25
  speed = speed or 10
  local new = Weapon.new(cooldown)
  new["image"] = getImage("weapons/machine_gun")
  new["damage"] = d
  new["velocity"] = speed
  new["firingTime"] = 0
  --new["fireSpread"] = 0
  new["maxSpread"] = 5
  new["fireTime"] = 0
  new["setupTime"] = 1
  new["setupTimeLeft"] = new.setupTime
  new["setupState"] = 0
  new["lockedAngle"] = nil
  assert(new.setupState ~= nil)
  setmetatable(new, MachineGun)
  return new
end

IS_NOT_SETUP = 0
IS_SETTING_UP = 1
IS_SETUP = 2
IS_TEARING_DOWN = 3


function MachineGun:fire(fromX, fromY, orientation)
  if self.cdLeft <= 0 then
    if self.setupState == IS_SETUP then
      self.firingTime = math.min(self.firingTime + 0.2, self.maxSpread/2)
      local angleOffset = (math.random(-self.firingTime, self.firingTime)/self.maxSpread)*math.pi/18
      MachineGunProjectile.new(fromX, fromY, orientation+angleOffset, self.damage, self.velocity, self.player)
      self.cdLeft = self.firingCooldown / 2500
      self.fireTime = 0
    elseif self.setupState == IS_NOT_SETUP then
      self.firingTime = math.min(self.firingTime + 0.5, self.maxSpread)
      local angleOffset = (math.random(-self.firingTime, self.firingTime)/self.maxSpread)*math.pi/18
      MachineGunProjectile.new(fromX, fromY, orientation+angleOffset, self.damage, self.velocity, self.player)
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
    self.lockedAngle = self.player.orientation
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
  
  if self.setupState == IS_NOT_SETUP then
    self.player.movementImpair = false
  elseif self.setupState == IS_SETUP or self.setupState == IS_SETTING_UP then
    local playerDir = self.player.orientation
    local lockedDir = self.lockedAngle
    local allowedDiff = math.pi/4
    local function mod(a, n)
      return a - math.floor(a/n) * n
    end
    local diff = playerDir - lockedDir
    diff = (diff + math.pi) % (2*math.pi) - math.pi
    if diff > 0 then
      if diff > allowedDiff then
        self.player.orientation = lockedDir + allowedDiff
      end
    else
      if diff < -allowedDiff then
        self.player.orientation = lockedDir - allowedDiff
      end
    end
  end
  if self.setupState == IS_SETTING_UP or self.setupState == IS_TEARING_DOWN then
    self.player.movementImpair = true
    self.setupTimeLeft = self.setupTimeLeft - dt
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

function MachineGun:draw(object)
  --love.graphics.print("timeLeft: "..tostring(self.setupTimeLeft) .. " state: " ..tostring(self.setupState .. " moveme. " .. tostring(self.player.movementImpair)), object.x - 150, object.y - 20)
  local state = self.setupState
  -- scaling so we can draw the gun bigger when in mounter mode
  local weaponScale = 0.5
  local timeScale = 0
  if state == IS_NOT_SETUP then
    timeScale = 0
  else
    -- draw a sandobstacle to tell the player he/she is in machinegun mode
    local offset = 20
    local x = self.player.x + math.cos(self.lockedAngle) * offset
    local y = self.player.y + math.sin(self.lockedAngle) * offset
    
    local img = getImage("weapons/sandbags")
    local alpha = 255
    if state == IS_SETTING_UP then
      timeScale = (self.setupTime - self.setupTimeLeft) / self.setupTime
      alpha = 255 * timeScale
    elseif state == IS_SETUP then
      alpha = 255
      timeScale = 1
    elseif state == IS_TEARING_DOWN then
      timeScale = 1 - (self.setupTime - self.setupTimeLeft) / self.setupTime
      alpha = 255 - 255 * (1 - timeScale)
    end
    love.graphics.setColor(255, 255, 255, alpha)
    love.graphics.draw(img, x, y, self.lockedAngle, 0.8, 1, img:getWidth()/2, img:getHeight()/2)
    
    love.graphics.setColor(255, 255, 255)
  end
  --draw weapon
  local p = self.player
  local imgW = self.image:getWidth()
  local imgH = self.image:getHeight()
  local scaleX = 4 * self.player.size/imgW + weaponScale * timeScale
  local scaleY = 4 * self.player.size/imgH + weaponScale * timeScale
  love.graphics.draw(self.image, p.x, p.y, p.orientation, scaleX, scaleY, imgW/2, imgH/2)
end

MachineGunProjectile = {}
MachineGunProjectile.__index = MachineGunProjectile
setmetatable(MachineGunProjectile, Projectile)

function MachineGunProjectile.new(fromX, fromY, orientation, damage, vel, player)
  local new = Projectile.new(fromX, fromY, orientation, damage, vel, player)
  new["image"] = getImage("shot")
  Sound.play("hit3")
  setmetatable(new, MachineGunProjectile)
  return new
end

function MachineGunProjectile:move(dt)
  local dx = self.vx--math.cos(self.angle) * self.vel
  local dy = self.vy--math.sin(self.angle) * self.vel
  self.x = self.x + dx
  self.y = self.y + dy
  --[[local steps = 5
  for i = 0, steps, 1 do
    self.x = self.x + dx / steps
    self.y = self.y + dy / steps
    if Land.isBlocked(self.x, self.y) then
      self.dead = true
      break
    end
  end]]
end

function MachineGunProjectile:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(self.image, self.x, self.y, self.angle, 1, 1, self.image:getWidth()/2, self.image:getHeight()/2)
end