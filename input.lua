Input = {}

Input.CAMERA_MOVE_DOWN = {keyboard={"down"}, gamepad={}, axisIf={{"righty", function(i) return i > 0.2 end}}}
Input.CAMERA_MOVE_UP = {keyboard={"up"}, gamepad={}, axisIf={{"righty", function(i) return i < -0.2 end}}}
Input.CAMERA_MOVE_LEFT = {keyboard={"left"}, gamepad={}, axisIf={{"rightx", function(i) return i < -0.2 end}}}
Input.CAMERA_MOVE_RIGHT = {keyboard={"right"}, gamepad={}, axisIf={{"rightx", function(i) return i > 0.2 end}}}
Input.CAMERA_RESET = {keyboard={"r"}, gamepad={"rightstick"}, axisIf={}}
Input.CHARACTER_START_AIM = {keyboard={"space"}, gamepad={"x"}, axisIf={}}
Input.CHARACTER_FIRE = {keyboard={"f"}, gamepad={"x"}, axisIf={}}
Input.CHARACTER_JUMP = {keyboard={"w"}, gamepad={"a"}, axisIf={}}
Input.CHARACTER_STOP_AIM = {keyboard={"space"}, gamepad={"b"}, axisIf={}}
Input.CHARACTER_MOVE_LEFT = {keyboard={"a"}, gamepad={}, axisIf={{"leftx", function(i) return i < -0.2 end}}}
Input.CHARACTER_MOVE_RIGHT = {keyboard={"d"}, gamepad={}, axisIf={{"leftx", function(i) return i > 0.2 end}}}
Input.CHARACTER_AIM_LEFT = {keyboard={"a"}, gamepad={}, axisIf={}}
Input.CHARACTER_AIM_RIGHT = {keyboard={"d"}, gamepad={}, axisIf={}}
Input.CHARACTER_AIM_STRENGTH_UP = {keyboard={"w"}, gamepad={}, axisIf={{"triggerright", function(i) return i > 0 end}}}
Input.CHARACTER_AIM_STRENGTH_DOWN = {keyboard={"s"}, gamepad={}, axisIf={{"triggerleft", function(i) return i > 0 end}}}
Input.END_TURN = {keyboard={"k"}, gamepad={"y"}}
Input.NEXT_WEAPON = {keyboard={"l"}, gamepad={"rightshoulder"}}
Input.PREV_WEAPON = {keyboard={"h"}, gamepad={"leftshoulder"}}

-- Returns whether the keyboard or the current player's gamepad has a specific input
function Input.hasInput(inputs, player)
  if not turn.playerinput then return false end
  player = player or turn.currentPlayer
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