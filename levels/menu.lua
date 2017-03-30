--[[

 Written by Nick Fynn <Sygil05@gmail.com>, April 2016
 Modified by Michael R. Roark <miroark@ius.edu>, April 2016

]]

function menuLoad (arg)
	--Load background image
	bkgd = love.graphics.newImage("assets/backgrounds/Level1_Bkgd.png")
	bkgd_Title = love.graphics.newImage("assets/backgrounds/menuTitle.png")
end

function menuUpdate(dt)
	if love.keyboard.isDown('1') then
		whichLevel = 1
		menuIsOn = false
		level1Load()
		
		-- remove all our bullets upgrades and enemies from screen
		pilotBullets = {}
		enemies = {}
		enemyBullets = {}
		upgrades = {}
	elseif love.keyboard.isDown('2') then
		whichLevel = 2
		menuIsOn = false
		level2Load()
		
		-- remove all our bullets upgrades and enemies from screen
		pilotBullets = {}
		enemies = {}
		enemyBullets = {}
		upgrades = {}
	end
	
end

function menuDraw(dt)
	--first load background image
	love.graphics.draw(bkgd)
	love.graphics.draw(bkgd_Title, love.graphics.getWidth( ) / 2 - (bkgd_Title:getWidth() / 2), love.graphics.getHeight( ) - 500)
	
	love.graphics.print("Select a level (1-2)", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
end