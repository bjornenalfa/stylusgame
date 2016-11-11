Sound = {}
local s = Sound

-- for long sound tracks
function s.addSound(name, ext)
  s[name] = love.audio.newSource("media/audio/"..name..ext)
end

-- for short sound tracks
function s.addStaticSound(name, ext)
  s[name] = love.audio.newSource("media/audio/"..name..ext, "static")
end

function s.play(so)
  if type(so) == "string" then
    so = s[so]
  end
  so:rewind()
  so:play()
end

s.addSound("battle1", ".ogg")
s.battle1:setVolume(0.6)
s.addSound("battle2", ".ogg")
s.battle2:setVolume(0.8)
s.addSound("battle3", ".ogg")
s.battle3:setVolume(1)
s.addSound("theme", ".ogg")
s.theme:setVolume(0.6)
s.theme:setLooping(true)
s.addSound("sandstorm", ".mp3")
s.addSound("menu", ".ogg")
s.menu:setVolume(0.3)


s.addStaticSound("missile_shoot", ".wav")
s.addStaticSound("laser_shoot", ".wav")
s.addStaticSound("planet_explode", ".wav")

s.addStaticSound("mine_activate", ".wav")
s.addStaticSound("mine_alarm", ".wav")

s.addStaticSound("grenade_throw", ".wav")
s.addStaticSound("grenade_arm", ".wav")

for i = 1,3 do
  s.addStaticSound("explosion"..i, ".wav")
end