--add_actor(x,y,width,height,density,friction,restitution,actorname,bodytype,texture_image)
--walls
add_actor(0,-20,80,5,0.02,0.3,0.1,"Box","Static","cathead.png")
add_actor(0,20,80,5,0.02,0.3,0.1,"Box","Static","cathead.png")
add_actor(-10,0,5,80,0.02,0.3,0.1,"Box","Static","cathead.png")
add_actor(20,0,5,80,0.02,0.3,0.1,"Box","Static","cathead.png")

add_actor(0,0,10,10,0.02,0.3,0.1,"Circle","Dynamic","cathead.png")

drawHills(2,10,-20)