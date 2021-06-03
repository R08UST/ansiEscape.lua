require('base64')
ansiEscape = {}
local BEL = '\u{007}'
local BS = '\u{008}'
local HT = '\u{009}'
local LF = '\u{00a}'
local FF = '\u{00c}'
local CR = '\u{00d}'
local ESC = '\u{001b}'
local SS2 = ESC .. 'N'
local SS3 = ESC .. 'O'
local DCS = ESC .. 'P'
local CSI = ESC .. '['
local ST = ESC .. '\\'
local OSC = ESC .. ']'
local SOS = ESC .. 'X'
local PM = ESC .. '^'
local APC = ESC .. '_'

local function getOS()
	local binaryFormat = package.cpath:match("%p[\\|/]?%p(%a+)")
    if binaryFormat == "dll" then
        return "Windows"
    elseif binaryFormat == "so" then
        return "Linux"
    elseif binaryFormat == "dylib" then
        return "MacOS"
    end
end

local isAppTerminal = os.getenv("TERM_PROGRAM") == "Apple_Terminal"

function ansiEscape.cursorUp(n)
	if  type(n) == 'nil' then
		n =1
	elseif type(n) ~= 'number' then
		assert("n is not a number")
	end
	return (CSI .. n .. 'A')
end

function ansiEscape.cursorDown(n)
	if  type(n) == 'nil' then
		n =1
	elseif type(n) ~= 'number' then
		assert("n is not a number")
	end
	return (CSI .. n .. 'B')
end

function ansiEscape.cursorForward(n)
	if  type(n) == 'nil' then
		n =1
	elseif type(n) ~= 'number' then
		assert("n is not a number")
	end
	return (CSI .. n .. 'C')
end

function ansiEscape.cursorBack(n)
	if  type(n) == 'nil' then
		n =1
	elseif type(n) ~= 'number' then
		assert("n is not a number")
	end
	return (CSI .. n .. 'D')
end

function ansiEscape.cursorNextLine(n)
	if  type(n) == 'nil' then
		n =1
	elseif type(n) ~= 'number' then
		assert("n is not a number")
	end
	return (CSI .. n .. 'F')
end

function ansiEscape.cursorPrevLine(n)
	if  type(n) == 'nil' then
		n =1
	elseif type(n) ~= 'number' then
		assert("n is not a number")
	end
	return (CSI .. n .. 'F')
end

function ansiEscape.cursorHorizontalAbsolute(n)
    assert(type(n) ~= 'number', 'n is not a number')
    return (CSI .. n .. 'G')
end

function ansiEscape.cursorPosition(n, m)
    assert(type(n) ~= 'number', 'n is not a number')
    assert(type(m) ~= 'number', 'm is not a number')
    return (CSI .. n .. ';' .. m .. 'H')
end

function ansiEscape.eraseInDisplay(n)
	if type(n) == 'nil' then
		n = 0
	elseif type(n) ~= 'number' then
		error("n is not a number")
	end
	return (CSI .. n .. 'J')
end

function ansiEscape.eraseInLine(n)
	if type(n) == 'nil' then
		n = 0
	elseif type(n) ~= 'number' then
		error("n is not a number")
	end
	return (CSI .. n .. 'K')
end

function ansiEscape.scrollUp(n)
	if type(n) == 'nil' then
		n = 0
	elseif type(n) ~= 'number' then
		error("n is not a number")
	end
	return (CSI .. n .. 'S')
end

function ansiEscape.scrollDown(n)
	if type(n) == 'nil' then
		n = 0
	elseif type(n) ~= 'number' then
		error("n is not a number")
	end
	return (CSI .. n .. 'T')
end

function ansiEscape.scrollUp(n)
	if type(n) == 'nil' then
		n = 0
	elseif type(n) ~= 'number' then
		error("n is not a number")
	end
	return (CSI .. n .. 'S')
end

function ansiEscape.horizontalVerticalPosition(n, m)
    assert(type(n) ~= 'number', 'n is not a number')
    assert(type(m) ~= 'number', 'm is not a number')
    return (CSI .. n .. ';' .. m .. 'f')
