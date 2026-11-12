local Number = require("../src/GMLK/Number")
local Time = require("../src/GMLK/Time")
local RemoteGuard = require("../src/GMLK/RemoteGuard")

assert(Number.Abbreviate(1250000, 2) == "1.25M")
assert(Number.Abbreviate(-1500, 1) == "-1.5K")
assert(Number.ParseAbbreviated("1.25M") == 1250000)
assert(Number.ParseAbbreviated("not a number") == nil)
assert(Number.Commas(1234567) == "1,234,567")
assert(not pcall(Number.Abbreviate, math.huge))

assert(Time.FormatDuration(3672) == "1:01:12")
assert(Time.Relative(100, 160) == "1 minute ago")
assert(Time.Relative(160, 100) == "in 1 minute")
assert(not pcall(Time.FormatDuration, -1))

local Handler = RemoteGuard.Wrap({ RemoteGuard.Number(1, 1) }, function(_, Amount)
	return Amount + 1
end)

assert(Handler({}, 1) == 2)
local Invalid, Reason = Handler({}, 2)
assert(Invalid == nil and Reason == "Invalid arguments")

assert(RemoteGuard.Check({ RemoteGuard.String(2, 4) }, "okay"))
assert(not RemoteGuard.Check({ RemoteGuard.String(2, 4) }, "x"))
assert(not RemoteGuard.Check({ RemoteGuard.Number(0, 10) }, 0 / 0))
assert(not RemoteGuard.Check({ RemoteGuard.Number(0, 10) }))
assert(not RemoteGuard.Check({ RemoteGuard.Boolean() }, true, false))
assert(RemoteGuard.Check({ RemoteGuard.Optional(RemoteGuard.Boolean()) }, nil))

local Called = false
local Protected = RemoteGuard.Wrap({ RemoteGuard.Number(1, 5) }, function(_, Amount)
	Called = true
	return Amount
end, function(_, Amount)
	return Amount > 2
end)

local Denied, DenialReason = Protected({}, 2)
assert(Denied == nil and DenialReason == "Not allowed" and not Called)
assert(Protected({}, 3) == 3 and Called)

print("Utility checks passed")
