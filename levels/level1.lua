--[[

 Written by Michael R. Roark <miroark@ius.edu>, March 2016

]]

function level1UpgradeChance()
	--right now it returns true or false. later it'll give unique identifiers for various upgrades.
	chanceToDrop = 20
	
	randomNumber = math.random (0, 100) --generate a number 1 to 100 (for percentage based drops.)
	
	return randomNumber <= chanceToDrop
end

function level1CollisionDetectionHandler()
--=================================================================================================================--
	--Collision detection for the level
	
	for i, enemy in ipairs(enemies) do --for every enemy
		
		--check if they collided with the player.
		if detectCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), pilot.x, pilot.y, pilot.img:getWidth(), pilot.img:getHeight()) and isAlive then
			isAlive = false --DEAD PLAYER
		end
	
		for j, bullet in ipairs(pilotBullets) do --for every pilot bullet
			--see if they collide with player bullets
			if detectCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) and isAlive then
				--##DEATHS AND ALL THATS ASSOCIATED WITH IT##--
				if not bullet.piercing then --if it doesn't pierce
					table.remove(pilotBullets, j) --erase bullet
				end
				table.remove(enemies, i) --kill and erase enemy
				
				--upgrade jazz
				if level1UpgradeChance() then --maybe it'll drop an upgrade?
					newUpgrade = beamUpgradeCreate(enemy.x, enemy.y) --It did! Put that thing where the enemy was.
					table.insert(upgrades, newUpgrade) --pop that into the array.
				end
				
				--##SCORING##--
				--grunt score
				if enemy.id == 1 then
					score = score + 1
				--pulsar score
				elseif enemy.id == 2 then
					score = score + 2
				--Marksman score
				elseif enemy.id == 3 then
					score = score + 5
				--kamikaze score
				elseif	enemy.id == 4 then
					score = score + 3
				--weevil scoring
				elseif enemy.id == 5 then
					scor = score + 2
				else
					--default to adding two points if the id doesn't match one of the above
					score = score + 2
				end					
			end
		end		
	end
		
	--now to check if the player collides with enemy attacks.
	for i, bullet in ipairs(enemyBullets) do --for every enemyBullet
	--see if they collide
		if detectCollision(bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight(), pilot.x, pilot.y, pilot.img:getWidth(), pilot.img:getHeight()) and isAlive then
			isAlive = false --DEAD PLAYER
		end
	end
	
	--see if the player has collided with an upgrade.
	for i, upgrade in ipairs(upgrades) do
		if detectCollision(upgrade.x, upgrade.y, upgrade.img:getWidth(), upgrade.img:getHeight(), pilot.x, pilot.y, pilot.img:getWidth(), pilot.img:getHeight()) and isAlive then
			if upgrade.id == 1 then
				beamUpgradeCollision()
			end
			table.remove(upgrades, i)
		end
	end
end

function level1UpdateEnemies(dt)
--=================================================================================--
	--##ENEMY UPDATES##--
		--update the positions of enemies
	screenBuffer = 100 --this is how far the object must travel off screen to be deleted.
	for i, enemy in ipairs(enemies) do
		if enemy.id == 1 then
			gruntUpdate(dt,enemy)
		elseif enemy.id == 2 then
			pulsarUpdate(dt,enemy)
		elseif enemy.id == 3 then
			marksmanUpdate(dt, enemy)
		elseif enemy.id == 4 then
			kamikazeUpdate(dt, enemy)
		elseif enemy.id == 5 then
			weevilUpdate(dt, enemy)
		else
			--error
			--handle by removing the object.
			table.remove(enemies, i)
		end
		
		--is it on screen?
		if enemy.y > 600 +screenBuffer then -- remove enemies when they pass off the bottom of the screen
			table.remove(enemies, i)
		elseif enemy.y < -screenBuffer then --remove if they pass of the top of the screen by a good margin
			table.remove(enemies, i)
		elseif enemy.x < -screenBuffer then --remove if it passes of the left of the screen by a good margin	
			table.remove(enemies, i)
		elseif enemy.x > 800 + screenBuffer then --remove if it passes of the right of the screen by a good margin
			table.remove(enemies, i)
		end
	end
end

