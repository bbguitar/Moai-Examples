--add_actor(x,y,width,height,density,friction,restitution,actorname,bodytype,texture_image)
--walls
--top
add_actor(0,60,240,5,0.02,0.3,0.1,"Box","Static","wall1.png","False")
--bottom
add_actor(0,-60,240,5,0.02,0.3,0.1,"Box","Static","wall1.png","False")
--left
add_actor(-60,0,5,240,0.02,0.3,0.1,"Box","Static","wall1.png","False")
--right
add_actor(60,0,5,240,0.02,0.3,0.1,"Box","Static","wall1.png","False")

-- static obstacles
add_actor(0,0,10,10,0.02,0.3,0.1,"Box","Static","wall1.png","False")
add_actor(10,0,10,10,0.02,0.3,0.1,"Triangle","Static","","False")

-- bunch of boxes
add_actor(0,0,5,5,0.02,0.3,0.1,"Box","Dynamic","ground.png","False")
add_actor(0,0,5,5,0.02,0.3,0.1,"Box","Dynamic","ground.png","False")
add_actor(0,0,5,5,0.02,0.3,0.1,"Box","Dynamic","ground.png","False")
add_actor(0,0,5,5,0.02,0.3,0.1,"Box","Dynamic","ground.png","False")
add_actor(0,0,5,5,0.02,0.3,0.1,"Box","Dynamic","ground.png","False")

-- bunch of boxes
add_actor(0,0,2,2,0.02,0.3,0.1,"Box","Dynamic","ground.png","False")
add_actor(0,0,2,2,0.02,0.3,0.1,"Box","Dynamic","ground.png","False")
add_actor(0,0,2,2,0.02,0.3,0.1,"Box","Dynamic","ground.png","False")
add_actor(0,0,2,2,0.02,0.3,0.1,"Box","Dynamic","ground.png","False")
add_actor(0,0,2,2,0.02,0.3,0.1,"Box","Dynamic","ground.png","False")
add_actor(0,0,2,2,0.02,0.3,0.1,"Box","Dynamic","ground.png","False")
add_actor(0,0,2,2,0.02,0.3,0.1,"Box","Dynamic","ground.png","False")
add_actor(0,0,2,2,0.02,0.3,0.1,"Box","Dynamic","ground.png","False")

-- bunch of exlodable circles
add_actor(5,5,2,2,0.02,0.3,0.2,"Circle","Dynamic","roundsweet.png","False")
add_actor(5,5,2,2,0.02,0.3,0.2,"Circle","Dynamic","roundsweet.png","False")
add_actor(5,5,2,2,0.02,0.3,0.2,"Circle","Dynamic","roundsweet.png","False")
add_actor(5,5,2,2,0.02,0.3,0.2,"Circle","Dynamic","roundsweet.png","False")
add_actor(5,5,2,2,0.02,0.3,0.2,"Circle","Dynamic","roundsweet.png","False")

-- welded
add_actor(15,-20,5,5,0.02,0.3,0.1,"Circle","Dynamic","christmasball2.png","True")
add_actor(25,-20,5,5,0.02,0.3,0.1,"Circle","Dynamic","christmasball3.png","True")
add_actor(35,-20,5,5,0.02,0.3,0.1,"Circle","Dynamic","christmasball1.png","True")

add_actor(15,-10,5,5,0.02,0.3,0.1,"Circle","Dynamic","christmasball2.png","True")
add_actor(20,-10,5,5,0.02,0.3,0.1,"Circle","Dynamic","christmasball1.png","True")
add_actor(25,-10,5,5,0.02,0.3,0.1,"Circle","Dynamic","christmasball3.png","True")

add_actor(-15,-10,5,5,0.02,0.3,0.1,"Circle","Dynamic","christmasball2.png","True")
add_actor(-20,-10,5,5,0.02,0.3,0.1,"Circle","Dynamic","christmasball1.png","True")
add_actor(-25,-10,5,5,0.02,0.3,0.1,"Circle","Dynamic","christmasball1.png","True")



-- bouncer like pinball
add_actor(5,5,5,5,0.02,0.3,4,"Circle2","Static","bounce.png","False")

-- other bits
add_bridge(0,0,20,20,20)
add_spinner(-10,-20,10,1,"platform1.png")



