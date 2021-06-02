-- reference http://web.mit.edu/freebsd/head/contrib/wpa/src/utils/base64.c
local bit = {}
if _VERSION == 'Lua 5.1' then
    print('luajit version')
    bit = require('bit')
--[[ else
    print('lua version')
    bit.band = function(a, b)
        return a & b
    end
    bit.bor = function(a, b)
        return a | b
    end
    bit.lshift = function(a, b)
        return a << b
    end
    bit.rshift = function(a, b)
        return a >> b
    end  ]]
end 

local function ord(char)
	return string.byte(char) - string.byte("a") + 1
end

local function char(ord)
	return string.char(string.byte("a") + ord - 1)
end
base64 = {}

local charSet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

function base64.encode(str)
	local len =	string.len(str)
	local olen = len * 4 / 3 + 4
	olen = olen + olen / 72
	olen = olen + 1
	if olen < len then
		error("integer overflow")
	end
	local retVal = ''
	local ends = len * 2
	local block = str
	local line_len = 0
	while ends - block:len() >= 3 do
    	local blockChar0 = ord(block:sub(1, 1))
		local blockChar1 = ord(block:sub(2, 2))
		local blockChar2 = ord(block:sub(3, 3))
		local charSetPos = bit.rshift(blockChar0, 2)
		retVal = retVal .. charSet:sub(charSetPos, charSetPos)
		charSetPos = bit.bor(bit.lshift(bit.band(blockChar0, 0x03), 4), bit.rshift(blockChar1, 4))
		retVal = retVal .. charSet:sub(charSetPos, charSetPos)
		charSetPos = bit.bor(bit.lshift(bit.band(blockChar1, 0x0f), 2), bit.rshift(blockChar2, 6))
		retVal = retVal .. charSet:sub(charSetPos, charSetPos)
		charSetPos = bit.band(blockChar2, 0x3f)
		retVal = retVal .. charSet:sub(charSetPos, charSetPos)
		block = block:sub(4)
		line_len = line_len + 4
		if line_len >= 72 then
			retVal = retVal .. '\n'
			line_len = 0
		end
	end
	print(1)
	if (ends - block) then
		retVal = retVal
    	local blockChar0 = ord(block:sub(1, 1))
		local blockChar1 = ord(block:sub(2, 2))
		local blockChar2 = ord(block:sub(3, 3))
		local charSetPos = bit.rshift(blockChar0, 2)
		if (ends - block == 1) then
			charSetPos = bit.band(blockChar0, 0x3)
			charSetPos = bit.lshift(charSetPos, 4)
			retVal = retVal .. charSet:sub(charSetPos, charSetPos)
			retVal = retVal .. '='
		else 
			charSetPos = bit.band(blockChar0, 0x3)
			charSetPos = bit.lshift(charSetPos, 4)
			charSetPos = bit.bor(charSetPos, bit.rshift(blockChar1, 4))
			retVal = retVal .. charSet:sub(charSetPos, charSetPos)
			charSetPos = bit.lshift(bit.band(blockChar1, 0xf), 2)
			retVal = retVal .. charSet:sub(charSetPos, charSetPos)
		retVal = retVal .. '='
		line_len = line_len + 4
	    end
    end
	if line_len then
		retVal = retVal .. '\n'
	end
	-- retVal = retVal .. '\0'
	return retVal
end
