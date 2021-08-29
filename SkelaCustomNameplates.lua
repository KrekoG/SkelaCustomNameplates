local showFriendly = false

local Players = {}
local Mobs = {}
local Targets = {}
local Icons = {
	["Druid"] = "Interface\\AddOns\\SkelaCustomNameplates\\Class\\ClassIcon_Druid",
	["Hunter"] = "Interface\\AddOns\\SkelaCustomNameplates\\Class\\ClassIcon_Hunter",
	["Mage"] = "Interface\\AddOns\\SkelaCustomNameplates\\Class\\ClassIcon_Mage",
	["Paladin"] = "Interface\\AddOns\\SkelaCustomNameplates\\Class\\ClassIcon_Paladin",
	["Priest"] = "Interface\\AddOns\\SkelaCustomNameplates\\Class\\ClassIcon_Priest",
	["Rogue"] = "Interface\\AddOns\\SkelaCustomNameplates\\Class\\ClassIcon_Rogue",
	["Shaman"] = "Interface\\AddOns\\SkelaCustomNameplates\\Class\\ClassIcon_Shaman",
	["Warlock"] = "Interface\\AddOns\\SkelaCustomNameplates\\Class\\ClassIcon_Warlock",
	["Warrior"] = "Interface\\AddOns\\SkelaCustomNameplates\\Class\\ClassIcon_Warrior",
}
if SCN_Options == nil then
	SCN_Options = {}
	SCN_Options["toogle"] = true
	SCN_Options["safetarget"] = true
	SCN_Options["click"] = true
	SCN_Options["hp"] = true
	SCN_Options["fifths"] = true
	SCN_Options["pic"] = "barSmall5ths"
	SCN_Options["pvprank"] = true
	SCN_Options["guild"] = true
	SCN_Options["showPets"] = false
	SCN_Options["classification"] = true


end

-----------------------------------my functions



local function scn_print(t)
	DEFAULT_CHAT_FRAME:AddMessage(t)
end

-----------------------------------my functions

-------------------------------------------Slash fuctions
SLASH_CUSTOMNAMEPLATES1 = '/scn';

function SlashCmdList.CUSTOMNAMEPLATES(msg, editbox)
	if msg == "" then
		scn_print("Skela Custom Nameplates:")
		scn_print("-toogle          // Toogle the addon")
		scn_print("-safetarget      // Toogle target safe mode")
		scn_print("-click           // Toogle targeting by nameplates")
		scn_print("-fifths          // Toogle lines by every 20% hp")
		scn_print("-pvprank         // Show pvp ranks!")
		scn_print("-guild           // Show guild names!")
		scn_print("-classification  // Show if the mob is elite or rare!")
		return
	end
	if msg == "toogle" then
		SCN_Options["toogle"] = not SCN_Options["toogle"]
		if SCN_Options["toogle"] then
			scn_print("The addon is turned ON!")
		else
			scn_print("The addon is turned Off!")
		end
		return
	end
	if msg == "safetarget" then
		SCN_Options["safetarget"] = not SCN_Options["safetarget"]
		if SCN_Options["safetarget"] then
			scn_print("Targetsafe radar is turned ON!")
		else
			scn_print("Targetsafe radar is turned Off!")
		end
		return
	end
	if msg == "click" then
		SCN_Options["click"] = not SCN_Options["click"]
		if SCN_Options["click"] then
			scn_print("Targetting by click is ON!")
		else
			scn_print("Targetting by click is Off!")
		end
		return
	end
	if msg == "fifths" then
		SCN_Options["fifths"] = not SCN_Options["fifths"]
		if SCN_Options["fifths"] then
			SCN_Options["pic"] = "barSmall5ths"
			scn_print("Lines every at 20% HP ON!")
		else
			SCN_Options["pic"] = "barSmall"
			scn_print("Lines every at 20% HP Off!")
		end
		return
	end
	if msg == "pvprank" then
		SCN_Options["pvprank"] = not SCN_Options["pvprank"]
		if SCN_Options["pvprank"] then
			scn_print("Showing pvp ranks ON!")
		else
			scn_print("Showing pvp ranks Off!")
		end
		return
	end
	if msg == "guild" then
		SCN_Options["guild"] = not SCN_Options["guild"]
		if SCN_Options["guild"] then
			scn_print("Showing guild ON!")
		else
			scn_print("Showing guild Off!")
		end
		return
	end
	if msg == "classification" then
		SCN_Options["classification"] = not SCN_Options["classification"]
		if SCN_Options["classification"] then
			scn_print("Showing unit classification ON!")
		else
			scn_print("Showing unit classification Off!")
		end
		return
	end
