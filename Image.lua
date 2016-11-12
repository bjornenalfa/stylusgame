Image = {}
local i = Image

function addImage(name)
  i[name] =  love.graphics.newImage("media/"..name..".png")
end

function getImage(name)
  if i[name] then
    return i[name]
  else
    addImage(name)
    return i[name]
  end
end

--addImage("debris")

for i = 1,6 do
  addImage("planetexplosion"..i)
end

--[[addImage("hen")
addImage("hen_leg")
addImage("zombie")
addImage("zombie2")
addImage("zombie_leg")
addImage("bazooka_missile")
addImage("uzi")
addImage("grave01")
addImage("egg")
addImage("barrel")
addImage("bazooka")
addImage("arrow")
addImage("grenade")
addImage("grenade_unarmed")
addImage("zombie_fist")
addImage("wall")--]]
addImage("hero")
addImage("map01")