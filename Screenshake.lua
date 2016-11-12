Screenshake = {}
local s = Screenshake

s.list = {}

function s.new(time, intensity)
  table.insert(s.list, {
      timer = 0,
      time = time,
      shake = intensity})
end

function s.update(dt)
  kill = {}
  for _,v in pairs(s.list) do
    v.timer = v.timer + dt
    if v.timer >= v.time then
      table.insert(kill, _)
    end
  end
  for i = #kill, 1, -1 do
    table.remove(s.list, kill[i])
  end
end

function s.draw()
  for _,v in pairs(s.list) do
    love.graphics.translate(math.random(-v.shake,v.shake), math.random(-v.shake,v.shake))
  end
end