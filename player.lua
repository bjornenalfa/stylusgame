Player = {}

Player.list = {}

function Player.new(name, x, y, color)
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
    color=color
  }
  setmetatable(new, Player)
  Player.list[name] = new
  return new
end

function Player.updateAll(dt)
  for _,p in pairs(Player) do
    p:update(dt)
  end
end

function Player:update(dt)
  chkx, dx = Input.hasInput(Input.MOVE_X, self)
  if chkx then self.vx = dx else self.vx = 0 end
  chky, dy = Input.hasInput(Input.MOVE_Y, self)
  if chky then self.vy = dy else self.vy = 0 end
end

function Player:draw()
  love.graphics.circle("fill", self.x, self.y, self.size)
end