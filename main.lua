require "Sound"
require "Image"
require "Input"
require "camera2"
require "Land"
require "Map"
require "Explosions"
require "Projectile"
require "Player"
require "Stylus"
require "Monster"
require "Weapon"

function love.load()
  love.graphics.setDefaultFilter("linear", "nearest", 2)
  Map.load("map01")
  Land.newMap()
  love.graphics.setBackgroundColor(255,255,255)
  love.mouse.setVisible(false)
  local pl = Player.new("p1", 300, 300, {255, 0, 0}, 1)
  --Camera.trackEntity(pl)
  local mon = Monster.new(150, 150, 10, getImage("hero"))
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
  camera.update(dt)
  Monster.updateAll(dt)
  Projectile.updateAll(dt)
end


function love.draw()
  camera.draw()
  Map.draw()
  Explosions.drawShake()
  Projectile.drawAll()
  Player.drawAll()
  Land.draw()
  Map.drawShadow()
  Monster.drawAll()
  Explosions.draw()
  
  
  love.graphics.origin() -- reset all shakes
  camera.draw()
  
  --Camera.drawOOB()
  
  
  love.graphics.origin() -- reset to screen drawing (UI)
  
  Stylus.drawUI() -- should be last
end
