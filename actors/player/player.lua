--[[

 Written by Michael R. Roark <miroark@ius.edu>, February 2016

]]

--[[
variables to use from this file:
	pilot :: The most valuable "object", contains most information needed.
	pilotBullet :: contains all bullet "objects"
]]--
function playerLoad(arg)
	--prototype
	pilot = { 
		x = 0, 
		y = 0, 
		speed = 300, 
		attackLevel = 0, --controls what projectile will be used. Default 0 for bullets, 1 for beams
		numOfAttacks = 1, --How many projectiles will the player make when they press space? Not yet handled.
		attackSpeed = 500,	--How fast will the attacks travel up the screen?
		img = nil
	} --end pilot


	--======================================================================================================--
	--pilot related variables
	--sentinel values for the players current attack type
	BULLET_LEVEL = 0
	BEAM_LEVEL = 1

	pilotBulletImg = nil
	pilotBeamImg = nil

	--handle rate of fire logic
	canShoot = true
	canShootTimerMax = 0.2 
	canShootTimer = canShootTimerMax

	--array for projectiles that are on screen being updated and drawn
	

	--load pilot image
	pilot.img = love.graphics.newImage('assets/characters/playerShip.png')
	--place the pilot near the bottom of the screen in the center.
	pilot.x = love.graphics.getWidth( ) / 2 - (pilot.img:getWidth() / 2)
	pilot.y = love.graphics.getHeight( ) - 100 
	
	--load all projectiles fired by pilot 
	
	--pilot projectiles
	pilotBulletImg = love.graphics.newImage('assets/projectiles/pilotBullet.png')
	pilotBeamImg = love.graphics.newImage('assets/projectiles/pilotBeam.png')
	
	--pilot sounds
	pilotBulletSound = love.audio.newSource("assets/projectiles/simpleBulletSound.wav", "static")
	pilotBeamSound = love.audio.newSource("assets/projectiles/beamSound.wav", "static")
	
	pilotBulletSound:setVolume(1.2)
	pilotBeamSound:setVolume(1.2)
	
end --end of playerLoad

function playerUpdate(dt)
---------------------------------------------------------------------------------------
	--Keyboard
	
	
	if isAlive then
		--movement
		if love.keyboard.isDown('left','a') then
			--check bound
			if pilot.x > 0 then
				pilot.x = pilot.x - (pilot.speed * dt)
			end --end of coord change
		end --end if left
	
		if love.keyboard.isDown('right','d') then
			--check bound
			if pilot.x < (love.graphics.getWidth() - pilot.img:getWidth()) then 
				pilot.x = pilot.x + (pilot.speed * dt)
			end --end of coord change
		end --end if right
	
		if love.keyboard.isDown('up', 'w') then
			--check bound
			if pilot.y > 0 then
				pilot.y = pilot.y - (pilot.speed * dt)
			end --end of coor change
		end -- end if up
	
		if love.keyboard.isDown('down','s') then
			--check bound
			if pilot.y < (love.graphics.getHeight() - pilot.img:getHeight()) then
				pilot.y = pilot.y + (pilot.speed * dt)
			end --end of coord change
		end--end if down
	
	
		--shooting
	
		if love.keyboard.isDown("space") and canShoot then
			--Create some projectiles
			--create bullets at attack level 0
			if pilot.attackLevel == BULLET_LEVEL then 
				newBullet = { x = pilot.x + (pilot.img:getWidth()/2), y = pilot.y, img = pilotBulletImg, piercing = false } --create a bulet at the center of the character. bullets cant pierce.
				table.insert(pilotBullets, newBullet)
				canShoot = false
				canShootTimer = canShootTimerMax
				--play the bullet sound
				pilotBulletSound:play()
			--create beams if attack level 1
			elseif pilot.attackLevel == BEAM_LEVEL then 
				newBeam = { x = pilot.x + (pilot.img:getWidth()/2), y = pilot.y, img = pilotBeamImg, piercing = true } --create a beam at the center of the character. Beams piece.
				table.insert(pilotBullets, newBeam)
				canShoot = false
				canShootTimer = canShootTimerMax
				pilotBeamSound:play()
			--there's an error and we went out of bounds.
			else 
				pilot.attackLevel = 0 --set it within the bounds again.
			end -- end if-elseif-else bullets
			--we've made the bullet, time to play the sound.
		end -- end if space_bar
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--Joystick controls
	
	--TODO: Implement joystick compat
	
---------------------------------------------------------------------------------------------------------------------------------------------------------
		--Player bullet updates
		canShootTimer = canShootTimer - (1 * dt)
		if canShootTimer < 0 then
			canShootTimer = 0 --handle possible overflow by keeping the variable hovering around 0 at all times.
			canShoot = true
		end -- end if
		
			--update pilotBullet positions
		for i, bullet in ipairs(pilotBullets) do
			bullet.y = bullet.y - (pilot.attackSpeed * dt)

			if bullet.y < 0 then -- remove bullets when they pass off the screen
				table.remove(pilotBullets, i)
			end --end if
		end --end for
	end --end of living pilot controls
	
	--dead player mode
	if not isAlive and love.keyboard.isDown('r') then
		-- remove all our bullets upgrades and enemies from screen
		pilotBullets = {}
		enemies = {}
		enemyBullets = {}
		upgrades = {}

		-- reset timers
		canShootTimer = canShootTimerMax
		createEnemyTimer = createEnemyTimerMax
	
		-- move player back to default position
		pilot.x = love.graphics.getWidth( ) / 2 - (pilot.img:getWidth() / 2)
		pilot.y = love.graphics.getHeight( ) - 100 

		-- reset our game state
		score = 0
		isAlive = true
		pilot.attackLevel = 0
		pilot.numOfAttacks = 1
		
		--reseed the random number generator.
		  math.randomseed(2)
	end --end of dead player controls
end --end of playerUpdate

function playerDraw(dt)
	--handle pilot drawing
	--draw the pilot
	love.graphics.draw(pilot.img, pilot.x, pilot.y)
	
	--draw pilotBullets
	for i, bullet in ipairs(pilotBullets) do
		love.graphics.draw(bullet.img, bullet.x, bullet.y)
	end

end --end of playerDraw