end
-------------------------------------------Slash fuctions

-----------------------------------my functions

local function fillPlayerDB(name)
	if Targets[name] == nil then
		TargetByName(name, true)
		table.insert(Targets, name)
		Targets[name] = "ok"
		if UnitIsPlayer("target") then
			table.insert(Players, name)
			local pvpname = UnitPVPName("target")
			Players[name] = {["class"] = UnitClass("target"),
							["guild"] = GetGuildInfo("target"),
							["pvprank"] =  " "..strsub(pvpname, 0, strfind(pvpname, name)-1)}
		else
			table.insert(Mobs, name)
			Mobs[name] = {["classification"] = UnitClassification("target")}
		end
	end
end
local function GetPVPRank(n)
return n
end
-----------------------------------my functions

local function IsNamePlateFrame(frame)
 local overlayRegion = frame:GetRegions()
  if not overlayRegion or overlayRegion:GetObjectType() ~= "Texture" or overlayRegion:GetTexture() ~= "Interface\\Tooltips\\Nameplate-Border" then
    return false
  end
  return true
end

local function isPet(name)
	PetsRU = {"Рыжая полосатая кошка", "Серебристая полосатая кошка", "Бомбейская кошка", "Корниш-рекс",
	"Ястребиная сова", "Большая рогатая сова", "Макао", "Сенегальский попугай", "Черная королевская змейка",
	"Бурая змейка", "Багровая змейка", "Луговая собачка", "Тараканище", "Анконская курица", "Щенок ворга",
	"Паучок Дымной Паутины", "Механическая курица", "Птенец летучего хамелеона", "Зеленокрылый ара", "Гиацинтовый ара",
	"Маленький темный дракончик", "Маленький изумрудный дракончик", "Маленький багровый дракончик", "Сиамская кошка",
	"Пещерная крыса без сознания", "Механическая белка", "Крошечная ходячая бомба", "Крошка Дымок", "Механическая жаба",
	"Заяц-беляк"}
	for _, petName in pairs(PetsRU) do
		if name == petName then
			return true
		end
	end
	PetsENG = {"Orange Tabby", "Silver Tabby", "Bombay", "Cornish Rex", "Hawk Owl", "Great Horned Owl",
	"Cockatiel", "Senegal", "Black Kingsnake", "Brown Snake", "Crimson Snake", "Prairie Dog", "Cockroach",
	"Ancona Chicken", "Worg Pup", "Smolderweb Hatchling", "Mechanical Chicken", "Sprite Darter", "Green Wing Macaw",
	"Hyacinth Macaw", "Tiny Black Whelpling", "Tiny Emerald Whelpling", "Tiny Crimson Whelpling", "Siamese",
	"Unconscious Dig Rat", "Mechanical Squirrel", "Pet Bombling", "Lil' Smokey", "Lifelike Mechanical Toad", "Disgusting Oozeling"}
	for _, petName in pairs(PetsENG) do
		if name == petName then
			return true
		end
	end
	return false
end
--[[
local function fillPlayerDB(name)
	if Targets[name] == nil then
		TargetByName(name, true)
		table.insert(Targets, name)
		Targets[name] = "ok"
		if UnitIsPlayer("target") then
			local class = UnitClass("target")
			table.insert(Players, name)
			Players[name] = {["class"] = class}
		end
	end
end
]]
function CustomNameplates_OnUpdate()

	if not SCN_Options["toogle"] then
		return
	end
	local frames = { WorldFrame:GetChildren() }
	for _, namePlate in ipairs(frames) do
		if IsNamePlateFrame(namePlate) then
			local HealthBar = namePlate:GetChildren()
			local Border, Glow, Name, Level = namePlate:GetRegions()
			Border:Hide()
			Glow:Hide()


--SCN_Options setup
--			local mouseEnabled = namePlate:IsMouseEnabled()
			if SCN_Options["click"] then
				namePlate:EnableMouse(true)
			else
				namePlate:EnableMouse(false)
			end
--SCN_Options setup
--namePlate
			namePlate:SetWidth(110);
			namePlate:SetHeight(50);
--namePlate
--Healthbar
			HealthBar:SetStatusBarTexture("Interface\\AddOns\\SkelaCustomNameplates\\" .. SCN_Options["pic"])
			HealthBar:ClearAllPoints()
			HealthBar:SetPoint("CENTER", namePlate, "CENTER", 0, -10)
			HealthBar:SetWidth(100)
			HealthBar:SetHeight(10)   --default was 4
			HealthBar:SetAlpha(0.85)

			if HealthBar.bg == nil then
				HealthBar.bg = HealthBar:CreateTexture(nil, "BORDER")
				HealthBar.bg:SetTexture(0,0,0,0.85)
				HealthBar.bg:ClearAllPoints()
				HealthBar.bg:SetPoint("CENTER", namePlate, "CENTER", 0, -10)
				HealthBar.bg:SetWidth(HealthBar:GetWidth() + 1.5)
				HealthBar.bg:SetHeight(HealthBar:GetHeight() + 1.5)
			end
