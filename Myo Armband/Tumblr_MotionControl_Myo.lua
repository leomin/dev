scriptId = 'com.thalmic.scripts.tumblr'

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
		--select things in game with Fist pose	
		if pose == "fist" then
			myo.mouse("left","click")
			restvar = math.abs(math.deg(myo.getRoll()));
		end
		
		--right click mouse using FingersSpread pose
		if pose == "fingersSpread" then
			myo.mouse("right","down")
		end
		
		if pose == "waveIn" then
			myo.keyboard("page_down","click")
		end
			
	end
	if edge == "off" then
		myo.mouse("left","up")
		myo.mouse("right","up")
		myo.keyboard("up_arrow","up")
		myo.keyboard("down_arrow","up")
	end
end

function pageScroll()
	
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
		if math.abs(math.deg(myo.getRoll())) > (9 + restvar) then
			myo.keyboard("down_arrow","down")
		elseif math.abs(math.deg(myo.getRoll())) < (restvar-9) then
			myo.keyboard("up_arrow","down")
		end
end

function onForegroundWindowChange(app, title)
    -- Here we decide if we want to control the new active app.
    --myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
    if title == string.match(title, '.*Tumblr*.') then		
		myo.controlMouse(true)
		myo.debug("mouse enabled")
        return true
		
    end
    return false
end

function activeAppName()
    -- Return the active app name determined in onForegroundWindowChange
    return "Tumblr"
end

function onActiveChange(isActive)
    myo.debug("onActiveChange")
    if not isActive then
        unlocked = false
    end
end