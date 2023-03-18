RunScript("WinForm/xml/xml2lua.lua")
print(xml2lua)
RunScript("WinForm/xml/xmlhandler/tree.lua")
local handler = tree:new()
local xmlp = [[
<people>
  <person type="natural">
    <name>Manoel</name>
    <city>Palmas-TO</city>
  </person>
  <person type="legal">
    <name>University of Brasília</name>
    <city>Brasília-DF</city>
  </person>
</people>
]]

local xml = [[
<Form Name="Main"
      X="400" Y="100"
      Width="800" Height="600"
      Background="theme.ui2.lowpoly1" Border="theme.ui2.border"
      Drag="True" Image="jpg, https://raw.githubusercontent.com/G-A-Development-Team/libs/main/1326583.jpg">

    <Panel Name="TitleBar" Parent="Main" 
           Y="-25"
           Width="180" Height="25"
           Background="theme.footer.bg" Border="theme.ui2.border"
           Roundness="4,4,4,0,0"/>

    <Panel Name="ActionBar" Parent="Main"
           X="770" Y="-25"
           Width="30" Height="25"
           Background="theme.footer.bg" Border="theme.ui2.border"
           Roundness="4,4,4,0,0"/>

</Form>
]]

local simple_xml_with_attributes = [[<people>
  <person type="legal">
    <age>42</age>
    <name>Manoela</name>
    <salary>42.1</salary>
    <city>Brasília-DF</city>
    <music like="true"/>
  </person>
  <person type="natural">
    <age>42</age>
    <name>Manoel</name>
    <salary>42.1</salary>
    <city>Palmas-TO</city>
    <music like="true"/>
  </person>
</people>
]]

--Instantiates the XML parser
local parser = xml2lua.parser(tree)
parser:parse(xml)

--Manually prints the table (since the XML structure for this example is previously known)
--for i, p in pairs(tree.root.people.person) do
--	print(i, "Name:", p.name, "City:", p.city, "Type:", p._attr.type)
--end


--xml2lua.printable(tree.root)
function print_attributes(node, parent_key, grandparent_key, great_grandparent_key, great_grandparent_attr, great_grandparent_attr2)
    -- print attributes of current node
	local done = false
    for k, v in pairs(node) do
		if type(v) ~= "table" and done ~= true then
			local n = "none"
			if great_grandparent_attr ~= nil then
				n = tostring(great_grandparent_attr.Name)
			end
			local properties = ""
			for k, v in pairs(node) do
				if string.find(v, " ") and k:lower() == "text" or string.find(v, " ") and k:lower() == "Name" then
					v = string.gsub(v, " ", "_")
				else
					v = string.gsub(v, " ", "")
				end
				properties = properties .. k .. "=" .. v .. " "
				
			end
			print(great_grandparent_attr)
			local usetype = ""
			if great_grandparent_key == nil then
				usetype = grandparent_key
			else
				usetype = great_grandparent_key
			end
			print("----------------------------------------------")
			print("type=" .. usetype .. " " .. properties)
			--print(properties)
			--xml2lua.printable(node)
			print("----------------------------------------------")
			done = true
		end
    end
    
    -- recursively print attributes of child nodes
	for k, v in pairs(node) do
		if type(v) == "table" then
			local attr = v._attr
			print_attributes(v, k, parent_key, grandparent_key, great_grandparent_key, v._attr)
		end
	end
end

print_attributes(tree.root, nil, nil, nil, nil)





--list_items(tree.root, nil)
-- create output string for the given element