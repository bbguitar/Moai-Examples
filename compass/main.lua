MOAISim.openWindow ( "test", 960, 480 )

layer = MOAILayer2D.new ()
MOAISim.pushRenderPass ( layer )

viewport = MOAIViewport.new ()
viewport:setSize ( 960, 480 )
viewport:setScale ( 960, 480 )
layer:setViewport ( viewport )


function onLevelEvent ( deviceId, sensorId, x, y, z )
print ("motion x"..x.." y="..y.." z="..z)
end

if MOAIInputMgr.device.level then
MOAIInputMgr.device.level:setCallback ( onLevelEvent )
end



