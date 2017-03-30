--[[

 Written by Michael R. Roark <miroark@ius.edu>, March 2016

]]

--[[
	Marksman data members:
	id	: 3		lets other parts of code know what functions to call
	x	: varies
	y	: varies
	img	: marksman.jpg
]]--

function getAngle(enemy)
	changeInX = (enemy.x + (enemy.img:getWidth() / 2)) - (pilot.x + (pilot.img:getWidth() / 2))
	changeInY = (enemy.y + (enemy.img:getHeight() / 2)) - (pilot.y + (pilot.img:getHeight() / 2))
	
	return (math.atan2(changeInY, changeInX) * 180 / math.pi) + 180
end

function marksmanLoad(arg)
	marksmanImg = love.graphics.newImage('assets/enemies/marksman.png')
end

function marksmanUpdate(dt, enemy)
	enemy.y = enemy.y + (500 * dt) --moves down the screen fast
	
	--might create bullets, might not. Depends on the timer.
	enemy.createBulletTimer = enemy.createBulletTimer - dt
	if enemy.createBulletTimer < 0 then
		enemy.createBulletTimer = 0.4 -- fires as fast as the player can.
		
		angleToPilot = getAngle(enemy)
		
		newBullet = simpleBulletCreate(enemy.x + (enemy.img:getWidth() / 2), enemy.y + (enemy.img:getHeight() / 2), angleToPilot) --create a new bullet
		table.insert(enemyBullets, newBullet) --insert the new bullet into the array
	end
	
end

function marksmanCreate(inX, inY)
	
	newMarksman = { x = inX, y = inY, img = marksmanImg , id = 3}
	newMarksman.createBulletTimer = 0.15; --give a delay before the marksman can begin firing. This will be independant of the actual rate of fire
	
	return newMarksman
end