--[[

 Written by Michael R. Roark <miroark@ius.edu>, March 2016

]]

--[[
	Pulsar data members:
	id	: 2		lets other parts of code know what functions to call
	x	: varies
	y	: varies
	img	: pulsar.jpg
]]--
function pulsarLoad (arg)
	--gets executed from level files.	
	pulsarImg = love.graphics.newImage('assets/enemies/pulsar.png')
end

function pulsarUpdate(dt, enemy)	
	--simple movement, just goes straight down towards the bottom of the screen, slower than grunts do.
	enemy.y = enemy.y + (150 * dt)
	
	--might create bullets, might not. Depends on the timer.
	enemy.createBulletTimer = enemy.createBulletTimer - dt
	if enemy.createBulletTimer < 0 then
		enemy.createBulletTimer = 0.6 -- fires 1/3 as fast as the player can. subject to change
		
		newBullet = waveCreate(enemy.x + (enemy.img:getWidth() / 2), enemy.y + (enemy.img:getHeight() / 2)) --create a new wave bullet
		table.insert(enemyBullets, newBullet) --insert the new bullet into the array
	end
end

function pulsarCreate(inX, inY)
	--inX and inY are the initial starting point for the grunt
	
	newPulsar = { x = inX, y = inY, img = pulsarImg , id = 2}
	newPulsar.createBulletTimer = 0.3 --give a delay before the pulsar can begin firing. This will be independant of the actual rate of fire
	return newPulsar
end