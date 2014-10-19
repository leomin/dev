scriptId = 'com.thalmic.scripts.hearthstone'

function grab()
	myo.mouse("left","down")
end

function select()
	myo.mouse("left","click")
end

-- Helpers

-- Makes use of myo.getArm() to swap wave out and wave in when the armband is being worn on
-- the left arm. This allows us to treat wave out as wave right and wave in as wave
-- left for consistent direction. The function has no effect on other poses.
function conditionallySwapWave(pose)
    if myo.getArm() == "left" then
        if pose == "waveIn" then
            pose = "waveOut"
        elseif pose == "waveOut" then
            pose = "waveIn"
        end
    end
    return pose
end
	
function onPoseEdge(pose, edge)
	    -- Unlock	
    myo.debug("onPoseEdge: " .. pose .. ", " .. edge)

	if edge == "on" then
		--grab/select things in game	
		if pose == "fist" then
				grab()
				extendUnlock()
		end

	end
	if edge == "off" then
		myo.mouse("left","up")
		myo.mouse("right","up")
	end
end
-- Unlock mechanism

function unlock()
    unlocked = true
    extendUnlock()
end

-- ??????????????
function extendUnlock()
    unlockedSince = myo.getTimeMilliseconds()
end

-- Time since last activity before we lock
UNLOCKED_TIMEOUT = 9200


function onPeriodic()
    -- Lock after inactivity
    if unlocked then
        -- If we've been unlocked longer than the timeout period, lock.
        -- Activity will update unlockedSince, see extendUnlock() above.
        if myo.getTimeMilliseconds() - unlockedSince > UNLOCKED_TIMEOUT then
            myo.vibrate("short")
            unlocked = false
        end
    end
end

function onForegroundWindowChange(app, title)
    -- Here we decide if we want to control the new active app.
    myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
    if title == string.match(title, 'Hearthstone') or title == string.match(title, 'Debug Console') then
        myo.debug("You are in control")
		myo.controlMouse(true)
        return true
		
    end
    return false
end

function activeAppName()
    -- Return the active app name determined in onForegroundWindowChange
    return "Hearthstone"
end

function onActiveChange(isActive)
    myo.debug("onActiveChange")
    if not isActive then
        unlocked = false
    end
end