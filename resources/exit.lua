
-- Extends an object to load a new map

-- Define module
local M = {}

local composer = require( "composer" )

local fx = require( "com.ponywolf.ponyfx" )

function M.new( instance )

	if not instance then error( "ERROR: Expected display object" ) end

	-- Get current scene and sounds
	local scene = composer.getScene( composer.getSceneName( "levelTwo" ) )
--	local sounds = scene.sounds

	if not instance.bodyType then
		physics.addBody( instance, "static", { isSensor = true } )
	end

	function instance:collision( event )
		local phase, other = event.phase, event.other
		if phase == "began" and other.name == "toad" and not other.isDead then
			other.isDead = true
			other.linearDamping = 8
			-- audio.play( sounds.door )
			self.fill.effect = "filter.exposure"
			transition.to( self.fill.effect, { time = 666, exposure = -5, onComplete = function()
				fx.fadeOut( function()
					composer.gotoScene( "resources.refresh", { params = { map = self.map } } )
				end )
			end } )
		end
	end

	instance:addEventListener( "collision" )
	return instance
end

return M
