-- SPLASH --
print ("loading splash")
function splash()
--layer_splash = MOAILayer2D.new ()
--MOAISim.pushRenderPass ( layer_splash )

layer_splash:setViewport ( viewport )

partition = MOAIPartition.new ()
layer_splash:setPartition ( partition )

logoGfx = MOAIGfxQuad2D.new ()
logoGfx:setTexture ( "images/splash.png" )
logoGfx:setRect ( screen_width/2*-1, screen_height/2*-1, screen_width/2, screen_height/2)

logo = MOAIProp2D.new ()
logo:setDeck ( logoGfx )
layer_splash:insertProp ( logo )
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
setup_menu()
menu()
end
