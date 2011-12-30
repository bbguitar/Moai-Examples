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

-- walls
platform = world:addBody ( MOAIBox2DBody.STATIC )
fixture2 = platform:addRect (-20,10,30,9) -- bottom

ropes = {}

ropes[0] = world:addBody ( MOAIBox2DBody.DYNAMIC )

bx,by= ropes[0] :getPosition()
fixture = ropes[0] :addRect( -0.25,-1,0.25,1 )
fixture:setDensity ( 1)
fixture:setFriction ( 0.3 )
fixture:setRestitution ( 0.25)
fixture:setFilter ( 0x01 )
fixture.userdata=-1
world:addRevoluteJoint ( ropes[0] , platform,0,2)
ropes[0] :resetMassData()

for y = 1, 8 do
ropes[y] = world:addBody ( MOAIBox2DBody.DYNAMIC )

fixture = ropes[y]:addRect( -0.25,-1,0.25,1 )
ropes[y]:setTransform(0,(y*-2)+2,0)
bx,by= ropes[y]:getPosition()
fixture:setDensity ( 1)
fixture:setFriction ( 0.3 )
fixture:setRestitution ( 0.25)
fixture:setFilter ( 0x01 )
fixture.userdata=-1
world:addRevoluteJoint ( ropes[y], ropes[y-1],0,3-y*2)
ropes[y]:resetMassData()

end


-- setup camera
camera = MOAITransform.new ()
layer:setCamera ( camera )
MOAISim.pushRenderPass ( layer )