end

function ansiEscape.selectGraphicRendition(n)
    assert(type(n) ~= 'number', 'n is not a number')
	return (CSI .. n .. 'm')
end

ansiEscape.auxPortOn = CSI .. '5i'

ansiEscape.auxPortOff = CSI .. '4i'

ansiEscape.deviceStatusReport = CSI .. '6n'

ansiEscape.cursorSavePosition= CSI .. (isAppTerminal and 7 or 's')

ansiEscape.cursorRestorePosition = CSI .. (isAppTerminal and 8 or 'u')

ansiEscape.showCursor= CSI .. '?25h'

ansiEscape.hideCursor = CSI .. '?25l'

ansiEscape.enableAlternativeScreenBuffer = CSI .. '?1049h'

ansiEscape.disableAlternativeScreenBuffer = CSI .. '?1049l'

ansiEscape.enableBracketedPasteMode = CSI .. '?2004l'

ansiEscape.disableBracketedPasteMode = CSI .. '?2004l'

ansiEscape.resetState = ESC .. 'c'

ansiEscape.SGR = {
	reset = CSI .. '0m',
	bold = CSI .. '1m',
	faint = CSI .. '2m',
	italic = CSI .. '3m',
	underline= CSI .. '4m',
	showBlink = CSI .. '5m',
	rapidBlink = CSI .. '6m',
	invert = CSI .. '7m',
	hide = CSI .. '8m',
	strike = CSI .. '9m',
	reveal = CSI .. '28m',
	-- foreground
    black   = CSI .. '30m',
    red     = CSI .. '31m',
    green   = CSI .. '32m',
    yellow  = CSI .. '33m',
    blue    = CSI .. '34m',
    magenta = CSI .. '35m',
    cyan    = CSI .. '36m',
    white   = CSI .. '37m',
    -- background
    onblack   = CSI .. '40m',
    onred     = CSI .. '41m',
    ongreen   = CSI .. '42m',
    onyellow  = CSI .. '43m',
    onblue    = CSI .. '44m',
    onmagenta = CSI .. '45m',
    oncyan    = CSI .. '46m',
    onwhite   = CSI .. '47m',

}
-- reference https://github.com/sindresorhus/ansi-escapes
function ansiEscape.cursorTo(x, y)
    if type(x) ~= 'number' then
    	error("invaild input type")
    end
    if type(y) ~= 'number' then
    	return CSI .. (x + 1) ..'G'
    end
    return CSI .. (y + 1) .. ';' .. (x + 1) ..'H'
end

function ansiEscape.cursorMove(x, y)
    if type(x) ~= 'number' then
    	error("invaild input type")
    end
    retVal = ''
    if x < 0 then
    	retVal = retVal .. CSI .. (-x) .. 'D'
    elseif x > 0 then
    	retVal = retVal .. CSI .. x .. 'C'
    end
    if y < 0 then
    	retVal = retVal .. CSI .. (-y) .. 'A'
    elseif y > 0 then
    	retVal = retVal .. CSI .. y .. 'B'
    end
    return retVal
end

ansiEscape.clearTerm = getOS() == 'Windows' and (ansiEscape.eraseInDisplay(2) .. CSI .. '0f') or (ansiEscape.eraseInDisplay(2) .. CSI .. '3J' .. CSI .. 'H')

function ansiEscape.link(text, url)
	return OSC .. '8;;' .. url .. BEL .. text .. OSC .. '8;;' .. BEL
end

function ansiEscape.itermImage(buffer, opt)
	retVal = (OSC .. '1337;File=inline=1')
	if opt['width'] ~= nil  then
		retVal = retVal .. ';width=' .. opt['width']
	end
	if opt['height'] ~= nil  then
		retVal = retVal .. ';height=' .. opt['width']
	end
	if opt['preserveAspectRatio'] == false then
		retVal = retVal .. ';preserveAspectRatio=0'
	end
	return retVal .. ':' .. base64.encode(buffer) .. BEL
end
