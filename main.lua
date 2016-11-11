
log = ""

canvas = love.graphics.newCanvas()

function love.load()
  love.graphics.setBackgroundColor(255,255,255)
end


function love.keypressed(key)
  log = log.." "..key
end

function love.mousepressed(x, y, button)
  if button == "l" then
    canvas:renderTo(function ()
        love.graphics.setcolor(0,0,0)
        love.graphics.circle("fill", x, y, 5)
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
