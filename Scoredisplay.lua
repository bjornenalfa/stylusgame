ScoreDisplay = {}
ScoreDisplay.__index = ScoreDisplay

ScoreDisplay.currentDisplays = {}

function ScoreDisplay.update()
  local x = -100
  for num,pl in pairs(Player.list) do
    local text = num..": "..tostring(pl.score)
    x = 100 + x
    local fontSize = 45
    local y = love.graphics.getHeight() - fontSize
    love.graphics.setFont(love.graphics.newFont(fontSize))
    love.graphics.setColor(255, 0, 0)
    love.graphics.print(text, x, y)
  end
end