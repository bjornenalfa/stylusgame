Blood = {}
local b = Blood

b.canvas = nil

function Blood.newMap()
  b.canvas = love.graphics.newCanvas(Map.width, Map.height)
end

function Blood.new(x, y, r)
  
end

function Blood.dust(x, y, r)
  
end

function Blood.draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(b.canvas)
end