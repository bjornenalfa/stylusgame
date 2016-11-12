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
    size=30,
    color=color,
    velocity=450,
    orientation=0,
    weapon=Weapon.rocket
  }
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
  
  if not Land.isBlocked(self.x + self.vx * dt, self.y + self.vy * dt) then
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
    love.graphics.draw(Image.hero, p.x, p.y, p.orientation, 1, 1, p.size/2, p.size/2)
    love.graphics.setColor(0, 0, 0)
    love.graphics.line(p.x, p.y, p.x + math.cos(p.orientation)*p.size, p.y + math.sin(p.orientation)*p.size)
  end
  love.graphics.setColor(prevR, prevG, prevB, prevA)
end