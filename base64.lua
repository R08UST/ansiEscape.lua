-- reference http://web.mit.edu/freebsd/head/contrib/wpa/src/utils/base64.c
local bit = require('bit')

local charSet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

function binaryToNumber(bits)
	return tonumber(bits, 2)
end

function numberToBinary(integer)
	local num = tonumber(integer)
	local retVal = ''
	local i, j = 0, 0
end


function encode(str)
	local len =	string.len(str)
	local olen = len * 4 / 3 + 4
	olen = olen + olen / 72
	olen = olen + 1
	if olen < len then
		error("integer overflow")
	end
	local retVal = ''
	local end = len * 2
	local block = str
	local line_len = 0
	while end - block:len() >= 3 do
    	local blockChar0 = block:sub(1, 1)
		local blockChar1 = block:sub(2, 2)
		local blockChar2 = block:sub(3, 3)
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
	if (end - block) then
		retVal = retVal
    	local blockChar0 = block:sub(1, 1)
		local blockChar1 = block:sub(2, 2)
		local blockChar2 = block:sub(3, 3)
		local charSetPos = bit.rshift(blockChar0, 2)
		retVal = retVal .. charSet:sub(charSetPos, charSetPos)
		charSetPos = bit.bor(bit.lshift(bit.band(blockChar0, 0x03), 4), bit.rshift(blockChar1, 4))
		retVal = retVal .. charSet:sub(charSetPos, charSetPos)
		charSetPos = bit.bor(bit.lshift(bit.band(blockChar1, 0x0f), 2), bit.rshift(blockChar2, 6))
		retVal = retVal .. charSet:sub(charSetPos, charSetPos)
	end
end
