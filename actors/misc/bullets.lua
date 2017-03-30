function bulletLoad(arg) 
	--all graphics, sounds, ect needed for the enemy bullets should be loaded here. We'll assume we need to get all bullets loaded. 
	--If this becomes cumbersome to a system later on we can modify this, but I don't forsee an issue, especially if we try to reuse assets with call throughs.
	
	simpleBulletImg = love.graphics.newImage('assets/projectiles/enemyBullet.png') -- borrowing the pilot's bullet image for now
	simpleBulletSound = love.audio.newSource("assets/projectiles/simpleBulletSound.wav", "static")
end
--========================================================================
--[[
 Simple Bullet
 Written by Michael R. Roark <miroark@ius.edu>, March 2016
]]

function simpleBulletCreate(inX, inY, inAngle)
	newSimpleBullet = {x = inX, y = inY, img = simpleBulletImg, id = 1}
	
	--##ANGLE##--
	if not inAngle then --if no value for angle was provided
		newSimpleBullet.angle = 90 --set to default angle of 90 degrees (remember to convert to radians when doing calculations)
						   --this will be straight down.
	else
		newSimpleBullet.angle = inAngle--otherwise set it to be what the user provided.
	end
	
	simpleBulletSound:play()
	
	return newSimpleBullet
end

function simpleBulletUpdate (dt, bullet)
	bullet.x = bullet.x + (math.cos(math.rad(bullet.angle)) * dt * 500)	--same speed as the players bullets
	bullet.y = bullet.y + (math.sin(math.rad(bullet.angle)) * dt * 500) --same speed as the players bullets
end
--===============================================================================
--[[
	Shotgun Bullet
	Written by Michael R. Roark <miroark@ius.edu>, April 2016
]]

function shotgunCreate (inX, inY, inAngle, inSpread)
	--Since this is just calling simpleBulletCreate three times there is no need for a shotgunUpdate()
	
	if not inAngle then --if no value for angle was provided
		angle = 90 --set to default angle of 90 degrees (remember to convert to radians when doing calculations)
						   --this will be straight down.
	else
		angle = inAngle--otherwise set it to be what the user provided.
	end
	
	if not inSpread then
		spread = 15
	else
		spread = inSpread
	end
	
	--I'm breaking the rules set previously, but hopefully it's a one time thing.
	
	--first is fired at a -45 degree angle from the provided inAngle
	newBullet = simpleBulletCreate(inX, inY, (angle - spread))
	table.insert(enemyBullets, newBullet)
	
	--second is the inAngle
	newBullet = simpleBulletCreate(inX, inY, angle)
	table.insert(enemyBullets, newBullet)
	
	--third is +45 degrees
	
	newBullet = simpleBulletCreate(inX, inY, (angle + spread))
	 return newBullet
end

--==========================================================================================================
--[[
 Wave Bullet
 Written by Michael R. Roark <miroark@ius.edu>, March 2016
]]

function waveCreate(inX, inY, inAngle, inFrequency, inAmplitude)
	--inX and inY are the initial starting point for the grunt
	--inAgnle is the angle the projectile should travel along.
	
	newWave = { x = inX, y = inY, img = simpleBulletImg , id = 2} --basics
	
	--##ANGLE##--
	if not inAngle then --if no value for angle was provided
		newWave.angle = 90 --set to default angle of 90 degrees (remember to convert to radians when doing calculations)
						   --this will be straight down.
	else
		newWave.angle = inAngle--otherwise set it to be what the user provided.
	end
	
	--not so basic parts, we can think of these as private members of the object.
	newWave.vectorX = inX
	newWave.vectorY = inY
	newWave.startX = inX
	newWave.startY = inY
	newWave.instanceTimer = 0
	
	--##FREQUENCY##--
	if not inFrequency then --if no value for frequency was provided
		newWave.frequency = 0.03 --set to default 0.03
	else --if a value was provided for frequency
		newWave.frequency = inFrequency --set to provided value. Probably want a very small number
		
	end
	
	--##AMPLITUDE##--
	if not inAmplitude then --if no value for amplitude was provided 
		newWave.amplitude = 50 --then set to default 50
	else --if a value was provided for amplitude then 
		newWave.amplitude = inAmplitude --set to provided value
	end

	simpleBulletSound:play()
	
	return newWave
end

function waveUpdate(dt, bullet)
	bullet.instanceTimer = bullet.instanceTimer + dt
	
	--this is the vector our bullet will travle along.
	bullet.vectorX = bullet.vectorX + (math.cos(math.rad(bullet.angle)) * dt * 500)	--same speedas the players bullet
	bullet.vectorY = bullet.vectorY + (math.sin(math.rad(bullet.angle)) * dt * 500) --same speed as the players bullets
	--v = <cos(bullet.angle) * t, sin(bullet.angle) * t>
	
	--Magnitude is a temporary value that isn't needed for anything besides the next calculation.
	magnitude = math.sqrt(((bullet.startX - bullet.vectorX) * (bullet.startX - bullet.vectorX)) + ((bullet.startY - bullet.vectorY) * (bullet.startY - bullet.vectorY)))
	
	--v+r where r = <cos(bullet.angle - 90) * sin(|v|), sin(bullet.angle - 90) * sin(|v|)>
	bullet.x = bullet.vectorX + math.cos(math.rad(bullet.angle - 90)) * (math.sin (magnitude * bullet.frequency) * bullet.amplitude)
	bullet.y = bullet.vectorY + math.sin(math.rad(bullet.angle - 90)) * (math.sin (magnitude * bullet.frequency) * bullet.amplitude)
end