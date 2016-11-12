Stylus = {}
local s = Stylus

s.maxInk = 500
s.currentInk = s.maxInk
s.ranOut = false

s.cont = false
s.contTimer = 0
s.lastx = 0
s.lasty = 0

s.drawn = false

function s.mousereleased(x, y, button)
  if s.ranOut and button == 1 then
    s.ranOut = false
  end
end

function s.update(dt)
  s.currentInk = math.min(s.currentInk + dt * 5, s.maxInk)
  if love.mouse.isDown(1) and not s.ranOut then
    local x = love.mouse.getX()
    local y = love.mouse.getY()
    if not s.cont then
      s.cont = true
      s.lastx = x
      s.lasty = y
    else
      local diff = math.sqrt((s.lastx-x)*(s.lastx-x)+(s.lasty-y)*(s.lasty-y))
      if diff > s.currentInk then
        s.cont = false
        s.ranOut = true
        return
      end
      s.drawn = true
      s.currentInk = s.currentInk - math.sqrt((s.lastx-x)*(s.lastx-x)+(s.lasty-y)*(s.lasty-y))
      Land.drawBreakable(function ()
        love.graphics.setColor(0,0,0)
        love.graphics.setLineWidth(5)
        love.graphics.line(s.lastx, s.lasty, x, y)
        love.graphics.setLineWidth(1)
      end)
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
end

function s.drawUI()
  love.graphics.setColor(128,128,128)
  love.graphics.rectangle("line", love.graphics.getWidth()-5, 40, -20, 102)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("fill", love.graphics.getWidth()-6, 41+100, -18, -100*(s.currentInk/s.maxInk)) 
  
  love.graphics.setColor(0,0,255)
  love.graphics.circle("fill",love.mouse.getX(), love.mouse.getY(), 1)
  love.graphics.circle("line",love.mouse.getX(), love.mouse.getY(), 4)
end
