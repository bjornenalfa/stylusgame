Stylus = {}
local s = Stylus

s.maxInk = 1000
s.currentInk = s.maxInk
s.ranOut = false

s.cont = false
s.contTimer = 0
s.lastx = 0
s.lasty = 0

s.mode = "acid"

s.slashing = false
s.slashlist = {}
s.slashPoints = 4
s.combo = 0
s.comboTimer = 0
s.slashTime = 0

function s.newMap()
  for i = 1,3 do
    s["canvas"..i] = love.graphics.newCanvas(Map.width, Map.height)
  end
end

function s.startSlash(time)
  s.slashing = true
  s.slashlist = {}
  s.combo = 0
  s.comboTimer = 0
  s.slashTime = time
  local x, y, width, height = Camera.getBounds()
  Floattext.new("Time to slash!", x+width/2, y+height/2, {255,255,255}, Font.base)
  love.mouse.setCursor(love.mouse.newCursor(getImage("mouse_death"):getData(), 10, 10))
end

function s.endSlash()
  s.slashing = false
  love.mouse.setCursor(love.mouse.newCursor(getImage("mouse"):getData(), 10, 10))
end

function s.mousereleased(x, y, button)
  if s.ranOut and button == 1 then
    s.ranOut = false
  end
end

function s.mousepressed(x, y, button)
  if button == 2 then
    if s.mode == "wall" then
      s.mode = "acid"
    elseif s.mode == "acid" then
      s.mode = "wall"
    end
  end
end

function s.update(dt)
  s.currentInk = math.min(s.currentInk + dt * 40, s.maxInk)
  local x, y = Camera.windowToWorld(love.mouse.getPosition())
  if s.slashing then
    s.slashTime = s.slashTime - dt
    if s.slashTime < 0 then
      return s.endSlash()
    end
    s.comboTimer = s.comboTimer + dt
    if s.comboTimer > 0.4 then
      if s.combo > 0 then
        Floattext.new("+"..s.combo, x, y)
      end
      s.combo = 0
    end
    if love.mouse.isDown(1) then return end
    
    table.insert(s.slashlist, {x=x, y=y})
    if #s.slashlist > s.slashPoints then
      table.remove(s.slashlist, 1)
    end
    hits = {[1]=Monster.pointInMonster(s.slashlist[1].x, s.slashlist[1].y)}
    good = {}
    for i = 2, #s.slashlist do
      hits[i] = Monster.pointInMonster(s.slashlist[i].x, s.slashlist[i].y)
      if hits[i] ~= hits[i-1] then
        table.insert(good, hits[i])
      end
    end
    for i = 1, #good-1 do
      if good[i] then
        good[i]:damage(3+math.sqrt(s.combo))
        Sound.play("hit4")
        s.combo = s.combo + 1
        s.comboTimer = 0
      end
    end
  else
    if love.mouse.isDown(1) then
      if love.mouse.isDown(2) then
        Land.makeHole(x, y, 15)
        return
      end
      if s.ranOut then return end
      if Player.pointInPlayer(x, y) or Monster.pointInMonster(x, y) then
        s.cont = false
        return 
      end
      if not s.cont then
        s.cont = true
        s.lastx = x
        s.lasty = y
      else
        local diff = math.max(5, math.sqrt((s.lastx-x)*(s.lastx-x)+(s.lasty-y)*(s.lasty-y)))
        if s.mode == "acid" then
          diff = diff * 5
        end
        if diff > s.currentInk then
          s.cont = false
          s.ranOut = true
          return
        end
        s.drawn = true
        s.currentInk = s.currentInk - diff
        Land.drawBreakable(function ()
            if s.mode == "wall" then
              love.graphics.setColor(140,140,140)
              love.graphics.setLineWidth(10)
              love.graphics.circle("fill", s.lastx, s.lasty, 5)
              love.graphics.line(s.lastx, s.lasty, x, y)
              love.graphics.circle("fill", x, y, 5)
            elseif s.mode == "acid" then
              love.graphics.setBlendMode("replace")
              
              love.graphics.setColor(51,244,13, 254)
              love.graphics.setLineWidth(20)
              love.graphics.circle("fill", s.lastx, s.lasty, 10)
              --love.graphics.line(s.lastx, s.lasty, x, y)
              love.graphics.circle("fill", x, y, 10)
              
              love.graphics.setBlendMode("alpha")
            end
          
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
      if s.mode == "wall" then
        love.graphics.line(x, y, x2, y2)
      end
      love.graphics.circle("fill", x2, y2, r/2)
    end)
  end
  if s.mode == "wall" then
    love.graphics.setColor(0,0,0)
    draw(1,16)
    love.graphics.setColor(83,83,83)
    draw(2,14)
    love.graphics.setColor(104,104,104)
    draw(3,12)
  elseif s.mode == "acid" then
    love.graphics.setColor(52,150,32)
    draw(1,35)
    love.graphics.setColor(53,211,22)
    draw(2,28)
    love.graphics.setColor(54,222,21)
    draw(3,24)
  end
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

function s.draw()
  if s.slashing then
    local points = {}
    for _,v in pairs(s.slashlist) do
      table.insert(points, v.x)
      table.insert(points, v.y)
    end
    love.graphics.setLineWidth(4)
    love.graphics.setColor(255,0,0, 128)
    if #points > 3 then
      love.graphics.line(points)
    end
    love.graphics.setLineWidth(1)
  end
end

function s.drawUI()
  local width = love.graphics.getWidth()
  --love.graphics.draw(getImage("stylebar_empty"), width-40, 40)
  
  if s.mode == "wall" then
    love.graphics.setColor(100,100,100)
    love.graphics.draw(getImage("stylebar_ink"), width-40, 140, 0, 1, -(s.currentInk/s.maxInk))
  elseif s.mode == "acid" then
    love.graphics.setColor(255,255,255)
    love.graphics.draw(getImage("stylebar_acid"), width-40, 140, 0, 1, -(s.currentInk/s.maxInk))
  end
  love.graphics.setColor(255,255,255)
  love.graphics.draw(getImage("stylebar_empty"), width-40, 40)
  --love.graphics.setColor(128,128,128)
  --love.graphics.rectangle("line", love.graphics.getWidth()-5, 40, -20, 102)
  --love.graphics.setColor(0,0,0)
  --love.graphics.rectangle("fill", love.graphics.getWidth()-6, 41+100, -18, -100*(s.currentInk/s.maxInk)) 
  
  if s.slashing then
    love.graphics.setColor(255,0,0)
    --love.graphics.circle("fill",love.mouse.getX(), love.mouse.getY(), 1)
  end
end
