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
require "Crabduck"
require "Crabcannon"
require "Weapon"
require "Rocket"
require "Screenshake"
require "Laser"
require "MachineGun"
require "Pickup"
require "PickupWeapon"

function love.load()
  love.graphics.setDefaultFilter("linear", "nearest", 2)
  Map.load("map02")
  Land.newMap()
  Stylus.newMap()
  love.graphics.setBackgroundColor(255,255,255)
  --love.mouse.setVisible(false)
  love.mouse.setCursor(love.mouse.newCursor(getImage("mouse"):getData(), 10, 10))
  local pl = Player.new("p1", 300, 300, {255, 0, 0}, 1)
  --Camera.trackEntity(pl)
  local mon = Zombieduck.new(150, 150)
  local mon2 = Duckcrab.new(150, 200)
  local mon3 = Crabduck.new(400, 200)
  local mon4 = Crabduck.new(200, 500)
  local mon5 = Crabcannon.new(400, 400)
  
  for i = 1, 20 do
    local pic1 = PickupWeapon.new(math.random(0, Map.width), math.random(0, Map.height))
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "k" then
    Stylus.startSlash(10)
  end
end

function love.mousepressed(x, y, button)
  
end

function love.mousereleased(x, y, button)
  Stylus.mousereleased(x, y, button)
end

time = 0
function love.update(dt)
  time = time + dt
  Screenshake.update(dt)
  Explosions.update(dt)
  Stylus.update(dt)
  Land.update(dt)
  Player.updateAll(dt)
  Pickup.updateAll(dt)
  Camera.update(dt)
  Monster.updateAll(dt)
  Projectile.updateAll(dt)
  Explosions.update(dt)
end


function love.draw()
  Camera.draw()
  Explosions.drawShake()
  Screenshake.draw()
  Map.draw()
  Pickup.drawAll()
  Projectile.drawAll()
  Player.drawAll()
  Monster.drawAll()
  Map.drawShadow()
  Stylus.drawBackground()
  Land.draw()
  Explosions.draw()
  
  
  love.graphics.origin() -- reset all shakes
  Camera.draw()
  
  Stylus.draw()
  
  --Camera.drawOOB()
  
  
  love.graphics.origin() -- reset to screen drawing (UI)
  
  love.graphics.setColor(0,0,0)
  love.graphics.print(love.timer.getFPS(), 0, 0)
  
  Stylus.drawUI() -- should be last
end
