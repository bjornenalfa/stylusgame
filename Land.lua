Land = {}
local l = Land

l.drawn = false
l.breakableCanvas = nil
l.breakableImage = nil

l.solidCanvas = nil
l.solidImage = nil

function Land.newMap()
  l.breakableCanvas = love.graphics.newCanvas(Map.width, Map.height)
  l.drawBreakable(function ()
    love.graphics.setColor(255,255,255)
    love.graphics.draw(Map.breakable)
  end)
  l.breakableImage = l.breakableCanvas:newImageData()
  l.solidCanvas = love.graphics.newCanvas(Map.width, Map.height)
  l.drawSolid(function ()
    love.graphics.setColor(255,255,255)
    love.graphics.draw(Map.solid,0,0)
  end)
end

function Land.isBlocked(x, y)
  x = math.floor(x)
  y = math.floor(y)
  if x < 0 or x >= Map.width or y < 0 or y >= Map.height then
    return true
  end
  r,g,b,a = l.breakableImage:getPixel(x, y)
  r,g,b,a2 = l.solidImage:getPixel(x,y)
  return a2 ~= 0 or a ~= 0
end

l.nt = 0 -- new image date grab timer
l.gct = 0 -- garbage collect counter

function Land.update(dt)
  l.nt = l.nt + dt
  if l.nt > 0.2 then
    l.nt = 0
    if l.drawn then
      l.drawn = false
      l.breakableImage = Land.breakableCanvas:newImageData()
      l.gct = l.gct + 1
    end
  end
  if l.gct > 50 then
    l.gct = 0
    collectgarbage()
  end
end

function Land.makeHole(x, y, r)
  love.graphics.origin()
  love.graphics.setBlendMode("replace")
  love.graphics.setColor(0,0,0,0)
  Land.drawBreakable(function ()
    love.graphics.circle("fill",x,y,r)
  end)
  Stylus.makeHole(x, y, r)
  love.graphics.setBlendMode("alpha")
end

function Land.drawBreakable(func)
  l.drawn = true
  l.breakableCanvas:renderTo(func)
end

function Land.drawSolid(func)
  l.solidCanvas:renderTo(func)
  l.solidImage = l.solidCanvas:newImageData()
end

function Land.draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(l.breakableCanvas)
  love.graphics.draw(l.solidCanvas)
end