--Healthbar
--ClassIcon
			if namePlate.classIcon == nil then
				namePlate.classIcon = namePlate:CreateTexture(nil, "BORDER")
				namePlate.classIcon:SetTexture(0,0,0,0)
				namePlate.classIcon:ClearAllPoints()
				namePlate.classIcon:SetPoint("RIGHT", Name, "LEFT", -3, -1)
				namePlate.classIcon:SetWidth(12)
				namePlate.classIcon:SetHeight(12)
			end

			if namePlate.classIconBorder == nil then
				namePlate.classIconBorder = namePlate:CreateTexture(nil, "BACKGROUND")
				namePlate.classIconBorder:SetTexture(0,0,0,0.9)
				namePlate.classIconBorder:SetPoint("CENTER", namePlate.classIcon, "CENTER", 0, 0)
				namePlate.classIconBorder:SetWidth(13.5)
				namePlate.classIconBorder:SetHeight(13.5)
			end
			namePlate.classIconBorder:Hide()
			-- namePlate.classIconBorder:SetTexture(0,0,0,0)
			namePlate.classIcon:SetTexture(0,0,0,0)
--ClassIcon
--Guild
			if namePlate.guild == nil and SCN_Options["guild"] then
				namePlate.guild = namePlate:CreateFontString(nil, "ARTWORK")
				namePlate.guild:ClearAllPoints()
				namePlate.guild:SetPoint("CENTER", HealthBar, "CENTER", 0, -10)
				namePlate.guild:SetFontObject(GameFontNormal)
				namePlate.guild:SetFont("Interface\\AddOns\\CustomNameplates\\Fonts\\Ubuntu-C.ttf",13) --13 default
				namePlate.guild:SetText(".");
				namePlate.guild:Hide();
			end
			namePlate.guild:Hide();
--Guild
--PVPRank
			if namePlate.pvprank == nil and SCN_Options["pvprank"]  then
				namePlate.pvprank = namePlate:CreateFontString(nil, "ARTWORK")
				namePlate.pvprank:ClearAllPoints()
				namePlate.pvprank:SetPoint("CENTER", HealthBar, "CENTER", 0, 21)
				namePlate.pvprank:SetFontObject(GameFontNormal)
				namePlate.pvprank:SetTextColor(1,1,1,0.9)
				namePlate.pvprank:SetFont("Interface\\AddOns\\CustomNameplates\\Fonts\\Ubuntu-C.ttf",12)
				namePlate.pvprank:SetText(".");
				namePlate.pvprank:Hide();
			end
			namePlate.pvprank:Hide();
--PVPRank
--Classification
			if namePlate.classification == nil and SCN_Options["classification"] then
				namePlate.classification = namePlate:CreateFontString(nil, "ARTWORK")
				namePlate.classification:ClearAllPoints()
				namePlate.classification:SetPoint("CENTER", HealthBar, "CENTER", 0, -10)
				namePlate.classification:SetFontObject(GameFontNormal)
				namePlate.classification:SetTextColor(1,1,1,0.9)
				namePlate.classification:SetFont("Interface\\AddOns\\CustomNameplates\\Fonts\\Ubuntu-C.ttf",12)
				namePlate.classification:SetText(".");
				namePlate.classification:Hide();
			end
			namePlate.classification:Hide();
--Classification
--Name
			Name:SetFontObject(GameFontNormal)
			Name:SetFont("Interface\\AddOns\\CustomNameplates\\Fonts\\Ubuntu-C.ttf",13)
			Name:SetPoint("BOTTOM", namePlate, "CENTER", 0, -5)
--Name
--Level
			Level:SetFontObject(GameFontNormal)
			Level:SetFont("Interface\\AddOns\\CustomNameplates\\Fonts\\Helvetica_Neue_LT_Com_77_Bold_Condensed.ttf",11) --
			Level:SetPoint("TOPLEFT", Name, "RIGHT", 2, 3.5)
--Level
--Show
			HealthBar:Show()
			Name:Show()
			Level:Show()
--Show

