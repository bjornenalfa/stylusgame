Input = {}

Input.MOVE_X = {keyboard={}, gamepad={}, axisIf={{"leftx", function(i) return math.abs(i) > 0.2 end}}}
Input.MOVE_Y = {keyboard={}, gamepad={}, axisIf={{"lefty", function(i) return math.abs(i) > 0.2 end}}}
Input.AIM_X = {keyboard={}, gamepad={}, axisIf={{"rightx", function(i) return math.abs(i) > 0.2 end}}}
Input.AIM_Y = {keyboard={}, gamepad={}, axisIf={{"righty", function(i) return math.abs(i) > 0.2 end}}}
Input.FIRE = {keyboard={}, gamepad={}, axisIf={{"triggerright", function(i) return i >= 0.1 end}}}

-- Returns whether the keyboard or the current player's gamepad has a specific input
function Input.hasInput(inputs, player)
  inputs = inputs or {}
  local stick = player.joystick
  if stick then
    inputs["gamepad"] = inputs["gamepad"] or {}
    inputs["axisIf"] = inputs["axisIf"] or {}
    for _, gpInput in pairs(inputs["gamepad"]) do
      if type(gpInput) == "string" and stick:isGamepadDown(gpInput) then return true, 1 end
    end
    for _, axInput in pairs(inputs["axisIf"]) do
      local val = stick:getGamepadAxis(axInput[1])
      if axInput[2](val) then return true, val end
    end
  else
    inputs["keyboard"] = inputs["keyboard"] or {}
    for _,kbInput in pairs(inputs["keyboard"]) do
      if type(kbInput) == "string" and love.keyboard.isDown(kbInput) then return true, 1 end
    end
  end
  return false
end