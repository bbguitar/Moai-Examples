


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

-- rectangle
body = world:addBody ( MOAIBox2DBody.DYNAMIC )
fixture=body:addCircle(0,0,2)
fixture:setDensity ( 1)
fixture:setFriction ( 0.3 )
fixture:setRestitution ( 0.5)
fixture:setSensor (true)
--fixture:setFilter ( 1,1,-1 )
--fixture:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END + MOAIBox2DArbiter.PRE_SOLVE, 0x01)
body:resetMassData()

-- rectangle
body2 = world:addBody ( MOAIBox2DBody.DYNAMIC)
body2:setTransform(0,-5,0)
fixture=body2:addRect (-1,-1,1,1)
fixture:setDensity ( 1)
fixture:setFriction ( 0.3 )
fixture:setRestitution ( 0.5)
--fixture:setSensor ()
--fixture:setFilter ( 1,1,-1 )
body2:resetMassData()


-- walls
platform4 = world:addBody ( MOAIBox2DBody.STATIC )
fixture2 = platform4:addRect (-20,-10,30,-9) -- bottom

-- setup camera
camera = MOAITransform.new ()
layer:setCamera ( camera )
MOAISim.pushRenderPass ( layer )



