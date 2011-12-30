-- INITIALISATION --
print ("loading initialisation")
function init()
--initiliase variables
ball_fixtures = {}
ball_bodies = {}
ball_sprites = {}
wall_fixtures = {}
wall_bodies = {}
wall_sprites = {}
wall_textures = {}
mousedown=false
destroyed=0
c=0
score=0
mouseX=0
mouseY=0
soundon=false

screen_width,screen_height=MOAIEnvironment.getScreenSize()
if screen_width==0 then screen_width=800 end
if screen_height==0 then screen_height=480 end
MOAIUntzSystem.initialize ()
graphics()

end

function graphics()
-- setup graphics
MOAISim.openWindow ( "test", screen_width, screen_height )
viewport = MOAIViewport.new ()
viewport:setSize ( screen_width, screen_height )
viewport:setScale ( screen_width, screen_height )
-- setup all layers
layer_splash = MOAILayer2D.new ()
layer_menu=MOAILayer2D.new()
layer= MOAILayer2D.new ()
layer1= MOAILayer2D.new ()
layer2= MOAILayer2D.new ()
layer_hud= MOAILayer2D.new ()

gamepartition = MOAIPartition.new ()
layer:setPartition ( gamepartition )
partition = MOAIPartition.new ()
layer_splash:setPartition ( partition )

MOAISim.pushRenderPass ( layer2 )
MOAISim.pushRenderPass ( layer1 )
MOAISim.pushRenderPass ( layer )
MOAISim.pushRenderPass ( layer_menu )
MOAISim.pushRenderPass ( layer_hud )
MOAISim.pushRenderPass ( layer_splash )

--load_resources()
end
