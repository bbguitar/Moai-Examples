MOAISim.openWindow ( "test", 960, 480 )

layer = MOAILayer2D.new ()
MOAISim.pushRenderPass ( layer )

viewport = MOAIViewport.new ()
viewport:setSize ( 960, 480 )
viewport:setScale ( 960, 480 )
layer:setViewport ( viewport )

logger=MOAILogMgr
logger:setLogLevel(MOAILogMgr.LOG_STATUS)
logger:log ("Loaded")

dofile "test.lua"

function onFinish ( task, responseCode )

	print ( "onFinish" )
	print ( responseCode )

	if ( task:getSize ()) then
		contents=( task:getString ())
	else
		print ( "nothing" )
	end
end

task = MOAIHttpTask.new ()

task:setCallback ( onFinish )
task:httpGet ( "www.google.com" )

