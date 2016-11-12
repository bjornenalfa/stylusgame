Input = {}

Input.MOVE_X = {keyboard={{"a", -1}, {"d", 1}}, gamepad={}, axisIf={{"leftx", function(i) return true end}}}
Input.MOVE_Y = {keyboard={{"w", -1}, {"s", 1}}, gamepad={}, axisIf={{"lefty", function(i) return true end}}}
Input.AIM_X = {keyboard={{"up", 0}, {"right", 1}, {"down", 0}, {"left", -1}}, gamepad={}, axisIf={{"rightx", function(i) return true end}}}
Input.AIM_Y = {keyboard={{"up", -1}, {"right", 0}, {"down", 1}, {"left", 0}}, gamepad={}, axisIf={{"righty", function(i) return true end}}}
Input.FIRE = {keyboard={{"space", 1}}, gamepad={}, axisIf={{"triggerright", function(i) return i >= 0.1 end}}}
Input.ALT_FIRE = {keyboard={{"f", 1}}, gamepad={}, axisIf={{"triggerleft", function(i) return i >= 0.1 end}}}

Input.MOVEMENT_SENSITIVITY = 0.2
Input.AIM_SENSITIVITY = 0.2

-- Returns whether the keyboard or the current player's gamepad has a specific input
function Input.hasInput(inputs, player)
  player = player or {}
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
      if type(kbInput[1]) == "string" and love.keyboard.isDown(kbInput[1]) then return true, kbInput[2] end
    end
  end
  return false
end