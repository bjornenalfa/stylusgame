Stylus = {}
local s = Stylus

s.canvas = love.graphics.newCanvas(2048, 2048)
Land.landImage = s.canvas:newImageData()

s.cont = false
s.contTimer = 0
s.lastx = 0
s.lasty = 0

s.drawn = false

function s.update(dt)
  if love.mouse.isDown(1) then
    s.canvas:renderTo(function ()
      love.graphics.setColor(0,0,0)
      love.graphics.setLineWidth(5)
      if not s.cont then
        s.cont = true
        s.lastx = love.mouse.getX()
        s.lasty = love.mouse.getY()
      else
        s.drawn = true
      end
      love.graphics.line(s.lastx, s.lasty, love.mouse.getX(), love.mouse.getY())
      s.lastx = love.mouse.getX()
      s.lasty = love.mouse.getY()
    end)
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

function s.draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(s.canvas)
  love.graphics.setColor(0,0,0)
  love.graphics.print(tostring(Land.isBlocked(love.mouse.getX(), love.mouse.getY())), 100, 0)
end
