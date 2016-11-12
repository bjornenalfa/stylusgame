require "Sound"
require "Image"
require "Input"
require "Camera"
require "Land"
require "Map"
require "Explosions"
require "Projectile"
require "Player"
require "Stylus"

function love.load()
  Map.load("map01")
  Stylus.newMap()
  love.graphics.setBackgroundColor(255,255,255)
  love.mouse.setVisible(false)
  Player.new("p1", 300, 300, {255, 0, 0}, 1)
end

function love.keypressed(key)
  
end

function love.mousepressed(x, y, button)
  
end

function love.mousereleased(x, y, button)
  Stylus.mousereleased(x, y, button)
end

function love.update(dt)
  Stylus.update(dt)
  Land.update(dt)
  Player.updateAll(dt)
  Camera.update(dt)
end


function love.draw()
  Camera.draw()
  Map.draw()
  Explosions.drawShake()
  Stylus.draw()
  Player.drawAll()
  Explosions.draw()
  
  love.graphics.origin() -- reset all shakes
  Camera.draw()
  
  Camera.drawOOB()
  Stylus.drawCursor() -- should be last
end
