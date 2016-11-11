
log = ""

function love.load()
  love.graphics.setBackgroundColor(255,255,255)
end


function love.keypressed(key)
  log = log.." "..key
end

function love.draw()
  love.graphics.setColor(0,0,0)
  love.graphics.print(log, 0, 0)
  if love.mouse.isDown() then
    love.graphics.print("mouse down")
  end
end
