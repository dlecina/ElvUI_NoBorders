----------------------------------------
-- Setup
---

std = 'lua51'

----------------------------------------
-- Path Exclusions
---

exclude_files = {
	".luacheckrc",
	".docs",
}

----------------------------------------
-- Ignored Warnings
-- https://manpages.debian.org/testing/lua-check/luacheck.1.en.html#LIST_OF_WARNINGS
---

ignore = {
	"2*", -- Unused
	"631", -- Line Length
}

----------------------------------------
-- Read-Only Globals
---

read_globals = {
	-- WoW API
	"GetAddOnMetadata",
	"GetLocale",

	-- Libraries
	"LibStub",
}
