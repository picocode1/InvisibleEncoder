local error = error
local ipairs = ipairs
local string = string
local table = table
local unpack = unpack
local print = print

--// bit
local bit = {}

local MOD = 2^32
local MODM = MOD-1

function bit.bxor(a,b)
    local p,c=1,0
    while a>0 and b>0 do
        local ra,rb=a%2,b%2
        if ra~=rb then c=c+p end
        a,b,p=(a-ra)/2,(b-rb)/2,p*2
    end
    if a<b then a=b end
    while a>0 do
        local ra=a%2
        if ra>0 then c=c+p end
        a,p=(a-ra)/2,p*2
    end
    return c
end

function bit.band(a,b) 
  return ((a+b) - bit.bxor(a,b))/2 
end

function bit.bor(a,b)  
    return MODM - bit.band(MODM - a, MODM - b) 
end

function bit.lshift(a, disp)
  if disp < 0 then return bit.rshift(a,-disp) end
  return (a * 2^disp) % 2^32
end

function bit.rshift(a,disp) 
  if disp < 0 then return bit.lshift(a,-disp) end
  return math.floor(a % 2^32 / 2^disp)
end

local function stringtorelabs(str, ...)
    local args = {...}
    for k, v in ipairs(args) do
        v = v > 0 and v or #str + v + 1
        if v < 1 or v > #str then
            error("bad index to string (out of range)", 3)
        end
        args[k] = v
    end
    return unpack(args)
end

local function utf8_char(...)
    local buf = {}
    for k, v in ipairs {...} do
        if v < 0 or v > 0x10FFFF then
            error("bad argument #" .. k .. " to char (out of range)", 2)
        end

        local b1, b2, b3, b4 = nil, nil, nil, nil
        if v < 0x80 then
            table.insert(buf, string.char(v))
        elseif v < 0x800 then
            b1 = bit.bor(0xC0, bit.band(bit.rshift(v, 6), 0x1F))
            b2 = bit.bor(0x80, bit.band(v, 0x3F))
            table.insert(buf, string.char(b1, b2))
        elseif v < 0x10000 then
            b1 = bit.bor(0xE0, bit.band(bit.rshift(v, 12), 0x0F))
            b2 = bit.bor(0x80, bit.band(bit.rshift(v, 6), 0x3F))
            b3 = bit.bor(0x80, bit.band(v, 0x3F))
            table.insert(buf, string.char(b1, b2, b3))
        else
            b1 = bit.bor(0xF0, bit.band(bit.rshift(v, 18), 0x07))
            b2 = bit.bor(0x80, bit.band(bit.rshift(v, 12), 0x3F))
            b3 = bit.bor(0x80, bit.band(bit.rshift(v, 6), 0x3F))
            b4 = bit.bor(0x80, bit.band(v, 0x3F))
            table.insert(buf, string.char(b1, b2, b3, b4))
        end
    end
    return table.concat(buf, "")
end

local base = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function Pog64Encode(data)
    return ((data:gsub('.', function(x) 
        local r,bb ='',x:byte()
        for i=16,1,-1 do r=r..(bb%2^i-bb%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return base:sub(c+1,c+1)
    end)..({ '', '??', '?' })[#data%3+1])
end

local function Pog64Decode(data)
    data = string.gsub(data, '[^'..base..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '?') then return '' end
        local r,f='',(base:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,16 do c=c+(x:sub(i,i)=='1' and 2^(16-i) or 0) end
            return string.char(c)
    end))
end

--// Main
local Library = {}

local function StringToBytes(str)
    local bytes = { str:byte(1, -1)}
    for i = 1, #bytes do
        bytes[i] = bytes[i] + 12
    end
    return table.concat(bytes, "'")
end

local function BytesToString(str)
    local function gsub(c)return string.char(c - 12) end
    return str:gsub("(%d+)'?", gsub) 
end

local function StringSplit(String)
    local tbl = {}
    String:gsub(".", function(b)
        table.insert(tbl, b)
    end)
    return tbl
end

--1   255'172'141'148
--2   172'141'145'255
--3   141'152'255'172
--4   152'255'172'141
--5 

--1   255'172'141'148  H
--2   255'172'141'145  E
--3   255'172'141'152  L
--4   255'172'141'152  L
--5 	255'172'141'155  O

--[[
  1: 255'
  2: 172'
  3: 141'// Changes
  4: ANY
]]

local function SplitBytes(inputstr)
    local index = 0
  	local Table = {}
    
    inputstr = inputstr:gsub("255'172", "")
    local Assembled = ""
  	for str in string.gmatch(inputstr, "([^']+)") do
       if index == 1 then
          index = 0
          Assembled = Assembled.."'"..str
          table.insert(Table, Assembled)
       else
          Assembled = str
          index = index + 1
       end

       print(str)
  	end

  	return Table
end

local ASCII_Characters = {" ","!","\"","#","$","%","&","'","(",")","*","+",",","-",".","/","0","1","2","3","4","5","6","7","8","9",":",";","<","=",">","?","@","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","[","\\","]","^","_","`","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","{","|","}","~"}

local REPLACE_Characters = {536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611, 612, 613, 614, 615, 616, 617, 618, 619, 620, 621, 622, 623, 624, 625, 626, 627, 628, 629, 630}

local CHARACTERS_Table = {}
local REVERSE_Table = {}

for i, v in ipairs(ASCII_Characters) do
    local num = tonumber("917"..REPLACE_Characters[i])
    CHARACTERS_Table[v] = num
    local CorrectByte = StringToBytes(utf8_char(num)):gsub("255'172'", "")

    REVERSE_Table[CorrectByte] = v
end

function Library.encode(String)
    String = String
    local EncodedTable = {} 

    for i, v in ipairs(StringSplit(String)) do
       EncodedTable[i] = utf8_char(CHARACTERS_Table[v])
    end
    return table.concat(EncodedTable, "")
end


function Library.decode(String)
    local DecodedTable = {}
    local Bytes = SplitBytes(StringToBytes(String))

    for i,v in pairs(Bytes) do
      DecodedTable[i] = REVERSE_Table[v]
    end
    
    return table.concat(DecodedTable, "")
end

function Library.pog64(String)
   return Pog64Encode(String)
end

function Library.unpog64(String)
   return Pog64Decode(String)
end

return Library
