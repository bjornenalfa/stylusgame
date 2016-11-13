PickupWeapon = {}
PickupWeapon.__index = PickupWeapon
setmetatable(PickupWeapon, Pickup)

function PickupWeapon.new(x, y, weapon_id)
  weapon_id = weapon_id or math.random(0, 2)
  local weapon
  local image
  if weapon_id == 0 then
    weapon = Rocket.new()
    image = getImage("weapons/bazooka_pickup")
  elseif weapon_id == 1 then
    weapon = Laser.new()
    image = getImage("weapons/laser_gun_pickup")
  elseif weapon_id == 2 then
    weapon = MachineGun.new()
    image = getImage("weapons/machine_gun_pickup")
  end
  local imgW = image:getWidth()
  local imgH = image:getHeight()
  local new = Pickup.new(x - imgW / 2, y - imgH / 2, image, 1 / 2)
  new["weapon"] = weapon
  setmetatable(new, PickupWeapon)
  return new
end

function PickupWeapon:pickup(player)
  Pickup.pickup(self)
  self.weapon.player = player
  player.weapon = self.weapon
end
