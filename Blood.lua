Blood = {}
local b = Blood

b.canvas = nil

function Blood.newMap()
  b.canvas = love.graphics.newCanvas(Map.width, Map.height)
end

function Blood.new(x, y, r)
  b.canvas:renderTo(function ()
      love.graphics.setColor(255,255,255)
      local img = getImage("blood"..math.random(1,9))
      local scale = 2*(r/img:getWidth())
      love.graphics.draw(img, x, y, 0, scale, scale, img:getWidth()/2, img:getHeight()/2)
    end)
end

function Blood.dust(x, y, r)
  b.canvas:renderTo(function ()
      love.graphics.setColor(255,255,255)
      local img = getImage("dust2")
      local scale = 1.2*(r/img:getWidth())
      love.graphics.draw(img, x, y, 0, scale, scale, img:getWidth()/2, img:getHeight()/2)
    end)
end

function Blood.draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(b.canvas)
end