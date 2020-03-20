local _, L = ...


L.excludedUIPanelWindows = {}
local excludedUIPanelWindows = L.excludedUIPanelWindows

excludedUIPanelWindows["GameMenuFrame"] = {}
excludedUIPanelWindows["VideoOptionsFrame"] = {}
excludedUIPanelWindows["AudioOptionsFrame"] = {}
excludedUIPanelWindows["InterfaceOptionsFrame"] = {}
excludedUIPanelWindows["HelpFrame"] = {}



-- Protected frames. Cannot Show(), Hide() or SetPosition()
-- during combat lockdown. If removed from UIPanelWindows
-- (even if entered into UISpecialFrames), ToggleGameMenu()
-- will not close it during combat lockdown.

-- # SpellBookFrame is protected from the start!
-- # CollectionsJournal becomes protected when the Blizzard_Collections addon is loaded.
-- # DressUpFrame is not protected, but if you remove it from UIPanelWindows,
--   it won't open during combat lockdown!
--   You are able to set a position during combat lockdown,
--   To avoid it from being closed automatically we have done some tricks...
excludedUIPanelWindows["DressUpFrame"] = {}








-- MerchantType means "MerchantFrame, MailFrame, TradeFrame, InspectFrame or ClassTrainerFrame".
-- TradeSkillType means "TradeSkillFrame, ArchaeologyFrame or PlayerTalentFrame".
L.merchantType = {}
L.merchantType["MerchantFrame"] = true
L.merchantType["MailFrame"] = true
L.merchantType["TradeFrame"] = true
L.merchantType["InspectFrame"] = true
L.merchantType["ClassTrainerFrame"] = true
L.merchantType["GossipFrame"] = true

L.tradeSkillType = {}
L.tradeSkillType["TradeSkillFrame"] = true
L.tradeSkillType["ArchaeologyFrame"] = true
L.tradeSkillType["PlayerTalentFrame"] = true




