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