require "Font"
require "Floattext"
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
require "Kingdab"
require "Weapon"
require "Rocket"
require "Screenshake"
require "Laser"
require "MachineGun"
require "Pickup"
require "PickupWeapon"
require "PickupStylus"
require "Game"
require "Scoredisplay"
require "Blood"

function love.load()
  math.randomseed(os.time())
  love.graphics.setDefaultFilter("linear", "nearest", 2)
  love.graphics.setBackgroundColor(255,255,255)
  Sound.play("menu1")
  --love.mouse.setVisible(false)
  love.mouse.setCursor(love.mouse.newCursor(getImage("mouse"):getData(), 10, 10))
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "o" then
    local _ = Kingdab.new(Map.width / 2, Map.height / 2)
    local x, y, width, height = Camera.getBounds()
    Floattext.new("Boss battle!", x+width/2, y+height/2, {255,255,255}, Font.base)
    Screenshake.new(1, 5)
  elseif key == "space" and not Game.running then
    Game.start("map02")
    Sound.play("battle1")
  end
end

function love.mousepressed(x, y, button)
  Stylus.mousepressed(x,y, button)
end

function love.mousereleased(x, y, button)
  Stylus.mousereleased(x, y, button)
end

time = 0
function love.update(dt)
  time = time + dt
  if(Game.running) then
    Game.update(dt)
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
    Floattext.update(dt)
  elseif Game.over then
    -- do nothing
  end
end


function love.draw()
  if Game.running then
    Camera.draw()
    Explosions.drawShake()
    Screenshake.draw()
    Map.draw()
    Blood.draw()
    Map.drawShadow()
    Pickup.drawAll()
    Stylus.drawBackground()
    Land.draw()
    Projectile.drawAll()
    Player.drawAll()
    Monster.drawAll()
    Game.drawHealthbars()
    Explosions.draw()


    love.graphics.origin() -- reset all shakes
    Camera.draw()
    
    Stylus.draw()
    Floattext.draw()
    --Camera.drawOOB()
    

    love.graphics.origin() -- reset to screen drawing (UI)
    
    love.graphics.setColor(0,0,0)
    love.graphics.print(love.timer.getFPS(), 0, 0)
    
    ScoreDisplay.update() -- ignorera funktionsnamnet, den bara ritar
    Stylus.drawUI() -- should be last
  elseif Game.over then
    Game.drawOver()
  else
    Game.drawNotRunning()
  end
end
