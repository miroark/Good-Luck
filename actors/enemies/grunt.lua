--[[

 Written by Michael R. Roark <miroark@ius.edu>, March 2016

]]

--[[
	Grunt data members:
	id	: 1		lets other parts of code know what functions to call
	x	: varies
	y	: varies
	img	: grunt.jpg
]]--
function gruntLoad (arg)
	--gets executed from level files.	
	gruntImg = love.graphics.newImage('assets/enemies/grunt.png')
end

function gruntUpdate(dt, enemy)	
	--simple movement, just goes straight down towards the bottom of the screen
	enemy.y = enemy.y + (300 * dt)
	
	enemy.createBulletTimer = enemy.createBulletTimer - dt
	if enemy.createBulletTimer < 0 then
		enemy.createBulletTimer = 1 -- fires 1/3 as fast as the player can. subject to change
		
		newBullet = shotgunCreate(enemy.x + (enemy.img:getWidth() / 2), enemy.y + (enemy.img:getHeight() / 2)) --create a new wave bullet
		table.insert(enemyBullets, newBullet) --insert the new bullet into the array
	end
end

function gruntCreate(inX, inY)
	--inX and inY are the initial starting point for the grunt
	
	newGrunt = { x = inX, y = inY, img = gruntImg , id = 1}
	newGrunt.createBulletTimer = 0.05 
	
	return newGrunt
end