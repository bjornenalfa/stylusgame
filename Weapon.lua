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

--[[
Weapon.default=Weapon.new(0.1, {800,
                    (function(this) end),
                    (function(this) end),
                    (function(this, target) this.dead=true end),
                    getImage("planetexplosion1")
                  }
              )
Sound.addStaticSound("explosion1", ".wav")
Weapon.rocket=Weapon.new(1, {600,
                              function(this) this.dead=true end,
                              function(this) Sound.play("explosion1") end,
                              function(this, target) this.dead=true; if target ~= nil then target:damage(100); print(target.hp) end; end,
                              nil
                            })
Weapon.laser=Weapon.new(0, {20000,
    function(this, dt)
      
    end,
    function(this) end,
    function(this, target) end,
    nil
    })
--]]
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

