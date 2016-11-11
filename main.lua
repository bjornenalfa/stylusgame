require "Stylus"

function love.load()
  love.graphics.setBackgroundColor(255,255,255)
end

function love.keypressed(key)
  
end

function love.mousepressed(x, y, button)
    
end

function love.update(dt)
  Stylus.update(dt)
end


function love.draw()
  Stylus.draw()
end
