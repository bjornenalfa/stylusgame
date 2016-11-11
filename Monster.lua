Monster = {}
local m = Monster
m.__index = m
m.list = {}

--The class for the monsters running around, possibly abstract

function Monster.new(x, y, r, image)
  new = {x = x,
         y = y,
         vx = 0,
         vy = 0,
         r = r,
         image = image
         hp = 100,
         maxhp = 100,
         dead = false,
         moved = false -- might not be needed
  }
  setmetatable(new, Monster)
  table.insert(m.list, new)
  return new
end

function Monster:update(dt)
  dead = {}
  for i,mon in pairs(m.list) do
    if mon.moved then
      --perhaps do stuff with animation
    end
    mon.x = mon.x + mon.vx * dt
    mon.y = mon.y + mon.vy * dt
    
    if mon.dead then
      table.insert(dead, i)
    end
  end
  for i = #dead, 1, -1 do
    mon = m.list[dead[i]]
    table.remove(m.list, dead[i])
    mon.die()
  end
end

function Monster:damage(damage)
  damage = math.floor(damage+0.5)
  if damage > 0 then
    self.hp = self.hp - damage
  end
end

function Monster:die()
  -- perhaps reward the player or something
end

--r is the rotation in radians
function Monster:draw()
  love.graphics.setColor(255, 255, 255) -- is this needed?
  for i,mon in pairs(m.list) do
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(mon.image, mon.x, mon.y, mon.r, 1, 1, mon.image:getWidth()/2, mon.image:getHeight()/2)
    --[[ draw out health if wanted
    love.graphics.setColor(255, 0, 0, 100)
    love.graphics.rectangle("fill", mon.x - 20, mon.y - 40, 40, 10)
    love.graphics.rectange("fill", mon.x - 20, mon.y - 40 , 40*(mon.hp/mon.maxhp), 10)
    --]]
  end
end
    
    