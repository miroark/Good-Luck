--[[

 Written by Michael R. Roark <miroark@ius.edu>, April 2016

]]

--[[
	Weevil data members:
	id	: 5	lets other parts of code know what functions to call
	x	: varies
	y	: varies
	img	: weevil.jpg
]]--

function weevilLoad(arg)
	weevilImg = love.graphics.newImage('assets/enemies/weevil.png')
end

function weevilUpdate(dt,enemy)

	--weevil movement copies that of the wave bullet type
	enemy.instanceTimer = enemy.instanceTimer + dt
	
	--this is the vector our enemy will travle along.
	enemy.vectorX = enemy.vectorX + (math.cos(math.rad(enemy.angle)) * dt * enemy.speed)
	enemy.vectorY = enemy.vectorY + (math.sin(math.rad(enemy.angle)) * dt * enemy.speed) 
	--v = <cos(enemy.angle) * t, sin(enemy.angle) * t>
	
	--Magnitude is a temporary value that isn't needed for anything besides the next calculation.
	magnitude = math.sqrt(((enemy.startX - enemy.vectorX) * (enemy.startX - enemy.vectorX)) + ((enemy.startY - enemy.vectorY) * (enemy.startY - enemy.vectorY)))
	
	--v+r where r = <cos(enemy.angle - 90) * sin(|v|), sin(enemy.angle - 90) * sin(|v|)>
	enemy.x = enemy.vectorX + math.cos(math.rad(enemy.angle - 90)) * (math.sin (magnitude * enemy.frequency) * enemy.amplitude)
	enemy.y = enemy.vectorY + math.sin(math.rad(enemy.angle - 90)) * (math.sin (magnitude * enemy.frequency) * enemy.amplitude)
	
	--bullet creation
	enemy.createBulletTimer = enemy.createBulletTimer - dt
	if enemy.createBulletTimer < 0 then
		newBullet = simpleBulletCreate(enemy.x + (enemy.img:getWidth() / 2), enemy.y + (enemy.img:getHeight() / 2)) --create a new bullet
		table.insert(enemyBullets, newBullet) --insert the new bullet into the array
		
		enemy.createBulletTimer = 0.5
	end
end

function weevilCreate(inX, inY, inAmplitude, inFrequency)
	
	--just da basics
	newWeevil = { x = inX, y = inY, img = weevilImg , id = 5}
	
	newWeevil.angle = 90 --this is here for when/if I decide to change the enemies to incllude an angle to travel across. I'll likely do this soon.
	newWeevil.vectorX = inX
	newWeevil.vectorY = inY
	newWeevil.startX = inX
	newWeevil.startY = inY
	newWeevil.instanceTimer = 0
	newWeevil.speed = 200 --might want to offer this as a variable that you can offer during a call
	
	--##AMPLITUDE##--
	if not inAmplitude then
	--default
		newWeevil.amplitude = 100
	else
		newWeevil.amplitude = inAmplitude
	end
	
	--##FREQUENCY##--
	if not inFrequency then
		--default
		newWeevil.frequency = 0.015
	else
		newWeevil.frequency = inFrequency
	end
	
	newWeevil.createBulletTimer = 0.3; 
	
	return newWeevil
end