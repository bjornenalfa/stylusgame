Map = {}
local m = Map

m.width = 2048
m.height = 2048
m.image = nil

function Map.load(imageName)
  local image = Image[imageName]
  m.image = image
  m.width = image:getWidth()
  m.height = image:getHeight()
end

function Map.draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(m.image, 0, 0)
end
