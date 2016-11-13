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
s.battle1:setVolume(1)
s["battle1"]:setLooping(true)
s.addSound("battle2", ".ogg")
s.battle2:setVolume(0.8)
s.addSound("battle3", ".ogg")
s.battle3:setVolume(1)
s.addSound("battle4", ".ogg")
s.battle4:setVolume(1)
s.addSound("battle_nomercy1", ".ogg")
s.battle_nomercy1:setVolume(1)
s.addSound("battle_nomercy2", ".ogg")
s.battle_nomercy2:setVolume(1)

s.addSound("menu1", ".mp3")
s["menu1"]:setLooping(true)
s.menu1:setVolume(1)

s.addSound("gameover", ".ogg")
s["gameover"]:setLooping(true)
s.menu1:setVolume(1)


s.addStaticSound("missile_shoot", ".wav")
s.addStaticSound("quack", ".mp3")
s.addStaticSound("laser4", ".ogg")
s.addStaticSound("laser3", ".ogg")
s.addStaticSound("laser2", ".ogg")
s.addStaticSound("laser1", ".wav")
s.addStaticSound("planet_explode", ".wav")
s.addStaticSound("quack", ".mp3")
s.addStaticSound("wing", ".wav")

s.addStaticSound("mine_activate", ".wav")
s.addStaticSound("missile_shoot", ".wav")

s.addStaticSound("grenade_throw", ".wav")
s.addStaticSound("grenade_arm", ".wav")

s.addStaticSound("hit4", ".wav")
s.addStaticSound("hit3", ".wav")

for i = 1,3 do
  s.addStaticSound("explosion"..i, ".wav")
end