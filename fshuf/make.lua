local from = ""
local cat = io.popen("cat ./fshuf.min.lua")
for line in cat:lines() do from = from.."\n"..line end
local out = io.open("./fshuf", "w+")
out:write("#!/usr/bin/lua\n"..from)
out:close()
