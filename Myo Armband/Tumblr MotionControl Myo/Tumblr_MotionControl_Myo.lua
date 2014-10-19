scriptId = 'com.thalmic.scripts.tumblr'

--Robin Goins
--October 19, 2014

--globals

--boolean determining interface mode
mouseMode = true

--boolean determinind if the fist position is held or released
--for use with 
holdvar = false


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
		
		--mode select using thumbToPinky
		if pose == "thumbToPinky" then
			mouseMode = not mouseMode
		end
		
		--mouseMode where we control interface w/ cursor
		--fist to select
		--and arm roll for scrolling
		if(mouseMode == true) then
			--turn on mouse control
			myo.controlMouse(true)
			
			--select things with Fist pose	
			if pose == "fist" then
				myo.mouse("left","click")
				restvar = math.abs(math.deg(myo.getRoll()));
			end
		end
		--other mode where we use keyboard keys to navigate
		if  mouseMode == false then
			--turn off mouse control
			myo.controlMouse(false)
			
			--next post using waveIn motion
			if pose == "waveIn" then
				myo.keyboard("j","down")
			end
		
			--last post using waveout motion
			if pose == "waveOut" then
				myo.keyboard("k","down")
			end
		
			--"like" using fist
			if pose == "fist" then
				myo.keyboard("l","down")
			end
			
			--"reblog" using spread
			if pose == "fingersSpread" then
				myo.keyboard("function","down")
				myo.keyboard("r","down")
				myo.keyboard("function","up")
			end
		end				
	end
	
	--release keys/mouse when pose released
	if edge == "off" then
		myo.mouse("left","up")
		myo.mouse("right","up")
		myo.keyboard("up_arrow","up")
		myo.keyboard("down_arrow","up")
		myo.keyboard("j","up")
		myo.keyboard("k","up")
		myo.keyboard("l","up")
		myo.keyboard("r","up")
	end
end

-- Unlock mechanisms (unused)

function unlock()
    unlocked = true
    extendUnlock()
end

function extendUnlock()
    unlockedSince = myo.getTimeMilliseconds()
end


function onPeriodic()
	-- poll to see the roll compared to the resting roll value
	-- (if in mousemode)
	if(mouseMode == true) then
		if math.abs(math.deg(myo.getRoll())) > (9 + restvar) then
			myo.keyboard("down_arrow","down")
		elseif math.abs(math.deg(myo.getRoll())) < (restvar-9) then
			myo.keyboard("up_arrow","down")
		end
	end
end

function onForegroundWindowChange(app, title)
    -- Here we decide if we want to control the new active app.
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