require "player"

log = ""

canvas = love.graphics.newCanvas(1000,1000)
lastx = nil
lasty = nil

function love.load()
  love.graphics.setBackgroundColor(255,255,255)
  
  Player.new("p1", 0, 0, nil)
end


function love.keypressed(key)
  log = log.." "..key
end

function love.mousepressed(x, y, button)
  
end

function love.update(dt)
  if love.mouse.isDown(1) then
    canvas:renderTo(function ()
        love.graphics.setColor(0,0,0)
        love.graphics.setLineWidth(5)
        if lastx == nil then
          lastx = love.mouse.getX()
          lasty = love.mouse.getY()
        end
        love.graphics.line(lastx, lasty, love.mouse.getX(), love.mouse.getY())
        lastx = love.mouse.getX()
        lasty = love.mouse.getY()
    end)
  end

end


function love.draw()
  love.graphics.setColor(0,0,0)
  love.graphics.print(log, 0, 0)
  if love.mouse.isDown(1) then
    love.graphics.print("mouse1 down", 0, 20)
  end
  if love.mouse.isDown(2) then
    love.graphics.print("mouse2 down", 0, 40)
  end
  if love.mouse.isDown(3) then
    love.graphics.print("mouse3 down", 0, 60)
  end
  for i = 4, 20 do
    if love.mouse.isDown(i) then
      love.graphics.print("mouse"..i.." down", 0, 80)
    end
  end
  love.graphics.setColor(255,255,255)
  love.graphics.draw(canvas)
end
