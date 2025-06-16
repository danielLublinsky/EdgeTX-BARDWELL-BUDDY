-- soundFactory.lua
-- Create the factory table
local SoundFactory = {}

local rollSounds = {"Crshdt.wav", "NicOne.wav", "SmthOp.wav"}

local flipSounds = {"Epic.wav", "hlyeah.wav", "NaldIt.wav", "Incrd.wav"}

local soundPath = "/SOUNDS/en/BARDWELL-BUDDY/"

local function getRandomSound(list)
    return soundPath .. list[math.random(1, #list)]
end

function SoundFactory.getSoundForEvent(event)
    if event == "roll" then
        return getRandomSound(rollSounds)
    elseif event == "flip" then
        return getRandomSound(flipSounds)
    else
        return nil
    end
end

return SoundFactory
