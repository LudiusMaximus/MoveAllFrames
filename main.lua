local _, L = ...




local dressUpFrameShown = false

local merchantTypeX = 85
local merchantTypeY = -145

local tradeSkillTypeX = 143
local tradeSkillTypeY = -108


-- A frame to attach the top of all centered frames to.
local centerTop = CreateFrame("Frame")
centerTop:ClearAllPoints()
centerTop:SetPoint("BOTTOM", "ExtraActionButton1", "BOTTOM", 0, 580)
centerTop:SetWidth(1)
centerTop:SetHeight(1)





local function TakeFrame(frameName)
  
  print("TakeFrame", frameName)

  if UIPanelWindows[frameName] then
  
    -- Remove custom frame from UIPanelWindows such that it does not get closed automatically
    UIPanelWindows[frameName] = nil
    -- Insert custom frame into UISpecialFrames such that it gets still closed pressing ESC (ToggleGameMenu()).
    tinsert(UISpecialFrames, frameName)
    
    -- _G[frameName]:ClearAllPoints()
    
    print("|cffff0000TakeFrame", frameName)
  end
end






local function PositionFrame(frame, point, relativeFrameName, relativeFramePoint, X, Y)

  print("|cff00ff00trying to position", frame:GetName(), point, relativeFrameName, relativeFramePoint, X, Y)

  if not frame then
    print("|cffff0000THIS SHOULD NEVER HAPPEN! Called PositionFrame with nil frame!|r")
    return
  end
  
  local frameName = frame:GetName()
  if not frameName then
    print("|cffff0000THIS SHOULD NEVER HAPPEN! Called PositionFrame with nameless frame!|r")
    return
  end
  
  -- SpellBookFrame is the only protected UI Panel Window, which we are never moving in combat lockdown.
  if frame ~= SpellBookFrame and frame ~= CollectionsJournal and frame:IsProtected() then
    print("|cffff0000THIS SHOULD NEVER HAPPEN!", frameName, "is another protected frame!|r")
    return
  elseif (frame == SpellBookFrame or frame == CollectionsJournal) and InCombatLockdown() then
    print("|cffff0000THIS SHOULD NEVER HAPPEN! DeterminePositions() should never try to move", frameName, "in combat lockdown!|r")
    return
  end
  
  frame:ClearAllPoints()
  frame:SetPoint(point, relativeFrameName, relativeFramePoint, X, Y)
end




local function DeterminePositions()

  local X = tradeSkillTypeX

  if SpellBookFrame:IsShown() then
    X = X + SpellBookFrame:GetWidth() + 18 
    if SpellBookSideTabsFrame:IsShown() then
      X = X + 35
    end
  end

  for i, v in pairs(L.tradeSkillType) do
    if _G[i] and _G[i]:IsShown() then
      PositionFrame(_G[i], "TOPLEFT", "UIParent", "TOPLEFT", X, tradeSkillTypeY)
    end
  end
  
  local visibleMerchantType = nil
  for i, v in pairs(L.merchantType) do 
    if _G[i] and _G[i]:IsShown() then
      PositionFrame(_G[i], "TOPLEFT", "UIParent", "TOPLEFT", merchantTypeX, merchantTypeY)
      visibleMerchantType = _G[i]
    end
  end
  
  if CharacterFrame:IsShown() then
    local X = merchantTypeX
    if visibleMerchantType then
      X = X + visibleMerchantType:GetWidth() + 18
    end
    PositionFrame(CharacterFrame, "TOPLEFT", "UIParent", "TOPLEFT", X, merchantTypeY)
  end
  
  if DressUpFrame:IsShown() then
    local X = merchantTypeX
    if visibleMerchantType then
      X = X + visibleMerchantType:GetWidth() + 18
    end
    if CharacterFrame:IsShown() then
      X = X + CharacterFrame:GetWidth() + 18
    end
    PositionFrame(DressUpFrame, "TOPLEFT", "UIParent", "TOPLEFT", X, merchantTypeY)
  end
  
  for i, v in pairs(UIPanelWindows) do    
    if _G[i] and _G[i]:IsShown() and L.merchantType[i] == nil and not L.tradeSkillType[i] and not L.excludedUIPanelWindows[i] then
      print ("TODO: Default position for", i)
      
      PositionFrame(_G[i], "TOP", "centerTop", "TOP", 0, 0)
    end 
  end
end



-- local function DetermineVisibility(f)

  -- if f:IsShown() then
    -- -- print("Opening", f:GetName())
    
    -- -- While the GameMenuFrame is visible, no other UI panels should be shown.
    -- -- We have to manually enforce this for those we removed from UIPanelWindows.
    -- -- if f ~= GameMenuFrame and GameMenuFrame:IsShown() then
      -- -- f:Hide()
    -- -- end
    
  -- end

  -- -- While merchantType is visible, SpellBookFrame and tradeSkillType are mutually exclusive.

