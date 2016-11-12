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
                              function(this) this.dead=true end,
                              function(this) Sound.play("explosion1") end,
                              function(this, target) this.dead=true; if target ~= nil then target:damage(100); print(target.hp) end; end,
                              nil
                            })
Weapon.laser=Weapon.new(0, {20000,
    function(this, dt)
      for _,mon in pairs(Monster.list) do
        local x1 = this.x - this.vx*dt
        local x2 = this.x
        local y1 = this.y - this.vy*dt
        local y2 = this.y
        x1 = x1 - mon.x
        x2 = x2 - mon.x
        y1 = y1 - mon.y
        y2 = y2 - mon.y
        local a = x2*x2 + y2*y2
        local b = 2*(x1*x2+y1*y2)
        local c = (x1*x1)+(y1*y1)-(mon.r*mon.r)
        
        local t1 = (math.sqrt(b*b - (4*a*c)) - b)/(2*a)
        local t2 = -(math.sqrt(b*b - (4*a*c)) + b)/(2*a)
        
        if (0 < t1  and t1 < 1) or (0 < t2 and t2 < 1) then
          -- We hit the monster, I think...
          mon:damage(10)
        end
      end
    end,
    function(this) end,
    function(this, target) end,
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