function level1UpdateEnemyBullets(dt)
	--update positions of enemy bullets
	
	screenBuffer = 100 --this is how far the object must travel off screen to be deleted.
	for i, bullet in ipairs(enemyBullets) do
		if bullet.id == 1 then
			simpleBulletUpdate(dt, bullet)
		elseif bullet.id == 2 then
			waveUpdate(dt, bullet)
		else
			--error. delete the bullet.
			table.remove(enemyBullets, i)
		end
		
		--is it on screen?
		if bullet.y > 600 + screenBuffer then -- remove enemies when they pass off the bottom of the screen
			table.remove(enemyBullets, i)
		elseif bullet.y < -screenBuffer then --remove if they pass of the top of the screen by a good margin
			table.remove(enemyBullets, i)
		elseif bullet.x < -screenBuffer then --remove if it passes of the left of the screen by a good margin	
			table.remove(enemyBullets, i)
		elseif bullet.x > 800 + screenBuffer then --remove if it passes of the right of the screen by a good margin
			table.remove(enemyBullets, i)
		end
	end
end --updateEnemyBullets end

function level1UpdateUpgrades(dt)
	screenBuffer = 100 --this is how far the object must travel off screen to be deleted.
	for i, upgrade in ipairs(upgrades) do
		if upgrade.id == 1 then
			beamUpgradeUpdate(dt, upgrade)
		end
		--is it on screen?
		if upgrade.y > 600 + screenBuffer then -- remove powerups when they pass off the bottom of the screen
			table.remove(upgrades, i)
		elseif upgrade.y < -screenBuffer then --remove if they pass of the top of the screen by a good margin
			table.remove(upgrades, i)
		elseif upgrade.x < -screenBuffer then --remove if it passes of the left of the screen by a good margin	
			table.remove(upgrades, i)
		elseif upgrade.x > 800 + screenBuffer then --remove if it passes of the right of the screen by a good margin
			table.remove(upgrades, i)
		end
	end
end -- updatePowerups end

function level1CreateEnemies(dt)
--===========================================================================================
	--##ENEMY CREATION##--
	-- Time out enemy creation
	createEnemyTimer = createEnemyTimer - (1 * dt)
	
	if createEnemyTimer < 0 then
		createEnemyTimer = createEnemyTimerMax

		-- Create an enemy
		randomNumber = math.random(10, love.graphics.getWidth() - 10)
		enemyIDSentinel = randomNumber % 5
		
		if enemyIDSentinel == 0 then
			--create grunt
			newEnemy = gruntCreate(randomNumber, -10) --have the enemy slide in from off screen
		elseif enemyIDSentinel == 1 then
			--create pulsar
			newEnemy = pulsarCreate(randomNumber, -10)
		elseif enemyIDSentinel == 2 then
			--create marksman
			newEnemy = marksmanCreate(randomNumber, -10)
		elseif enemyIDSentinel == 3 then
			newEnemy = kamikazeCreate(randomNumber, -10)
		elseif enemyIDSentinel == 4 then
			newEnemy = weevilCreate(randomNumber, -10)
		else
			--error
			--Handle by doing nothing. 
		end
		
		table.insert(enemies, newEnemy)
	end
end --createEnemies end

function level1Load (arg)
	--first get all other lua files needed for the level
	local gruntScripts = require("actors.enemies.grunt")
	local pulsarScripts = require("actors.enemies.pulsar")
	local marksmanScripts = require("actors.enemies.marksman")
	local kamikazeScripts = require("actors.enemies.kamikaze")
	local weevilScripts = require("actors.enemies.weevil")
	local beamUpgradeScripts = require("actors.upgrades.beamUpgrade")
	
	local bulletScripts = require("actors.misc.bullets")
	createEnemyTimerMax = 0.4
	createEnemyTimer = createEnemyTimerMax
	
	gruntLoad(arg)
	pulsarLoad(arg)
	marksmanLoad(arg)
	kamikazeLoad(arg)
	weevilLoad(arg)
	
	beamUpgradeLoad(arg)
	
	bulletLoad(arg)		
end

function level1Update(dt)
	level1CreateEnemies(dt)
	
	level1UpdateEnemies(dt)
	
	level1UpdateEnemyBullets(dt)
	
	level1UpdateUpgrades(dt)
	
	level1CollisionDetectionHandler()
end

function level1Draw(dt)
	--unless there's some unforseen issue in the future a callthrough shouldn't be needed here since every enemy has the same 
	for i, enemy in ipairs(enemies) do
		love.graphics.draw(enemy.img, enemy.x, enemy.y)
	end
	
	for i, bullet in ipairs(enemyBullets) do
		love.graphics.draw(bullet.img, bullet.x, bullet.y)
	end
	
	for i, upgrade in ipairs(upgrades) do
		love.graphics.draw(upgrade.img,upgrade.x,upgrade.y)
	end
end