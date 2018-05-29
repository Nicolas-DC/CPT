local composer = require( "composer" )
local scene = composer.newScene()


local physics = require( "physics" )
physics.start()
physics.setGravity(0, 32)
physics.setDrawMode( "hybrid" ) -- If you want to see the physics bodies in the game, uncomment this line. This will help show you where the boundaries for each object are.

local tiled=require("com.ponywolf.ponytiled")
local dragable=require("com.ponywolf.plugins.dragable")
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
-- These values are set for easier access later on.
local acw = display.actualContentWidth
local ach = display.actualContentHeight
local cx = display.contentCenterX
local cy = display.contentCenterY
local top = display.screenOriginY
local left = display.screenOriginX
local right = display.viewableContentWidth - left
local bottom = display.viewableContentHeight - display.screenOriginY

-- The next lines are forward declares
local createEnemyShips, timerForEnemies -- forward declares for function and timer
local enemyShip = {} -- a table to store the enemy circles
local enemyCounter = 0 -- a counter to store the number of enemies

local playerShip -- forward declare the player ship
local playerScore -- stores the text object that displays player score
local playerScoreCounter = 0 -- a counter to store the players score

local createBullets, timerForBullets -- variables to track bullet function and timer
local bullet = {} -- table that will hold the bullet
local bulletCounter = 0 -- although not necessary, I've added a counter to keep track of the number of bullets. This might be handy if you want to display how many shots the player took or player accuracy.
local time = 750
local onGlobalCollision -- forward declare for collisions. Collisions is what I use to detect hits between player-enemy and bullets-enemy.
local data, map, parallax
-- -----------------------------------------------------------------------------------
-- Scene event functions

-- This is called to stop the game. It will stop bullets, stop enemies, and disallow movement by player. We will also set the stage focus to nil which restore default behavior. This will tell the app that the game is over and the player should no longer be interacting with the player ship.
local function stopGame()
    playerShip:removeEventListener( "touch", playerShip )
    timer.cancel(timerForEnemies)
    timer.cancel(timerForBullets)
    display.getCurrentStage():setFocus( nil )
end


-- Function to scroll the map
local function enterFrame( event )

	local elapsed = event.time

	-- Easy way to scroll a map based on a character
	if hero and hero.x and hero.y  then
		local x, y = hero:localToContent( 0, 0 )
		x, y = display.contentCenterX - x, display.contentCenterY - y+display.contentHeight/4
		map.x, map.y = map.x + x, map.y + y
    print(x.." "..y)
    if (hero.x<display.viewableContentWidth/2) then
      map.x=0
    end
    
    -- print(map.x.." "..map.y)
		-- Easy parallax
		if parallax then
			parallax.x, parallax.y = map.x / 6, map.y / 8  -- Affects x more than y
		end
	end
end
-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    data=require("level1")
    map=tiled.new(data )
    map=dragable.new(map)
    print(display.viewableContentHeight)
    map.x=0
    map.y=-map.designedHeight+display.viewableContentHeight
    map.extensions="resources."
    map:extend("toad")
    hero=map:findObject("toad")
    hero.isDead=false

    parallax=map:findLayer("Clouds")
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        Runtime:addEventListener("enterFrame",enterFrame)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

        -- The game will start to run from here. When the scene is loaded, enemy ships will be generated, the player will start firing, and colliding physics objects will be acted on.
    end
end


-- hide(), this function is not used in this template and here for learning purposes only.
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end


-- destroy(), this function is not used in this template and here for learning purposes only.
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
