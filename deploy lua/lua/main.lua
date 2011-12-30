print ("Loading environment")
dofile("environment.lua")

screen_width,screen_height=MOAIEnvironment.getScreenSize()
if screen_width==0 then screen_width=800 end
if screen_height==0 then screen_height=480 end

MOAISim.openWindow ( "test", screen_width, screen_height )
viewport = MOAIViewport.new ()
viewport:setSize ( screen_width, screen_height )
--viewport:setScale ( screen_width, screen_height )

layer = MOAILayer2D.new ()
MOAISim.pushRenderPass ( layer )

viewport = MOAIViewport.new ()
viewport:setSize ( screen_width,screen_height )
viewport:setScale ( screen_width,screen_height)
layer:setViewport ( viewport )

function onFinish ( task, responseCode )

	print ( "onFinish" )
	print ( responseCode )

	if ( task:getSize ()) then
		filecontents=( task:getString ())
		--print (filecontents)
		local file = io.open("download.lua", "w")
		file:write(filecontents)
		file:close()
		dofile ("download.lua")
	else
		print ( "nothing" )
	end
end

print ("Loading from internet "..urlLua)
task = MOAIHttpTask.new ()
task:setCallback ( onFinish )
task:httpGet ( urlLua )