Stylus = {}
local s = Stylus

s.maxInk = 50000
s.currentInk = s.maxInk
s.ranOut = false

s.cont = false
s.contTimer = 0
s.lastx = 0
s.lasty = 0

function s.newMap()
  for i = 1,3 do
    s["canvas"..i] = love.graphics.newCanvas(Map.width, Map.height)
  end
end

function s.mousereleased(x, y, button)
  if s.ranOut and button == 1 then
    s.ranOut = false
  end
end

function s.update(dt)
  s.currentInk = math.min(s.currentInk + dt * 5, s.maxInk)
  if love.mouse.isDown(1) and not s.ranOut then
    local x, y = Camera.windowToWorld(love.mouse.getPosition())
    if not s.cont then
      s.cont = true
      s.lastx = x
      s.lasty = y
    else
      local diff = math.max(5, math.sqrt((s.lastx-x)*(s.lastx-x)+(s.lasty-y)*(s.lasty-y)))
      if diff > s.currentInk then
        s.cont = false
        s.ranOut = true
        return
      end
      s.drawn = true
      s.currentInk = s.currentInk - diff
      Land.drawBreakable(function ()
        love.graphics.setColor(140,140,140)
        love.graphics.setLineWidth(10)
        love.graphics.circle("fill", s.lastx, s.lasty, 5)
        love.graphics.line(s.lastx, s.lasty, x, y)
        love.graphics.circle("fill", x, y, 5)
        love.graphics.setLineWidth(1)
      end)
      s.backStroke(s.lastx, s.lasty, x, y)
      s.lastx = x
      s.lasty = y
    end
    
  else
    if s.cont then
      s.contTimer = s.contTimer + dt
      if s.contTimer > 0.1 then
        s.cont = false
        s.contTimer = 0
      end
    end
  end
  
  if love.mouse.isDown(2) then
    local x, y = Camera.windowToWorld(love.mouse.getPosition())
    Land.makeHole(x, y, 15)
  end
end

function s.makeHole(x, y, r)
  local function draw(i, r)
    s["canvas"..i]:renderTo(function ()
      love.graphics.circle("fill",x,y,r)
    end)
  end
  draw(1, r-3)
  draw(2, r-2)
  draw(3, r-1)
  --draw(4, r+1)
end

function s.backStroke(x, y, x2, y2)
  local function draw(i, r)
    s["canvas"..i]:renderTo(function ()
      love.graphics.circle("fill", x, y, r/2)
      love.graphics.setLineWidth(r)
      love.graphics.line(x, y, x2, y2)
      love.graphics.circle("fill", x2, y2, r/2)
    end)
  end
  love.graphics.setColor(0,0,0)
  draw(1,16)
  love.graphics.setColor(83,83,83)
  draw(2,14)
  love.graphics.setColor(104,104,104)
  draw(3,12)
  --love.graphics.setColor(140,140,140)
  --draw(4,10)
  love.graphics.setLineWidth(1)
end

function s.drawBackground()
  love.graphics.setColor(255,255,255)
  for i = 1,3 do
    love.graphics.draw(s["canvas"..i])
  end
end

function s.drawUI()
  love.graphics.setColor(128,128,128)
  love.graphics.rectangle("line", love.graphics.getWidth()-5, 40, -20, 102)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("fill", love.graphics.getWidth()-6, 41+100, -18, -100*(s.currentInk/s.maxInk)) 
  
  --love.graphics.setColor(0,0,255)
  --love.graphics.circle("fill",love.mouse.getX(), love.mouse.getY(), 1)
  --love.graphics.circle("line",love.mouse.getX(), love.mouse.getY(), 4)
end
