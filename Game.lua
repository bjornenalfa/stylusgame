Game = {}
Game.__index = Game

Game.running = false
Game.over = false
Game.timer = 0

function Game.start(map)
  love.audio.stop(Sound["menu1"])
  love.audio.stop(Sound["gameover"])
  Sound.play("battle1")
  Map.load(map)
  Land.newMap()
  Stylus.newMap()
  Blood.newMap()
  
  Projectile.list = {}
  Pickup.list = {}
  Explosions.explosions = {}
  Screenshake.list = {}
  Floattext.list = {}
  Player.list = {}
  Monster.list = {}
  Game.timer = 0
  local x, y
  if map == "map01" then
    x = 200
    y = 100
  elseif map == "map02" then
    x = 300
    y = 300
  end
  local pl = Player.new("p1", x, y, {255, 0, 0}, 1)
  --Camera.trackEntity(pl)
  --[[
  local mon = Zombieduck.new(150, 150)
  local mon2 = Duckcrab.new(150, 200)
  local mon3 = Crabduck.new(400, 200)
  local mon4 = Crabduck.new(200, 500)
  local mon5 = Crabcannon.new(400, 400)
  --]]
  Game.spawn(2, 1)
  Game.spawn(2, 2)
  Game.spawn(2, 3)
  Game.spawn(1, 4)
  for i = 1, 20 do
    Game.pickupSpawn()
  end
  Game.running = true
end

function Game.pickupSpawn()
  local x = math.random(0, Map.width)
  local y = math.random(0, Map.height)
  if math.random(0, 1) == 1 then
    PickupWeapon.new(x, y)
  else
    PickupStylus.new(x, y)
  end
end

-- spawns a random amount of random type (not boss) if you do not specify the second parameter
-- 1 = zombiduck, 2 = crabduck, 3 = crabcannon, 4 = duckcrab (boss)
function Game.spawn(amount, forceSpawn)
  local monType
  local x, y
  local side
  for i = 0, amount, 1 do
    if forceSpawn then
      monType = forceSpawn
    else
      monType = math.random(1, 3)
    end
    -- 1=east, 2=west, 3=south, 4=north
    side = math.random(1, 4)
    if side == 1 then
      x = Map.width + 50
      y = math.random(0, Map.height)
    elseif side == 2 then
      x = -50
      y = math.random(0, Map.height)
    elseif side == 3 then
      y = Map.height + 50
      x = math.random(0, Map.width)
    else
      y = -50
      x = math.random(0, Map.width)
    end
    if monType == 1 then
      Zombieduck.new(x, y)
    elseif monType == 2 then
      Crabduck.new(x, y)
    elseif monType == 3 then
      Crabcannon.new(x, y)
    elseif monType == 4 then
      Duckcrab.new(x, y)
    end
  end
end
      

function Game.update(dt)
  if Game.over then
    Game.timer = Game.timer + dt
    if Game.timer > 60 then
      game.over = false
      time = 0
      love.audio.stop(Sound["gameover"])
      Sound.play("menu1")
    end
  else
    Game.timer = Game.timer + dt
    if Game.timer > 2  and #Monster.list < 30 then
      if math.random(1, 10) == 1 then
        Game.spawn(1, 4) -- duckcrab
      end
      if math.random(1, 15) == 1 then
        Game.pickupSpawn()
      end
      Game.spawn(1)
      Game.timer = 0
    end
  end
end

function Game.reset()
  Game.stop()
  Game.start()
end

function Game.stop()
  Game.over = true
  Game.running = false
  love.audio.stop(Sound["battle1"])
  Sound.play("gameover")
  Game.timer = 0
end

function Game.drawOver()
  love.graphics.setColor(255,255,255)
  local img = getImage("menu_game_over")
  love.graphics.draw(img, 0, 0, 0, love.graphics.getWidth() / img:getWidth(), love.graphics.getHeight() / img:getHeight())
end

function Game.drawNotRunning()
  love.graphics.setColor(255,255,255)
  local img = getImage("menu_start")
  love.graphics.draw(img, 0, 0, 0, love.graphics.getWidth() / img:getWidth(), love.graphics.getHeight() / img:getHeight())
  if time > 120 then
    local text = "Press space to start"
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight() - 4 * 20 * 8
    local font = Font.h1
    love.graphics.setColor(0,0,0)
    love.graphics.setFont(font)
    for i = 1, 20 do
      if i == 15 then
        local blink = math.max(0, 0.3+math.sin(time*0.3))
        love.graphics.setColor(255-70*blink,255-70*blink,120*blink, 255*(i/20))
      else
        love.graphics.setColor(255,255,0, 255*(i/20))
      end
      for s = 1, #text do
        local text2 = string.sub(text, s, -1)
        local text3 = string.sub(text2, 1, 1)
        love.graphics.print(text3,width*0.75-font:getWidth(text2) + math.sin(time*2+i*math.pi*0.1)*10, height/2 + i*20 + math.sin(3*time+s+s*i) * 20)
      end
    end
    
    love.graphics.setFont(Font.normal)
  end
end

function Game.drawHealthbars()
  for _,v in pairs(Monster.list) do
    Game.drawHealthbar(v)
  end
  
  for _,v in pairs(Player.list) do
    Game.drawHealthbar(v)
  end
end

function Game.drawHealthbar(object)
  if not (object.hp == object.maxhp) then
    local imageE = getImage("hp_empty")
    local imageF = getImage("hp_filled")
    local x = object.x-- - imageE:getWidth / 2
    local y = object.y - 20-- imageE:getHeight / 2
    
    love.graphics.draw(imageE, x, y, 0, 0.5, 0.5, imageE:getWidth() / 2, imageE:getHeight() / 2)
    if (object.hp / object.maxhp) > 0 then
      love.graphics.draw(imageF, x, y, 0, 0.5*(object.hp / object.maxhp), 0.5, imageF:getWidth() / 2, imageF:getHeight() / 2)
    end
  end
end

