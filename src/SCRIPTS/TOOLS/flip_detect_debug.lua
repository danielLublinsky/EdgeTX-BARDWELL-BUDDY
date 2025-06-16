-- flip_detect_debug.lua
local SoundFactory = assert(loadScript("/SCRIPTS/TOOLS/BARDWELL-BUDDY/SoundFactory.lua"))()

local prevRoll, prevPitch = 0, 0
local accRoll, accPitch = 0, 0
local lastResetTime = 0
local lastMovementTime = 0
local resetInterval = 100000
local movementThreshold = math.rad(5)
local requiredRoll = math.rad(300)
local requiredPitch = math.rad(100)

local function run(event)
    local nowMs = getTime() * 1000

    -- read current angles
    local curRoll = getValue("Roll") or prevRoll
    local curPitch = getValue("Ptch") or prevPitch

    -- delta with wrap correction
    local dRoll = curRoll - prevRoll
    if dRoll > math.pi then
        dRoll = dRoll - 2 * math.pi
    elseif dRoll < -math.pi then
        dRoll = dRoll + 2 * math.pi
    end

    local dPitch = curPitch - prevPitch
    if dPitch > math.pi then
        dPitch = dPitch - 2 * math.pi
    elseif dPitch < -math.pi then
        dPitch = dPitch + 2 * math.pi
    end

    accRoll = accRoll + dRoll
    accPitch = accPitch + dPitch

    if math.abs(dRoll) > movementThreshold or math.abs(dPitch) > movementThreshold then
        lastMovementTime = nowMs
    end

    if nowMs - lastMovementTime >= resetInterval then
        accRoll, accPitch = 0, 0
        lastResetTime = nowMs
        lastMovementTime = nowMs
        lcd.drawText(1, 1, ">>> Reset <<<", INVERS + BLINK)
    end

    local flipDetected = (math.abs(accPitch) >= requiredPitch)
    local rollDetected = (math.abs(accRoll) >= requiredRoll)

    lcd.clear()
    lcd.drawText(1, 5, string.format("AccP:  %.2f rad", accPitch))
    lcd.drawText(1, 15, string.format("AccR:  %.2f rad", accRoll))
    lcd.drawText(1, 50, string.format("Timer: %d ms", nowMs - lastResetTime))

    if flipDetected or rollDetected then
        lastResetTime = nowMs
        lastMovementTime = nowMs
        accRoll, accPitch = 0, 0

        local eventType
        if rollDetected then
            lcd.drawText(1, 1, ">>> Roll Detected <<<", INVERS + BLINK)
            eventType = "roll"
        else
            lcd.drawText(1, 1, ">>> Flip Detected <<<", INVERS + BLINK)
            eventType = "flip"
        end

        local soundFile = SoundFactory.getSoundForEvent(eventType)
        playFile(soundFile)
    end

    prevRoll, prevPitch = curRoll, curPitch
    return 0
end

return {
    run = run
}
