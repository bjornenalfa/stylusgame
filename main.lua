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
require "Weapon"

function love.load()
  Map.load("map01")
  Stylus.newMap()
  love.graphics.setBackgroundColor(255,255,255)
  love.mouse.setVisible(false)
  local pl = Player.new("p1", 300, 300, {255, 0, 0}, 1)
  Camera.trackEntity(pl)
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
  Projectile.updateAll(dt)
end


function love.draw()
  Camera.draw()
  Map.draw()
  Explosions.drawShake()
  Stylus.drawLand()
  Player.drawAll()
  Explosions.draw()
  Projectile.drawAll()
  
  
  love.graphics.origin() -- reset all shakes
  Camera.draw()
  
  Camera.drawOOB()
  
  
  love.graphics.origin() -- reset to screen drawing (UI)
  
  Stylus.drawUI() -- should be last
end
