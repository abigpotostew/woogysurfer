local Util = setmetatable({}, nil)

-- Disable undeclared globals
--[[setmetatable(_G, {
	__newindex = function(_ENV, var, val)
		if var ~= 'tableDict' then
			error(("attempt to set undeclared global \"%s\""):format(tostring(var)), 2)
		else
			rawset(_ENV, var, val)
		end
	end,
	__index = function(_ENV, var)
		if var ~= 'tableDict' then
			error(("attempt to read undeclared global \"%s\""):format(tostring(var)), 2)
		end
	end,
}) ]]--

PI = math.pi
TWO_PI = PI*2.0
HALF_PI = PI/2.0
QTR_PI = HALF_PI/2.0
THR_QTR_PI = 3*PI/4

Util.EPSILON = 0.00001

function Util.DeepCopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

-- Calculates the area of a convex polygon given by the array of coordinates coordArray. Must be counterclockwise.
function Util.CalculatePolygonArea(coordArray)
	local points = {}
	for i = 0, (#coordArray - 1) / 2  do
		table.insert(points, {x = coordArray[i*2 + 1], y = coordArray[i*2 + 2]})
	end
	table.insert(points, {x = points[1], y = points[2]})

	local sum = 0
	for i = 1, (#points) / 2 do
		local p1 = points[i]
		local p2 = points[i+1]
		sum = sum + (p1.x * p2.y - p2.x * p1.y)
	end

	return sum
end

function Util.SumShapeAreas(shapes)
	local area = 0
	for i, shape in ipairs(shapes) do
		area = area + Util.CalculatePolygonArea(shape)
	end
	return area
end

-- Merges two tables, with values from table2 taking precedence over values from table1
function Util.MergeTables(table1, table2)
	local newTable = {}

	if (table1) then
		for key, value in pairs(table1) do
			newTable[key] = value
		end
	end

	if (table2) then
		for key, value in pairs(table2) do
			newTable[key] = value
		end
	end

	return newTable
end

-- Removes a value from an array
function Util.FindAndRemove(tab, item)
	for i, testItem in ipairs(tab) do
		if (testItem == item) then
			table.remove(tab, i)
			return true
		end
	end

	return false
end

function Util.DegToRad(degrees)
	return degrees * math.pi / 180.0
end

function Util.RadToDeg(radians)
	return radians*180.0/math.pi
end

function Util.RemoveAtEnd(event)
	if event.phase =="end" then
		timer.performWithDelay(1, function() event.target:removeSelf() end)
	end
end

function Util.DeclareGlobal(name, value)
	rawset(_G, name, value or {})
end

function Util.UndeclareGlobal(name)
	rawset(_G, name, nil)
end

function Util.GlobalDeclared(name)
	return rawget(_G, name) ~= nil
end

local function denyNewIndex(_ENV, var, val)
	error("Attempt to write undeclared object property: \"" .. tostring(var) .. "\"")
end

local function denyUndefinedIndex(_ENV, var)
	error("Attempt to read undeclared object property: \"" .. tostring(var) .. "\"")
end

function Util.lockObjectProperties(...)
    local arg = {...}
	for _, object in ipairs(arg) do
		local meta = getmetatable(object)
		if (meta) then
			assert(meta.__newindex == nil, "Can't lock object - it already has a __newindex set")
			meta.__newindex = denyNewIndex
		else
			meta = {__newindex = denyNewIndex}
		end
	end
end

function Util.unlockObjectProperties(...)
    local arg = {...}
	for _, object in ipairs(arg) do
		local meta = getmetatable(object)
		assert(meta and meta.__newindex == denyNewIndex, "Can't unlock object - it wasn't locked with lockObjectProperties")
		meta.__newindex = nil
	end
end

function Util.errorOnUndefinedProperty(...)
    local arg = {...}
	for _, object in ipairs(arg) do
		local meta = getmetatable(object)
		if (meta) then
			assert(meta.__index == nil, "Can't set object to error on undefined - it already has an __index set")
			meta.__index = denyUndefinedIndex
		else
			meta = {__index = denyUndefinedIndex}
		end
	end
end

function Util.printProps(obj, message)
	if (message) then
		print(message)
	end
	for k, v in pairs(obj) do
		print("\t", tostring(k) .. ":", v)
	end
end

function Util.lerp(a, b, t)
	return a + (b - a) * t
end

function Util.sign(a)
	if a < 0 then
		return -1
	else
		return 1
	end
end

-- override print() function to improve performance when running on device
-- and print out file and line number for each print
--[[local original_print = print

	print = function(message)
		local info = debug.getinfo(2)
		local source_file = info.source
		--original_print(source_file)
		local debug_path = source_file:match('%a+.lua') ..' ['.. info.currentline ..']'
		original_print(debug_path..": "..message)
	end]]--

function Util.vecToAngle( x, y )
    return math.atan2( y, x )
end


return Util
