Game = {}
Game.__index = Game

Game.running = false
Game.timer = 0

function Game.start(map)
  Map.load(map)
  Land.newMap()
  Stylus.newMap()
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
  PickupWeapon.new(math.random(0, Map.width), math.random(0, Map.height))
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


function Game.drawNotRunning()
  local text = "Press space to start"
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight() - 4 * 20 * 8
  local font = Font.h1
  love.graphics.setColor(0,0,0)
  love.graphics.setFont(font)
  for i = 1, 20 do
    if i == 15 then
      local blink = math.max(0, math.sin(time*0.3))
      love.graphics.setColor(255-25*blink,255-25*blink,120*blink, 255*(i/20))
    else
      love.graphics.setColor(255,255,0, 255*(i/20))
    end
    for s = 1, #text do
      local text2 = string.sub(text, s, -1)
      local text3 = string.sub(text2, 1, 1)
      love.graphics.print(text3,width*0.9-font:getWidth(text2) + math.sin(time*2+i*math.pi*0.1)*10, height/2 + i*20 + math.sin(3*time+s+s*i) * 20)
    end
  end
  
  love.graphics.setFont(Font.normal)
end