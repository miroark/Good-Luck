--[[

 Written by Michael R. Roark <miroark@ius.edu>, February 2016
 Modified by Nick Fynn <Sygil05@gmail.com>, April 2016
 Modified by Michael R. Roark <miroark@ius.edu>, April 2016
 
]]

debug = true

--=========================================================================================================---
--misc variables

isAlive = true	--makes sure the player hasn't died and the game is continuing
score = 0		--The score of the player.
whichLevel = 0	--controls which level logic will be pulled from.


menuIsOn = true --sentinel value for if the menu is on or off. Defaulted to starting at menu.

--################################################################################################################--

enemies = {} --holds all instances of enemies
enemyBullets = {} --holds all instances of enemy bullets
pilotBullets = {} --holds all instances of the players bullets
upgrades = {} --an array to hold all of the powerups and upgrades that the player can collect.

--called by the level*.lua files so if we want to change the rules of collision we can easily do so.
function detectCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	--x1 & y1 are the first objects poisition (Or rather it's upper left corner), and w1 h1 is the width and height of the first object.
	--x2, y2, w2, h2 are all the same, but for a different object.
	
	--returns a boolean value, if true there's a collision.
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function love.load(arg)
--===========================================================================================================---
	--load lua files
	local playerScripts = require("actors.player.player")
	local firstLevel = require("levels.level1")
	local secondLevel = require("levels.level2")
	local menu = require("levels.menu")
	
	menuLoad(arg)

	-- load player assets
	playerLoad(arg)
	
	--check for connected joysticks.
	joysticks = love.joystick.getJoysticks()
	
	--bgm
	bgm = love.audio.newSource("assets/music/level1.mp3", "stream")
	bgm:setLooping(true)
	bgm:setVolume(0.5)
	love.audio.play(bgm)
end -- end love.load

--###################################################################################################################--

function love.update(dt)
--================================================================================================================--
	--Network packet send/recieve handling.
	--TODO: Handle network packets

--==================================================================================================================================--
	--menu
	if love.keyboard.isDown('escape') and menuIsOn == false then
		--turn menu on/off so it doesn't get drawn in the draw function
		menuIsOn = not menuIsOn
	end
	
	if menuIsOn then
		menuUpdate(dt)
	else
	
--=============================================================================================================================================--
		--level stuff
		
		--Level 1 logic used
		if whichLevel == 1 then
			level1Update(dt)
		--Level 2 logic used
		elseif whichLevel == 2 then
			level2Update(dt)
		--Error, whichLevel selected DNE
		else
			--handle error here
		end -- end if elseif .. else
			
		--The call sequence will look like this: main.love.update --> level*Update --> [enemyName]Update
		
		--pilot controls

		playerUpdate(dt)
	end
end -- end love.update

--##################################################################################################################################--

function love.draw(dt)
--=======================================================================================================================================--
	--draw level stuff
	--Level 1 logic used
	if menuIsOn then
		menuDraw(dt)
	else
		if whichLevel == 1 then
			level1Draw(dt)
		--Level 2 logic used
		elseif whichLevel == 2 then
			level2Draw(dt)
		--Error, level selected DNE
		else
			--handle error here
		end
	
	
		--draw player stuff
		if isAlive then
			playerDraw(dt)
		else
			--if the player is dead then don't draw the pilot or pilotBullets (found in player.lua)
			--instead display the restart button prompt.
			love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)--display in middle of the screen
		end
		
	end
	--The last thing to be displayed is the overlay
	--score:
	message = "Score: " .. score
	love.graphics.print(message, 0, 0)
end -- end love.draw