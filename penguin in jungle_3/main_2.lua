function process_xml( var, name )

  if not name then name = "anonymous" end
  if "table" ~= type( var ) then
  
	print (name)
	if string.find(name, "x1") then
	actors[counter]["x1"]=tostring(var)
	end
	if string.find(name, "y1") then
	actors[counter]["y1"]=tostring(var)
	end
	if string.find(name, "actorname") then
	actors[counter]["actorname"]=tostring(var)
	end
  else
    -- for tables, recurse through children
    for k,v in pairs( var ) do
      local child
      if 1 == string.find( k, "%a[%w_]*" ) then
        -- key can be accessed using dot syntax
        child = name .. '.' .. k
      else
        -- key contains special characters
        child = name .. '["' .. k .. '"]'
			counter=counter+1
			actors[counter]={x1="",y1="",actorname=""}
			print (counter)
			if counter>1 then 
				node=counter-1
				print ("actor "..node.." x1="..actors[node]["x1"].." created")
				--add_actor(actors[node]["x1"],actors[node]["y1"])
			end
      end
      process_xml( v, child )
    end
  end
end


function loadLevel()

counter = 0
c=0
xml = MOAIXmlParser.parseFile ( "level1.xml" )
actors = {}
process_xml (xml)
	
end

loadLevel()