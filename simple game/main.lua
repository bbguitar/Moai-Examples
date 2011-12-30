-- setup graphics
MOAISim.openWindow ( "test", 960, 480 )
viewport = MOAIViewport.new ()
screenx=960
screeny=480
viewport:setSize ( screenx,screeny )
viewport:setScale ( 64, 0 )

-- set up the world and start its simulation
world = MOAIBox2DWorld.new ()
world:setGravity ( 0, -10 )
world:setUnitsToMeters ( 2 )
world:start ()

-- layers
layer = MOAILayer2D.new ()
layer:setViewport ( viewport )
layer:setBox2DWorld ( world )

menu_layer = MOAILayer2D.new ()
menu_layer:setViewport ( viewport )

partition = MOAIPartition.new ()
menu_layer:setPartition ( partition )

-- walls
platform4 = world:addBody ( MOAIBox2DBody.STATIC )
fixture2 = platform4:addRect (-20,-10,30,-9) -- bottom

-- setup camera
camera = MOAITransform.new ()
layer:setCamera ( camera )
menu_layer:setCamera ( camera )
MOAISim.pushRenderPass ( layer )
MOAISim.pushRenderPass ( menu_layer )

gfxQuad = MOAIGfxQuad2D.new ()
gfxQuad:setTexture ( "cathead.png" )
gfxQuad:setRect ( -4,-4,4,4 )

function addSprite ( x, y, xScl, yScl, name )
	print "added sprite"
	local prop = MOAIProp2D.new ()
	prop:setDeck ( gfxQuad )
	prop:setPriority ( priority )
	prop:setLoc ( x, y )
	prop:setScl ( xScl, yScl )
	prop.name = name
	partition:insertProp ( prop )
end

addSprite ( 0,-4, 0.5, 0.5, "sprite1" )



