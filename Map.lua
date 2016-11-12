Map = {}
local m = Map

m.width = 2048
m.height = 2048
m.image = nil
m.shadow = nil
m.solid = nil
m.breakable = nil

function Map.load(imageName)
  local image = getImage("maps/"..imageName.."_base")
  local shadow = getImage("maps/"..imageName.."_shadow")
  local solid = getImage("maps/"..imageName.."_solid")
  local breakable = getImage("maps/"..imageName.."_breakable")
  m.image = image
  m.shadow = shadow
  m.solid = solid
  m.breakable = breakable
  m.width = image:getWidth()
  m.height = image:getHeight()
end

function Map.draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(m.image)
end

function Map.drawShadow()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(m.shadow)
end
