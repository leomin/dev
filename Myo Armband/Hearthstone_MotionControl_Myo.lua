scriptId = 'com.thalmic.scripts.hearthstone'

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
    myo.debug("onPoseEdge: " .. pose .. ", " .. edge)

	if edge == "on" then
		--grab/select things in game with Fist pose	
		if pose == "fist" then
			myo.mouse("left","down")
		end
		
		--right click mouse using FingersSpread pose
		if pose == "fingersSpread" then
			myo.mouse("right","down")
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

-- unnecessary for this app
function extendUnlock()
    unlockedSince = myo.getTimeMilliseconds()
end

function onPeriodic()
end

function onForegroundWindowChange(app, title)
    -- Here we decide if we want to control the new active app.
    myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
    if title == string.match(title, 'Hearthstone') then		
		myo.controlMouse(true)
		myo.debug("mouse enabled")
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