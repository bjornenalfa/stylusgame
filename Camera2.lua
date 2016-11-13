Camera = {}
local c = Camera

c.x = 0
c.y = 0
c.xscale = 2
c.yscale = 2

function Camera.windowToWorld(x, y)
  return (x)/c.xscale + c.x, (y)/c.yscale + c.y
end

function Camera.getBounds()
  width = love.graphics.getWidth() / c.xscale
  height = love.graphics.getHeight() / c.yscale
  return c.x, c.y, width, height
end

function Camera.update(dt)
  local player = Player.list["p1"]
  width = love.graphics.getWidth() / c.xscale
  height = love.graphics.getHeight() / c.yscale
  c.x = math.max(0, math.min(player.x - width / 2, Map.width - width))
  c.y = math.max(0, math.min(player.y - height / 2, Map.height - height))
end

function Camera.draw()
  --love.graphics.translate(math.floor(-c.x), math.floor(-c.y))
  love.graphics.scale(c.xscale, c.yscale)
  --love.graphics.translate(-c.x, -c.y) -- sometimes gives artifacts
  love.graphics.translate(math.floor(-c.x*c.xscale)/c.xscale, math.floor(-c.y*c.yscale)/c.yscale)
end
