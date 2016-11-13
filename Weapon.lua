Weapon = {}
Weapon.__index = Weapon

Weapon.list = {}

function Weapon.new(firingSpeed, projectileTemplate) 
  local new = {
    player = nil,
    firingCooldown=firingSpeed,
    projectileTemplate=projectileTemplate,
    cdLeft = 0
  }
  setmetatable(new, Weapon)
  table.insert(Weapon.list, new)
  
  return new
end


function Weapon:fire(fromX, fromY, orientation)
  if (self.cdLeft <= 0) then
    Projectile.fromTemplate(fromX, fromY, orientation, self.projectileTemplate)
    self.cdLeft = self.firingCooldown
  end
end

function Weapon:update(dt)
  if self.cdLeft > 0 then
    self.cdLeft = self.cdLeft - dt
  end
end

function Weapon:draw()
  local p = self.player
  local imgW = self.image:getWidth()
  local imgH = self.image:getHeight()
  local scaleX = 2 * self.player.size/imgW
  local scaleY = 2 * self.player.size/imgH
  love.graphics.draw(self.image, p.x, p.y, p.orientation, scaleX, scaleY, imgW/2, imgH/2)
end

