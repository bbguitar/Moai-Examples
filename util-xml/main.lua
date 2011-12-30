function print_r (t, indent)
  local indent=indent or ''
  for key,value in pairs(t) do
    io.write(indent,'[',tostring(key),']') 
    if type(value)=="table" then io.write(':\n') print_r(value,indent..'\t')
    else io.write(' = ',tostring(value),'\n') end
  end
end

xml = MOAIXmlParser.parseFile ( "level1.xml" )
actors = {}

print ("calling print_r")
print_r(xml)
print ("called print_r")