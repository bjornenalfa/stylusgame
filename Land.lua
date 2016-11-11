Land = {}
local l = Land

l.landImage = nil

function Land.isBlocked(x, y)
  x = math.floor(x)
  y = math.floor(y)
  if not l.landImage then
    return false
  end
  if x < 0 or x > l.landImage:getWidth() or y < 0 or y > l.landImage:getHeight() then
    return true
  end
  r,g,b,a = l.landImage:getPixel(x, y)
  return a ~= 0
end

l.nt = 0 -- new image date grab timer
l.gct = 0 -- garbage collect timer

function Land.update(dt)
  l.nt = l.nt + dt
  l.gct = l.gct + dt
  if l.nt > 0.2 then
    l.nt = 0
    if Stylus.drawn then
      Stylus.drawn = false
      l.landImage = Stylus.canvas:newImageData()
    end
  end
end
