---This upgrade will change from bullet projectiles to beam shots.
--[[

 Written by Michael R. Roark <miroark@ius.edu>, February 2016

]]

--[[
	beamUpgrade data members:
	id	: 1		lets other parts of code know what functions to call
	x	: varies
	y	: varies
	img	: beamUpgrade.jpg
]]--

function beamUpgradeCollision()
	pilot.attackLevel = 1 --set the player to have the beam attack
	beamUpgradeCollisionSound:play()
end

function beamUpgradeLoad(arg)
	beamUpgradeImg = love.graphics.newImage('assets/upgrades/beamUpgrade.jpg')
	beamUpgradeCollisionSound = love.audio.newSource("assets/upgrades/beamUpgradePickup.wav")
end

function beamUpgradeUpdate(dt, upgrade)
	upgrade.y = upgrade.y + (80 * dt) --moves very slowly
end

function beamUpgradeCreate(inX, inY)
	newBeamUpgrade = {x = inX, y = inY, img = beamUpgradeImg, id = 1}
	
	return newBeamUpgrade
end