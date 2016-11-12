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
  if self.cdLeft <= 0 then
    RocketProjectile.new(fromX, fromY, orientation)
    self.cdLeft = self.firingCooldown
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
  
  new.explosionState = 0
  new.explodedEnemies = {}
  new.explosionDamage = 50
  new.explosionSize = 50
end

function RocketProjectile:onHit(target)
  self.explosionState = 1
  Land.makeHole(self.x, self.y, self.explosionSize)
end

function RocketProjectile:update(dt)
  if self.explosionState == 0 then
    Projectile.update(self, dt)
  elseif self.explosionState < 6 then
    for _,monster in pairs(Monster.list) do
      if not self.explodedEnemies[monster] then
        monster:damage(self.explosionDamage)
        self.explodedEnemies[monster] = true
      end
    end
    self.explosionState = self.explosionState + 1
  else
    self.dead = true
  end
end

function RocketProjectile:draw()
  if self.explosionState == 0 then
    print(self.explosionState)
    local tmp = love.graphics.getColor()
    love.graphics.setColor(255,255,255,255)
    local img = getImage("missile")
    love.graphics.draw(img, self.x, self.y, math.atan2(self.vy, self.vx), 1, 1, img:getWidth()/2, img:getHeight()/2)
  else
    print("exploding, please wait")
    local img = getImage("planetexplosion"..self.explosionState)
    love.graphics.draw(img, self.x, self.y, 0, self.explosionSize/img:getWidth(), self.explosionSize/img:getHeight(), self.explosionSize/2, self.explosionSize/2)
  end
end