-- end








hooksecurefunc("ShowUIPanel", function(f, ...)
    if not f then return end
    print("|cff999999ShowUIPanel", f:GetName(), "|r")  
    -- DetermineVisibility(f)
    DeterminePositions()
    
    if f == DressUpFrame then
      dressUpFrameShown = true
    end
  end )
  
  
hooksecurefunc("HideUIPanel", function(f, ...)
    if not f then return end
    print("|cff999999HideUIPanel", f:GetName(), "|r")
    DeterminePositions()
    
    if f == DressUpFrame then
      dressUpFrameShown = false
      DressUpFrame:Hide()
    end
  end )
  
hooksecurefunc("UpdateUIPanelPositions", function(f, ...)
    print("|cffbbbbbbUpdateUIPanelPositions|r")
    DeterminePositions()
  end )

-- Need these as well to differentiate between SpellBookFrame tabs.
hooksecurefunc(SpellBookSideTabsFrame, "Show", DeterminePositions)
hooksecurefunc(SpellBookSideTabsFrame, "Hide", DeterminePositions)




  
  
  
  
  
  
-- Take frame from UIPanelWindows after PLAYER_ENTERING_WORLD.
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
initFrame:SetScript("OnEvent", function(self, event, ...)

  TakeFrame("MerchantFrame")
  
  -- If I am not doing this, I get an error!
  ShowUIPanel(CharacterFrame)
  HideUIPanel(CharacterFrame)
  TakeFrame("CharacterFrame")
  
  TakeFrame("MailFrame")
  TakeFrame("TradeFrame")
 
  -- Not needed...
  -- UIParent_OnLoad(UIParent)
  -- collectgarbage("collect")
end)











-- Take frame from UIPanelWindows after respective ADDON_LOADED.
local takeFrameAfterAddonLoaded = {
  Blizzard_AuctionHouseUI = "AuctionHouseFrame",
  Blizzard_ArchaeologyUI  = "ArchaeologyFrame",
  Blizzard_InspectUI      = "InspectFrame",
  Blizzard_TalentUI       = "PlayerTalentFrame",
  Blizzard_TradeSkillUI   = "TradeSkillFrame",
  Blizzard_TrainerUI      = "ClassTrainerFrame",
}
local addonLoadedFrame = CreateFrame("Frame")
addonLoadedFrame:RegisterEvent("ADDON_LOADED")
addonLoadedFrame:SetScript("OnEvent", function(self, event, arg1, ...)
  if takeFrameAfterAddonLoaded[arg1] then
    TakeFrame(takeFrameAfterAddonLoaded[arg1])
  end
end)












-- DressUpFrame is not protected and can be moved in combat lockdown.
-- So it is not as bad as SpellBookFrame and CollectionsJournal.
-- Yet, if we remove it from UIPanelWindows, it does not open during combat lockdown.
-- Thus, we want to keep DressUpFrame in UIPanelWindows but still prevent it from being closed automatically.
-- This is how we achive it:

-- Very cool trick by MunkDev: https://www.wowinterface.com/forums/showthread.php?p=325688#post325688
local function StopLastSound()
  -- Play some sound to get a handle.
  local _, handle = PlaySound(SOUNDKIT[next(SOUNDKIT)], "SFX", false)
  if handle then
    -- print("muting sound", handle)
    -- Stop this sound and the previous.
    StopSound(handle-1)
    StopSound(handle)
  end
end

-- Always allow duplicates for sounds!
-- This has the "nice" side effect that you always get sounds
-- even if you open and close your UIPanels very quickly.
hooksecurefunc("PlaySound", function(...)
  -- print("PlaySound", ...)
  local id, channel, forceNoDuplicates, runFinishCallback = ...
  if forceNoDuplicates == false then return end
  StopLastSound()
  PlaySound(id, channel, false, runFinishCallback)
end)

-- DressUpFrame should only be hidden by HideUIPanel()...
hooksecurefunc(DressUpFrame, "Hide", function()
  -- print("Hiding DressUpFrame")
  if dressUpFrameShown and not DressUpFrame:IsShown() then
    -- Stop the closing sound.
    StopLastSound()
    -- Show DressUpFrame again.
    DressUpFrame:Show()
    -- Stop the showing sound.
    StopLastSound()
  end
end)

-- ...or when ESC is pressed.
hooksecurefunc("ToggleGameMenu", function()
  if DressUpFrame:IsShown() then
    HideUIPanel(DressUpFrame)
  end
end)












-- -- local emergencyFrame = CreateFrame("Frame")
-- -- emergencyFrame:SetScript("onUpdate", function(...)

  -- -- print("------------------------------------")
  -- -- for i, v in pairs(UIPanelWindows) do
    -- -- -- print (i, _G[i])
    -- -- if _G[i] and _G[i]:IsProtected() then
      -- -- print(i, "is protected!!!")
    -- -- end 
  -- -- end

-- -- end)