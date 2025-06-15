-- soundFactory.lua

local SoundFactory = {}

local rollSound = function()
    return "roll.wav"
end

local flipSound = function()
    return "flip.wav"
end

local defultSound = function()
    return "default.wav"
end

soundFactory.getSoundForEvent = function(event)
    local sound = nil

    if event == "roll" then
        sound = rollSound()
    elseif event == "flip" then
        sound = flipSound()
    else
        sound = defultSound()
    end

    return sound
end


return soundFactory