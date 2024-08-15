local E, L, V, P, G = unpack(ElvUI);
local CT = E:NewModule("NoBorders", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0");
local EP = LibStub("LibElvUIPlugin-1.0")
local addon, ns = ...

--Cache global variables
local pairs, ipairs = pairs, ipairs
local tinsert, tsort = table.insert, table.sort
local format = string.format

local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata

CT.Version = GetAddOnMetadata(addon, "Version")
CT.Title = "|cff4beb2cNoBorders|r"
CT.Configs = {}

P["NoBorders"] = {}
V["NoBorders"] = {}

local Tweaks = {
	["Misc"] = {
		{"RaidControl", L["Allows you to change template of the Raid Control button or hide it altogether."]},
		{"NoBorders", L["Attempts to remove borders on all ElvUI elements. This doesn't work on all statusbars, so some borders will be kept intact."]},
	},
}

local Authors = {
	{"Blazeflack", {
		"NoBorders",
		"RaidControl",
	}},
}

local linebreak = "\n"
local function GetTweaksAsString(tweaks)
	local tweaksString = ""
	local temp = {}

	for _, tweak in pairs(tweaks) do
		tinsert(temp, tweak)
	end
	tsort(temp)

	for _, tweak in ipairs(temp) do
		tweaksString = tweaksString..tweak..linebreak
	end

	return tweaksString
end

--Copied from ElvUI
local function RGBToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return format("%02x%02x%02x", r*255, g*255, b*255)
end

function CT:ColorStr(str, r, g, b)
	local hex
	local coloredString

	if r and g and b then
		hex = RGBToHex(r, g, b)
	else
		hex = RGBToHex(75/255, 235/255, 44/255)
	end

	coloredString = "|cff"..hex..str.."|r"
	return coloredString
end

local function buildCategory(category, groupName)
	E.Options.args.NoBorders.args[category] = {
		order = 100,
		type = "group",
		name = groupName,
		childGroups = "tab",
		args = {
			header = {
				order = 1,
				type = "header",
				name = CT:ColorStr(L["Tweaks"]),
			},
			description = {
				order = 2,
				type = "description",
				name = format(L["Some tweaks may provide customizable options when enabled. If so then they will appear in the '%s' field below."], L["Options"]),
			},
			tweaks = {
				order = 3,
				type = "group",
				name = "",
				guiInline = true,
				args = {},
			},
			spacer = {
				order = 4,
				type = "description",
				name = "",
			},
			options = {
				order = 5,
				type = "group",
				name = CT:ColorStr(L["Options"]),
				args = {},
			},
		},
	}
end

function CT:ConfigTable()
	E.Options.args.NoBorders = {
		order = 100,
		type = "group",
		name = CT.Title,
		args = {
			header1 = {
				order = 1,
				type = "header",
				name = format(L["%s version %s by dlecina"], CT.Title, CT:ColorStr(CT.Version)),
			},
			description1 = {
				order = 2,
				type = "description",
				name = format(L["%s is a reduced version of CustomTweaks, a collection of various tweaks for ElvUI."], CT.Title),
			},
			spacer1 = {
				order = 3,
				type = "description",
				name = "\n",
			},
			header2 = {
				order = 4,
				type = "header",
				name = CT:ColorStr(L["Information / Help"]),
			},
			description2 = {
				order = 5,
				type = "description",
				name = L["Please use the following links if you need help or wish to know more about this AddOn."],
			},
			addonpage = {
				order = 6,
				type = "input",
				width = "full",
				name = L["AddOn Description / Download"],
				get = function(info) return "https://www.curseforge.com/wow/addons/elvui-noborders" end,
				set = function(info) return "https://www.curseforge.com/wow/addons/elvui-noborders" end,
			},
			tickets = {
				order = 7,
				type = "input",
				width = "full",
				name = L["Report Bugs / Request Tweaks"],
				get = function(info) return "https://github.com/dlecina/ElvUI_NoBorders/issues" end,
				set = function(info) return "https://github.com/dlecina/ElvUI_NoBorders/issues" end,
			},
			credit = {
				order = -1,
				type = "group",
				name = L["Credit"],
				args = {},
			},
		},
	}

	local n = 0
	for i = 1, #Authors do
		local author = Authors[i][1]
		local tweaks = Authors[i][2]
		n = n + 1
		E.Options.args.NoBorders.args.credit.args[author.."Header"] = {
			order = n,
			type = "header",
			name = CT:ColorStr(author),
		}
		n = n + 1
		E.Options.args.NoBorders.args.credit.args[author.."Desc"] = {
			order = n,
			type = "description",
			name = format(L["%s is the author of the following tweaks:"], author).."\n"
		}
		n = n + 1
		E.Options.args.NoBorders.args.credit.args[author.."List"] = {
			order = n,
			type = "description",
			name = GetTweaksAsString(tweaks),
		}
	end

	for cat, tweaks in pairs(Tweaks) do
		buildCategory(cat, L[cat.." Tweaks"])
		for _, tweak in pairs(tweaks) do
			local tName = tweak[1]
			local tDesc = tweak[2]
			E.Options.args.NoBorders.args[cat].args.tweaks.args[tName] = {
				type = "toggle",
				name = CT:ColorStr(tName),
				desc = tDesc,
				descStyle = "inline",
				get = function(info) return E.private["NoBorders"][tName] end,
				set = function(info, value) E.private["NoBorders"][tName] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			}
		end
	end

	for _, func in pairs(CT.Configs) do func() end
end

function CT:Initialize()
	EP:RegisterPlugin(addon, CT.ConfigTable)
end

local function InitializeCallback()
	CT:Initialize()
end

E:RegisterModule(CT:GetName(), InitializeCallback)
