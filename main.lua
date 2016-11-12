require "Sound"
require "Image"
require "Input"
require "Camera2"
require "Land"
require "Map"
require "Explosions"
require "Projectile"
require "Player"
require "Stylus"
require "Monster"
require "Zombieduck"
require "Duckcrab"
require "Weapon"
require "Rocket"
require "Screenshake"
require "Laser"
require "MachineGun"

function love.load()
  love.graphics.setDefaultFilter("linear", "nearest", 2)
  Map.load("map01")
  Land.newMap()
  Stylus.newMap()
  love.graphics.setBackgroundColor(255,255,255)
  --love.mouse.setVisible(false)
  love.mouse.setCursor(love.mouse.newCursor(getImage("mouse"):getData(), 10, 10))
  local pl = Player.new("p1", 300, 300, {255, 0, 0}, 1)
  --Camera.trackEntity(pl)
  local mon = Zombieduck.new(150, 150, 10, getImage("hero"))
  local mon2 = Duckcrab.new(200, 200, 10, getImage("hero"))
end

function love.keypressed(key)
  
end

function love.mousepressed(x, y, button)
  
end

function love.mousereleased(x, y, button)
  Stylus.mousereleased(x, y, button)
end

function love.update(dt)
  Screenshake.update(dt)
  Stylus.update(dt)
  Land.update(dt)
  Player.updateAll(dt)
  Camera.update(dt)
  Monster.updateAll(dt)
  Projectile.updateAll(dt)
end


function love.draw()
  Camera.draw()
  Explosions.drawShake()
  Screenshake.draw()
  Map.draw()
  Projectile.drawAll()
  Player.drawAll()
  Monster.drawAll()
  Map.drawShadow()
  Stylus.drawBackground()
  Land.draw()
  Explosions.draw()
  
  
  love.graphics.origin() -- reset all shakes
  Camera.draw()
  
  --Camera.drawOOB()
  
  
  love.graphics.origin() -- reset to screen drawing (UI)
  
  Stylus.drawUI() -- should be last
end
