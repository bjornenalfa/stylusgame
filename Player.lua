Player = {}
Player.__index = Player

Player.list = {}

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
    size=15,
    color=color,
    velocity=120,
    orientation=0
    weapon=Weapon.rocket
  }
  setmetatable(new, Player)
  Player.list[name] = new
  return new
end

local COLLISION_POINTS_AMOUNTS = 10
local COLLISION_POINTS_OFFSETS = {}
local PLAYER_RADIUS = 12

for v = 0, math.pi*2, math.pi*2 /  COLLISION_POINTS_AMOUNTS do
  table.insert(COLLISION_POINTS_OFFSETS, {x = math.cos(v) * PLAYER_RADIUS,
                                          y = math.sin(v) * PLAYER_RADIUS})

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
  return nearest, dist
end 

function Player.updateAll(dt)
  for _,p in pairs(Player.list) do
    p:update(dt)
  end
end

function Player:update(dt)
  chkx, dx = Input.hasInput(Input.MOVE_X, self)
  if chkx then
    self.vx = dx * self.velocity
  else 
    self.vx = 0
  end
  
  chky, dy = Input.hasInput(Input.MOVE_Y, self)
  if chky then
    self.vy = dy * self.velocity
  else 
    self.vy = 0
  end
  
  aimingX, magX = Input.hasInput(Input.AIM_X, self)
  aimingY, magY = Input.hasInput(Input.AIM_Y, self)
  if aimingX or aimingY then
    magX = magX or 0
    magY = magY or 0
    self.orientation = math.atan2(magY, magX)
  end
  
  local x = self.x + self.vx * dt
  local y = self.y + self.vy * dt
  local isBlocked = false
  
  for k,v in pairs(COLLISION_POINTS_OFFSETS) do
    if Land.isBlocked(x + v.x, y + v.y) then
      isBlocked = true
      break
    end
  end
  
  if not isBlocked then
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
  end
  
  self.weapon:update(dt)
  if Input.hasInput(Input.FIRE, self) then
    self.weapon:fire(self.x, self.y, self.orientation)
    --Projectile.fromTemplate(self.x, self.y, self.orientation, Projectile.templates.bullet)
  end
end

function Player.drawAll()
  local prevR, prevG, prevB, prevA = love.graphics.getColor()
  for _,p in pairs(Player.list) do
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(Image.hero, p.x, p.y, p.orientation, p.size/Image.hero:getWidth(), p.size/Image.hero:getHeight(), p.size, p.size)
    love.graphics.setColor(0, 0, 0)
    love.graphics.line(p.x, p.y, p.x + math.cos(p.orientation)*p.size, p.y + math.sin(p.orientation)*p.size)
  end
  love.graphics.setColor(prevR, prevG, prevB, prevA)
end