local error = error
local ipairs = ipairs
local string = string
local table = table
local unpack = unpack
local print = print

local bit = bit or bit32
if bit == nil then
	bit = {}
	local MOD = 2 ^ 32
	local MODM = MOD - 1
	function bit.bxor(a, b)
		local p, c = 1, 0
		while a > 0 and b > 0 do
			local ra, rb = a % 2, b % 2
			if ra ~= rb then
				c = c + p
			end
			a, b, p = (a - ra) / 2, (b - rb) / 2, p * 2
		end
		if a < b then
			a = b
		end
		while a > 0 do
			local ra = a % 2
			if ra > 0 then
				c = c + p
			end
			a, p = (a - ra) / 2, p * 2
		end
		return c
	end
	function bit.band(a, b)
		return (a + b - bit.bxor(a, b)) / 2
	end
	function bit.bor(a, b)
		return MODM - bit.band((MODM - a), (MODM - b))
	end
	function bit.lshift(a, disp)
		if disp < 0 then
			return bit.rshift(a, -disp)
		end
		return a * 2 ^ disp % 2 ^ 32
	end
	function bit.rshift(a, disp)
		if disp < 0 then
			return bit.lshift(a, -disp)
		end
		return math.floor(a % 2 ^ 32 / 2 ^ disp)
	end
end

local utf8 = utf8
if utf8 == nil then
	utf8 = {}
	utf8.char = function(...)
		local buf = {}
		for k, v in ipairs({
			...,
		}) do
			if v < 0 or v > 1114111 then
				error("bad argument #" .. k .. " to char (out of range)", 2)
			end
			local b1, b2, b3, b4 = nil, nil, nil, nil
			if v < 128 then
				table.insert(buf, string.char(v))
			elseif v < 2048 then
				b1 = bit.bor(192, bit.band(bit.rshift(v, 6), 31))
				b2 = bit.bor(128, bit.band(v, 63))
				table.insert(buf, string.char(b1, b2))
			elseif v < 65536 then
				b1 = bit.bor(224, bit.band(bit.rshift(v, 12), 15))
				b2 = bit.bor(128, bit.band(bit.rshift(v, 6), 63))
				b3 = bit.bor(128, bit.band(v, 63))
				table.insert(buf, string.char(b1, b2, b3))
			else
				b1 = bit.bor(240, bit.band(bit.rshift(v, 18), 7))
				b2 = bit.bor(128, bit.band(bit.rshift(v, 12), 63))
				b3 = bit.bor(128, bit.band(bit.rshift(v, 6), 63))
				b4 = bit.bor(128, bit.band(v, 63))
				table.insert(buf, string.char(b1, b2, b3, b4))
			end
		end
		return table.concat(buf, "")
	end
end

local helpers = {}
function helpers.StringToBytes(str)
	local bytes = {
		str:byte(1, -1),
	}
	for i = 1, #bytes do
		bytes[i] = bytes[i] + 12
	end
	return table.concat(bytes, "'")
end
function helpers.StringSplit(str)
	local t = {}
	str:gsub(".", function(b)
		t[#t + 1] = b
	end)
	return t
end
function helpers.SplitBytes(str)
	local index = 0
	local t = {}
	str = str:gsub("255'172", "")
	local assembled = ""
	for chunk in string.gmatch(str, "([^']+)") do
		if index == 1 then
			index = 0
			assembled = assembled .. "'" .. chunk
			table.insert(t, assembled)
		else
			assembled = chunk
			index = index + 1
		end
	end
	return t
end
function helpers.ToBytes(str)
	return str:gsub(".", function(b)
		return "\\" .. b:byte()
	end)
end
function helpers.ToString(bytes)
	return (bytes
		:gsub("\\(%d+)", function(b)
			return b:char()
		end)
		:gsub("\\", ""))
end

local ascp_characters = {
	"\\",
	"0",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
}
local replace_characters = {
	917536,
	917537,
	917538,
	917539,
	917540,
	917541,
	917542,
	917543,
	917544,
	917545,
	917546,
}

local characters = {
	characters = {},
	reverse = {},
}
for i, v in ipairs(ascp_characters) do
	characters.characters[v] = replace_characters[i]
	local corresponding = (helpers.StringToBytes(utf8.char(replace_characters[i])):gsub("255'172'", ""))
	characters.reverse[corresponding] = v
end

local library = {}
function library.encode(str)
	str = helpers.ToBytes(str)
	local encoded = {}
	for i, v in ipairs(helpers.StringSplit(str)) do
		encoded[i] = utf8.char(characters.characters[v])
	end
	return table.concat(encoded, "")
end
function library.decode(str)
	local decoded = {}
	local bytes = helpers.SplitBytes(helpers.StringToBytes(str))
	for i, v in ipairs(bytes) do
		decoded[i] = characters.reverse[v]
	end
	return helpers.ToString(table.concat(decoded, ""))
end
library.helpers = helpers

return library
