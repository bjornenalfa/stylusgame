
require "Land"
require "Player"
require "Stylus"

function love.load()
  love.graphics.setBackgroundColor(255,255,255)
  
  Player.new("p1", 300, 300, {255, 0, 0}, 1)
end

function love.keypressed(key)
  
end

function love.mousepressed(x, y, button)
  
end

function love.update(dt)
  Stylus.update(dt)
  Player.updateAll(dt)
end


function love.draw()
  Stylus.draw()
  Player.drawAll()
end
