Floattext = {}
local f = Floattext

f.list = {}

function Floattext.update(dt)
  f.killist = {}
  for _,v in pairs(f.list) do
    v.y = v.y - 30*dt
    v.life = v.life + dt
    if v.life > 3 then
      table.insert(f.killist,_)
    end
  end
  for i = #f.killist,1,-1 do
    table.remove(f.list,f.killist[i])
  end
end

function Floattext.new(text,x,y,color,fon)
  if not color then color = {255,255,255} end
  if not fon then fon = Font.x10 end
  table.insert(f.list,{text=text,x=x,y=y,color=color,font=fon,life=0})
end

function Floattext.draw()
  for _,v in pairs(f.list) do
    love.graphics.setFont(v.font)
    love.graphics.setColor(v.color[1],v.color[2],v.color[3],(1-(v.life/3))*255)
    love.graphics.print(v.text,v.x-v.font:getWidth(v.text)/2,v.y)
  end
  love.graphics.setFont(Font.normal)
end