--Colors
			local red, green, blue, _ = Name:GetTextColor()
			-- scn_print(red.." "..green.." "..blue)
			if red > 0.99 and green == 0 and blue == 0 then
				Name:SetTextColor(1,0.4,0.2,0.85)
			elseif red > 0.99 and green > 0.81 and green < 0.82 and blue == 0 then
				Name:SetTextColor(1,1,1,0.85)
			end

			local red, green, blue, _ = HealthBar:GetStatusBarColor()
			if blue > 0.99 and red == 0 and green == 0 then
				HealthBar:SetStatusBarColor(0.2,0.6,1,0.85)
			elseif red == 0 and green > 0.99 and blue == 0 then
				HealthBar:SetStatusBarColor(0.6,1,0,0.85)
			end

			local red, green, blue, _ = Level:GetTextColor()

			if red > 0.99 and green == 0 and blue == 0 then
				Level:SetTextColor(1,0.4,0.2,0.85)
			elseif red > 0.99 and green > 0.81 and green < 0.82 and blue == 0 then
				Level:SetTextColor(1,1,1,0.85)
			end
--Colors
---------------------------------------------------------------------
			local name = Name:GetText()
--Recording target

--[[		if  Players[name] == nil and UnitName("target") == nil and string.find(name, "%s") == nil and string.len(name) <= 12 and Targets[name] == nil then
				fillPlayerDB(name)
				ClearTarget()
			end]]

			if SCN_Options["safetarget"] then
				if  Players[name] == nil and Mobs[name] == nil and UnitName("target") == nil and Targets[name] == nil then
					fillPlayerDB(name)
					ClearTarget()
				end
			else
				if UnitName("target") == nil then
					SCN_CurrentTarget = nil
				else
					SCN_CurrentTarget = UnitName("target")
				end

				if  Players[name] == nil and Mobs[name] == nil and Targets[name] == nil then
					fillPlayerDB(name)
				end

				if SCN_CurrentTarget == nil then
					ClearTarget()
				else
					TargetByName(SCN_CurrentTarget)
				end

			end
--Recording target
--Display Non-combat Pets
			if SCN_Options["showPets"] ~= true then
				if isPet(name) then
					HealthBar:Hide()
					Name:Hide()
					Level:Hide()
				end
			end
--Display Non-combat Pets
			if	Players[name] ~= nil then
--				Name:SetText(Players[name]["pvpname"]);
			end

--Display ClassIcon
			if  Players[name] ~= nil and namePlate.classIcon:GetTexture() == "Solid Texture" and string.find(namePlate.classIcon:GetTexture(), "Interface") == nil then
				namePlate.classIcon:SetTexture(Icons[Players[name]["class"]])
				namePlate.classIcon:SetTexCoord(.078, .92, .079, .937)
				namePlate.classIcon:SetAlpha(0.9)
				namePlate.classIconBorder:Show()
			end
--Display ClassIcon

--Display Guild
			if	Players[name] ~= nil then
				if Players[name]["guild"] ~= nil and SCN_Options["guild"] then
					namePlate.guild:SetText("<"..Players[name]["guild"]..">")
					if (strlen(Players[name]["guild"])>20) then
						namePlate.guild:SetFont("Interface\\AddOns\\CustomNameplates\\Fonts\\Ubuntu-C.ttf",10) --13 default
					else
						namePlate.guild:SetFont("Interface\\AddOns\\CustomNameplates\\Fonts\\Ubuntu-C.ttf",13) --13 default
					end
					namePlate.guild:Show()
				else
					namePlate.guild:Hide()
				end
			end
--Display Guild

--Display Classification
			if	Mobs[name] ~= nil and SCN_Options["classification"] then
				if Mobs[name]["classification"] ~= nil and SCN_Options["classification"] and Mobs[name]["classification"] ~= "normal" then
					namePlate.classification:SetText("<"..Mobs[name]["classification"]..">")
					namePlate.classification:Show()
				else
					namePlate.classification:Hide()
				end
			end
--Display Classification

--Display PVPRank
			if	Players[name] ~= nil then
				if Players[name]["pvprank"] ~= nil and SCN_Options["pvprank"] then
					namePlate.pvprank:SetText(GetPVPRank(Players[name]["pvprank"]))
					namePlate.pvprank:Show()
				else
					namePlate.pvprank:Hide()
				end
			end
--Display PVPRank
		end
	end
end

local f = CreateFrame("frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
	if (SCN_Options["toogle"]) then
		ShowNameplates()
        if (showFriendly) then
            ShowFriendNameplates()
        else
            HideFriendNameplates()
        end
	else
		HideNameplates()
		HideFriendNameplates()
	end
end)
f:SetScript("OnUpdate",CustomNameplates_OnUpdate)
