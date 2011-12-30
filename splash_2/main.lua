MOAISim.openWindow ( "test", 320, 480 )
layer = MOAILayer2D.new ()
MOAISim.pushRenderPass ( layer )
viewport = MOAIViewport.new ()
viewport:setSize ( 320, 480 )
viewport:setScale ( 320, 480 )
layer:setViewport ( viewport )

function splash()
logoGfx = MOAIGfxQuad2D.new ()
logoGfx:setTexture ( "cathead.png" )
logoGfx:setRect ( -160, -240, 160, 480)
logo = MOAIProp2D.new ()
logo:setDeck ( logoGfx )
layer:insertProp ( logo )
logo:seekColor ( 0, 0, 0, 0, 0 )
fadeinAction = logo:seekColor ( 1, 1, 1, 1, 5)
callWithDelay ( 5, fadeoutSplash)
end
function callWithDelay ( delay, func,...)

local timer = MOAITimer.new ()
timer:setSpan ( delay )
timer:setListener ( MOAITimer.EVENT_TIMER_LOOP,
function ()
timer:stop ()
timer = nil
func ( unpack ( arg ))
end
)
timer:start ()
end
function fadeoutSplash()
fadeoutAction = logo:seekColor ( 0,0,0,0, 5 )
end

splash()

