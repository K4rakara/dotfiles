#!/usr/bin/lua
function printHelp()
print [[Fshuf 1.0
========================

Shuffles and un-shuffles files by appending and removing prefixes.

Usage:

fshuf [mode] [format]

mode:
- add : Adds a prefix in order to shuffle files.
- mod : Modifies an existing prefix in order to shuffle files.
- rem : Removes an existing prefix.

format:
d | b | B, 1 or more times.
- d : Inserts a random decimal value as part of the prefix.
- b : Inserts a random binary value as part of the prefix.
- B : Inserts a random base 64 value as part of the prefix.]]
end

--Set the random seed based on system time
math.randomseed(os.time())

local base64 = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

function string.split(str, by)
	local toReturn = {}
	local curBuf = ""
	for i = 1, #str do
		local curChar = string.sub(str, i, i)
		if curChar ~= by then
			curBuf = curBuf..curChar
		else
			table.insert(toReturn, curBuf)
			curBuf = ""
		end
	end
	table.insert(toReturn, curBuf)
	return toReturn
end

FormatChar = { type = "" }

function FormatChar:new(from)
	format_char_o = {}
	if from == "d" then format_char_o.type = "decimal"
	elseif from == "b" then format_char_o.type = "binary"
	elseif from == "B" then format_char_o.type = "base64"
	else os.exit("Invalid format type, expected 'd', 'b', or 'b'; Got '"..from.."'.") end
	setmetatable(format_char_o, self)
	self.__index = self
	return format_char_o
end

function FormatChar.generate(self)
	if self.type == "decimal" then
		return ""..math.floor(math.random(0, 9))
	elseif self.type == "binary" then
		return ""..math.floor(math.random(0, 1))
	elseif self.type == "base64" then
		local roll = math.floor(math.random(0, #base64))
		return string.sub(base64, roll, roll)
	end
end

function FormatChar.canOutput(self, v)
	if self.type == "decimal" then
		if tonumber(v) ~= nil then return true else return false end
	elseif self.type == "binary" then
		if v == "0" or v == "1" then return true else return false end
	elseif self.type == "base64" then
		if string.find(base64, v) ~= nil then return true else return false end
	end
end

Format = { chars = {} }

function Format:new(from)
	format_o = { chars = {} }
	for i = 1, #from do table.insert(format_o.chars, FormatChar:new(string.sub(from, i, i))) end
	setmetatable(format_o, self)
	self.__index = self
	return format_o
end

function Format.generate(self)
	local toReturn = ""
	for i = 1, #self.chars do toReturn = toReturn..self.chars[i]:generate(self.chars[i]) end
	return toReturn
end

function parseArgs()
	local toReturn = {
		mode = "add",
		format = nil,
	}
	
	if arg[1] == "add" or arg[1] == "mod" or arg[1] == "rem" then toReturn.mode = arg[1]
	else printHelp() os.exit() end

	if arg[2] ~= nil then toReturn.format = Format:new(arg[2]) else printHelp() os.exit() end

	return toReturn
end

local arguments = parseArgs()

local lsRes = ""

if true then
	local pipe = assert(io.popen("ls . --color=none"))
	for line in pipe:lines() do
		lsRes = lsRes.." "..line
	end
end

local files = string.split(tostring(lsRes), " ")

if arguments.mode == "add" then
	for i = 2, #files do
		os.execute("rename "..files[i].." "..arguments.format:generate(arguments.format).."-"..files[i].." ./"..files[i])
	end
elseif arguments.mode == "mod" then
	for i = 2, #files do
		local curFile = files[i]
		local ok = true
		for j = 1, #arguments.format.chars do
			if not arguments.format.chars[j]:canOutput(string.sub(curFile, j, j)) then ok = false end
		end
		if not ok then print("Warning: '"..curFile.."' does not match the format provided. The file will be skipped.")
		else
			os.execute("rename "..curFile.." "..arguments.format:generate()..string.sub(curFile, #arguments.format.chars + 1).." ".." ./"..curFile)
		end
	end
elseif arguments.mode == "rem" then
	for i = 2, #files do
		local curFile = files[i]
		local ok = true
		for j = 1, #arguments.format.chars do
			if not arguments.format.chars[j]:canOutput(string.sub(curFile, j, j)) then ok = false end
		end
		if not ok then print("Warning: '"..curFile.."' does not match the format provided. The file will be skipped.")
		else
			os.execute("rename "..curFile.." "..string.sub(curFile, #arguments.format.chars + 2).." ".." ./"..curFile)
		end
	end
end
