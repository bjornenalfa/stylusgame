Player = {}
Player.__index = Player

Player.list = {}

local COLLISION_POINTS_AMOUNTS = 10
local COLLISION_POINTS_OFFSETS = {}
local PLAYER_RADIUS = 6

for v = 0, math.pi*2, math.pi*2 /  COLLISION_POINTS_AMOUNTS do
  table.insert(COLLISION_POINTS_OFFSETS, {x = math.cos(v) * PLAYER_RADIUS,
                                          y = math.sin(v) * PLAYER_RADIUS})
end

function Player.new(name, x, y, color, joystick)
  if love.joystick.getJoystickCount() > 0 then
    joysticks = love.joystick.getJoysticks()
    joystick = joysticks[math.min(#joysticks,joystick)]
  else
    joystick = nil
  end
  new = {
    name=name,
    joystick=joystick,
    x=x,
    y=y,
    vx=0,
    vy=0,
    size=PLAYER_RADIUS*1.25,
    color=color,
    velocity=120,
    orientation=0,
    maxhp = 100,
    hp = 100,
    movementImpair = false, --only specific to the machinegun weapon, to hinder movement

    --weapon=Laser.new()
    weapon=MachineGun.new()

  }
  new["weapon"].player = new
  setmetatable(new, Player)
  Player.list[name] = new
  return new
end

function Player.getClosest(object)
  local nearest = Player[1]
  local dist = 10000000
  for _,v in pairs(Player.list) do
    local d = (v.x-object.x)*(v.x-object.x)+(v.y-object.y)*(v.y-object.y)
    if d < dist then
      dist = d
      nearest = v
    end
  end
  if nearest then
    return nearest, math.sqrt(dist)
  else
    return {x=0, y=0, size=1}, 1000
  end
end 

function Player.pointInPlayer(x, y)
  for _,v in pairs(Player.list) do
    if (v.x-x)*(v.x-x)+(v.y-y)*(v.y-y) < v.size*v.size then
      return v
    end
  end
  return false
end

function Player.updateAll(dt)
  for _,p in pairs(Player.list) do
    p:update(dt)
  end
end

function Player:update(dt)
  if not self.movementImpair then
    local _, dx = Input.hasInput(Input.MOVE_X, self)
    dx = dx or 0
    local _, dy = Input.hasInput(Input.MOVE_Y, self)
    dy = dy or 0
    if dx*dx + dy*dy >= Input.MOVEMENT_SENSITIVITY * Input.MOVEMENT_SENSITIVITY then
      self.vx = dx * self.velocity * dt
      self.vy = dy * self.velocity * dt
    else 
      self.vx = 0
      self.vy = 0
    end
  else
    --we should not move
    self.vx = 0
    self.vy = 0
  end

  local _, magX = Input.hasInput(Input.AIM_X, self)
  magX = magX or 0
  local _, magY = Input.hasInput(Input.AIM_Y, self)
  magY = magY or 0
  local aimSensitivity = 0.2
  if magX*magX + magY*magY >= Input.AIM_SENSITIVITY * Input.AIM_SENSITIVITY then
    magX = magX or 0
    magY = magY or 0
    self.orientation = math.atan2(magY, magX)
  end
  
  local vdir = math.atan2(self.vy, self.vx)
  local vdist = math.sqrt(self.vx*self.vx + self.vy*self.vy)
  
  for i = 0, math.pi/2-math.pi/16, math.pi/16 do
    local vdist = math.cos(i)*vdist
    self.vx = math.cos(vdir+i) * vdist
    self.vy = math.sin(vdir+i) * vdist
    
    local x = self.x + self.vx
    local y = self.y + self.vy
    local isBlocked = false
    
    for k,v in pairs(COLLISION_POINTS_OFFSETS) do
      local x2, y2 = x + v.x, y + v.y
      if Land.isBlocked(x2, y2, true) or Monster.pointInMonster(x2, y2) then
        isBlocked = true
        break
      end
    end
    
    if not isBlocked then
      self.x = self.x + self.vx
      self.y = self.y + self.vy
      break
    end
    
    self.vx = math.cos(vdir-i) * vdist
    self.vy = math.sin(vdir-i) * vdist
    
    local x = self.x + self.vx
    local y = self.y + self.vy
    local isBlocked = false
    
    for k,v in pairs(COLLISION_POINTS_OFFSETS) do
      local x2, y2 = x + v.x, y + v.y
      if Land.isBlocked(x2, y2, true) or Monster.pointInMonster(x2, y2) then
        isBlocked = true
        break
      end
    end
    
    if not isBlocked then
      self.x = self.x + self.vx
      self.y = self.y + self.vy
      break
    end
  end
  
  self.weapon:update(dt)
  if Input.hasInput(Input.FIRE, self) then
    self.weapon:fire(self.x, self.y, self.orientation)
  elseif Input.hasInput(Input.ALT_FIRE, self) then
    if self.weapon.altFire then self.weapon:altFire(self.x, self.y, self.orientation) end
  end
end

function Player:damage(damage)
  self.hp = self.hp - damage
  if self.hp < 0 then
    Game.stop()
  end
end

function Player.drawAll()
  local prevR, prevG, prevB, prevA = love.graphics.getColor()
  for _,p in pairs(Player.list) do
    love.graphics.setColor(255,255,255,255)
    p.weapon:draw(p)
    love.graphics.draw(Image.hero, p.x, p.y, p.orientation, 2*p.size/Image.hero:getWidth(), 2*p.size/Image.hero:getHeight(), Image.hero:getWidth()*0.5, Image.hero:getHeight()*0.5)
    love.graphics.setColor(0, 0, 0)
    --love.graphics.line(p.x, p.y, p.x + math.cos(p.orientation)*p.size, p.y + math.sin(p.orientation)*p.size)
    --[[ove.graphics.setColor(255,0,0)
    for k,v in pairs(COLLISION_POINTS_OFFSETS) do
      love.graphics.points(p.x+v.x, p.y+v.y)
    end]]
  end
  love.graphics.setColor(prevR, prevG, prevB, prevA)
end