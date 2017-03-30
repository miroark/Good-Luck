--[[

 Written by Michael R. Roark <miroark@ius.edu>, April 2016

]]

--[[
	Kamikaze data members:
	id	: 4		lets other parts of code know what functions to call
	x	: varies
	y	: varies
	img	: kamikaze.jpg
]]--

function getAngle(enemy)
	changeInX = (enemy.x + (enemy.img:getWidth() / 2)) - (pilot.x + (pilot.img:getWidth() / 2))
	changeInY = (enemy.y + (enemy.img:getHeight() / 2)) - (pilot.y + (pilot.img:getHeight() / 2))
	
	return (math.atan2(changeInY, changeInX) * 180 / math.pi) + 180
end

function kamikazeExplode(enemy)
	--create and explosion object (yet to be implemented)
	
	--make bullets
	--at 0
	newBullet = simpleBulletCreate(enemy.x + (enemy.img:getWidth() / 2), enemy.y + (enemy.img:getHeight() / 2), 0) --create a new bullet
	table.insert(enemyBullets, newBullet) --insert the new bullet into the array
	
	--at 45
	newBullet = simpleBulletCreate(enemy.x + (enemy.img:getWidth() / 2), enemy.y + (enemy.img:getHeight() / 2), 45) --create a new bullet
	table.insert(enemyBullets, newBullet) --insert the new bullet into the array
	
	--at 90
	newBullet = simpleBulletCreate(enemy.x + (enemy.img:getWidth() / 2), enemy.y + (enemy.img:getHeight() / 2), 90) --create a new bullet
	table.insert(enemyBullets, newBullet) --insert the new bullet into the array
	
	--at 135
	newBullet = simpleBulletCreate(enemy.x + (enemy.img:getWidth() / 2), enemy.y + (enemy.img:getHeight() / 2), 135) --create a new bullet
	table.insert(enemyBullets, newBullet) --insert the new bullet into the array
	
	--at 180
	newBullet = simpleBulletCreate(enemy.x + (enemy.img:getWidth() / 2), enemy.y + (enemy.img:getHeight() / 2), 180) --create a new bullet
	table.insert(enemyBullets, newBullet) --insert the new bullet into the array
	
	--at 225
	newBullet = simpleBulletCreate(enemy.x + (enemy.img:getWidth() / 2), enemy.y + (enemy.img:getHeight() / 2), 225) --create a new bullet
	table.insert(enemyBullets, newBullet) --insert the new bullet into the array
	
	--at 270
	newBullet = simpleBulletCreate(enemy.x + (enemy.img:getWidth() / 2), enemy.y + (enemy.img:getHeight() / 2), 270) --create a new bullet
	table.insert(enemyBullets, newBullet) --insert the new bullet into the array
	
	--at 315
	newBullet = simpleBulletCreate(enemy.x + (enemy.img:getWidth() / 2), enemy.y + (enemy.img:getHeight() / 2), 315) --create a new bullet
	table.insert(enemyBullets, newBullet) --insert the new bullet into the array
	
	--remove the enemy from the screen
	enemy.y = 30000
	
end

function kamikazeLoad(arg)
	kamikazeImg = love.graphics.newImage('assets/enemies/kamikaze.png')
end

function kamikazeUpdate(dt, enemy)
	--update the angle first thing
	--the max angle that the kamikaze can travel along is at 45 degrees from 90(straight down) ie 45 - 135
	targetAngle = getAngle(enemy) --where we're aiming to head to
	
	if enemy.y > pilot.y then --this is just a stylistic choice. This makes it so the kamikaze flys straight down if it has passed the player by.
		targetAngle = 90
	end
	
	if targetAngle > enemy.angle then --player is to the right of the kamikaze
		enemy.angle = enemy.angle + (enemy.turnRate * dt)
	elseif targetAngle < enemy.angle then --player is to the left of the kamikaze
		enemy.angle = enemy.angle - (enemy.turnRate * dt)
	else --the player is directly in the sight of the enemy
		--do nothing
	end
	--check if the angle is within 45 to 135 if not set to the closest of the two angles.
	if enemy.angle > 135 then
		enemy.angle = 135
	elseif enemy.angle < 45 then
		enemy.angle = 45
	end
	
	--move along the vector
	enemy.x = enemy.x + (math.cos(math.rad(enemy.angle)) * dt * enemy.speed)
	enemy.y = enemy.y + (math.sin(math.rad(enemy.angle)) * dt * enemy.speed)
	
	--check if it's in range to suicide if so, detonate	
	pilotXC = pilot.x + (pilot.img:getWidth() / 2)
	pilotYC = pilot.y + (pilot.img:getHeight() / 2)
	
	if ((enemy.x - pilotXC) * (enemy.x - pilotXC) + (enemy.y - pilotYC) * (enemy.y - pilotYC)) < (enemy.detonationDistance * enemy.detonationDistance) then
		kamikazeExplode(enemy)
	end
end

function kamikazeCreate(inX, inY, inTurnRate, inAngle, inTimeToTrack)
	
	--standard members
	newKamikaze = { x = inX, y = inY, img = kamikazeImg , id = 4}
	
	--Not modifiable values, but they aren't standard either.
	newKamikaze.speed = 300
	newKamikaze.detonationDistance = 150
	
	--##TURN RATE##--
	--the newKamikaze will track the player and try to get as close as possible.
	if not inTurnRate then --if not value is provided for turn rate
		newKamikaze.turnRate = 50
	else --if there is a value for turn rate
		newKamikaze.turnRate = inTurnRate
	end
	
	--##ANGLE##--
	--angle defines the vector that newKamikaze will travel along.
	if not inAngle then
		newKamikaze.angle = 90 --it enters the game going straight down
	else
		newKamikaze.angle = inAngle
	end
	
	--##TIME TO TRACK##--
	--how long will it take until the kamikaze starts to track the player?
	if not inTimeToTrack then
		newKamikaze.timeToTrack = 0.3
	else
		newKamikaze.timeToTrack = inTimeToTrack
	end
	
	return newKamikaze
end