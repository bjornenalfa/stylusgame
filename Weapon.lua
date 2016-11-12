Weapon = {}
Weapon.__index = Weapon

Weapon.list = {}

function Weapon.new(firingSpeed, projectileTemplate) 
  local new = {
    firingCooldown=firingSpeed,
    projectileTemplate=projectileTemplate,
    cdLeft = 0
  }
  
  setmetatable(new, Weapon)
  table.insert(Weapon.list, new)
  
  return new
end

Weapon.default=Weapon.new(0.1, {800,
                    (function(this) end),
                    (function(this) end),
                    (function(this, target) this.dead=true end),
                    getImage("planetexplosion1")
                  }
              )
Sound.addStaticSound("explosion1", ".wav")
Weapon.rocket=Weapon.new(1, {600,
                              function(this) end,
                              function(this) Sound.play("explosion1") end,
                              function(this, target) this.dead=true; if target ~= nil then target:die() end end,
                              nil
                            })

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
