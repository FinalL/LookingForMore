--Fonts\\ARIALN.TT ... Fonts\\FRIZQT__.TTF ... Fonts\\skurri.ttf ... Fonts\\MORPHEUS.ttf
LFMAddon = {}
--Slash commands
SLASH_LFM1,SLASH_LFM2 = '/lfm','/lookingformore';
function SlashCmdList.LFM(msg, editbox) 
 if (msg=="show") then
  LFMAddon:ShowWind()
 elseif (msg=="hide") then
  LFMAddon:HideWind()
 elseif (msg=="help") then
  LFMAddon:SendHelp()
 elseif (msg=="reset") then
  LFMAddon:Reset()
 else
  LFMAddon:ShowHide()
 end
 
end

function LFMAddon:Reset()
  LFMOptions=nil
end

function LFMAddon:init(event, addon)
  if(event=="ADDON_LOADED" and addon=="LookingForMore") then
    if (LFMOptions == nil) then
      local top = UIParent:GetTop()/2
      local right = UIParent:GetRight()/2
      right = floor(right+0.5)
      top =   floor(top+0.5)
      LFMOptions = {
          ["WindPos"] = {
            right,
            top
          },
          ["Channel"] = 1,
          ["Run"] = "Dungeon/Raid Name",
          ["Achievement"] = nil,
          ["THD"] = {
            0,      -- T
            0,      -- H
            0       -- D
          },
          ["Visible"] = true
          
      }
      
    end
    if (LFMOptions.Channel==nil) then
      LFMOptions.Channel=1
    end
    if (LFMOptions.Run==nil) then
      LFMOptions.Run="Dungeon/Raid Name"
    end
    if (LFMOptions.THD[1]==nil or LFMOptions.THD[2]==nil or LFMOptions.THD[3]==nil) then
      LFMOptions.THD[1]=0
      LFMOptions.THD[2]=0
      LFMOptions.THD[3]=0
    end
    if(LFMOptions.ilvl==nil)then
      LFMOptions.ilvl=0
    end
    if(LFMOptions.Visible==nil)then
      LFMOptions.Visible=true
    end
    LFMAddon:CreateGUI(MainFrame)
    
    print("|c00ffff00LookingForMore Addon loaded, type '|cFFFF0000/lfm help' |c00ffff00for help. Created by FinalL(Manalow of Sargeras Molten <Psychopathic>)")
  end
  if(event=="PLAYER_LOGOUT") then
    local right=MainFrame:GetRight()
    local top  =MainFrame:GetTop()
    right=floor(right+0.5)
    top  =floor(top+0.5)
    LFMOptions.WindPos[1]=right
    LFMOptions.WindPos[2]=top
    LFMOptions.Channel=chanIDBox:GetNumber()
    LFMOptions.Run=runBox:GetText()
    LFMOptions.Achievement=achBox:GetChecked()
    LFMOptions.THD[1]=tankBox:GetNumber()
    LFMOptions.THD[2]=healBox:GetNumber()
    LFMOptions.THD[3]=dpsBox:GetNumber()
    LFMOptions.ilvl=ilvlBox:GetNumber()
    if MainFrame:IsShown() then
      LFMOptions.Visible=true
    else
      LFMOptions.Visible=false
    end
    --LFMOptions.Saved="SAVED"
  end
end

function LFMAddon:CreateGUI(f)
  local MainWind = LFMAddon:SetWindow(f)
  if LFMOptions.Visible then
      LFMAddon:ShowWind()
    else
      LFMAddon:HideWind()
    end
  --MainWind:Hide()
  local BtnClose = LFMAddon:CreateButton(f, "Button3", "Close", 16,16, "TOPRIGHT",-5,-5,"UIPanelCloseButton")
  local Title = LFMAddon:CreateFont(f,"Font1","|cffffcc00LookingForMore v1","TOP",0,-9,25,nil) 
  local SubmitBtn = LFMAddon:CreateButton(f,"SendButt","Send",49,24,"BOTTOMLEFT",10,10,nil)
  local Run = LFMAddon:CreateFont(f,"Run","|cffffcc00Dungeon/Raid","LEFT",15,20,12,"def")
  local RunBox = LFMAddon:CreateEditBox(f,"runBox",128,32,LFMOptions.Run,"LEFT",115,20,false)
  
  local achText = LFMAddon:CreateFont(f,"achText","|cffffcc00Achievement","BOTTOM",50,15,12,"def")
  local achCheck = LFMAddon:CreateCheckBox(f,"achBox","BOTTOM",103,7,"Check if you wish achievement link to be whispered.",true) 
  achCheck:SetChecked(LFMOptions.Achievement)
  
  local chanText = LFMAddon:CreateFont(f,"chanText","|cffffcc00Channel","BOTTOM",-41,15,12,"def")
  local chanBox = LFMAddon:CreateEditBox(f,"chanIDBox",16,32,nil,"BOTTOM",-2,5,true)
  chanBox:SetNumber(LFMOptions.Channel)
  
  local TankHealDPS = LFMAddon:CreateFont(f,"thdtext","|cffffcc00Tank   Heal   DPS","BOTTOMLEFT",120,60,12,"def")
  local tankBox = LFMAddon:CreateEditBox(f,"tankBox",25,32,LFMOptions.THD[1],"BOTTOMLEFT",123,32,true)
  local healBox = LFMAddon:CreateEditBox(f,"healBox",25,32,LFMOptions.THD[2],"BOTTOMLEFT",163,32,true)
  local dpsBox = LFMAddon:CreateEditBox(f,"dpsBox",25,32,LFMOptions.THD[3],"BOTTOMLEFT",203,32,true)
  
  local ilvlText = LFMAddon:CreateFont(f,"ilvlText","|cffffcc00Item Level","BOTTOMLEFT",15,60,12,"def")
  local ilvlBox = LFMAddon:CreateEditBox(f,"ilvlBox",50,32,LFMOptions.ilvl,"BOTTOMLEFT",20,32,true)
  --Scripts
  SubmitBtn:SetScript("OnClick", function() LFMAddon:SendButt_OnClick() end)
  --[[ DPS CHeck
  local dpsCheck = LFMAddon:CreateCheckBox(f,"dpsCheck","BOTTOM",109,35,"Check if you wish to specify number of melee or ranged dps.",false)
  dpsCheck:SetScript("OnClick", function() 
    if(dpsCheck:GetChecked()==1) then
      print("HAF checkbox") -- Otvorenie okna 
      else 
      print("Nichts") -- Zatvorenie okna
    end
  end)
  --]]
  
end

local AddonFrame = CreateFrame("Frame","MainFrame",UIParent)
AddonFrame:RegisterEvent("ADDON_LOADED")
AddonFrame:RegisterEvent("PLAYER_LOGOUT")
AddonFrame:SetScript("OnEvent",LFMAddon.init)

function LFMAddon:SetWindow(f)
  f:SetFrameStrata("DIALOG")
  f:SetWidth(256)  
  f:SetHeight(128) 
  local x = LFMOptions.WindPos[1]
  local y = LFMOptions.WindPos[2]
  --print("Main frame at x=" .. x .." and y=" ..y )
  f:SetBackdrop( 
    { 
      bgFile = "Interface/DialogFrame/UI-DialogBox-Background", 
      edgeFile = "Interface/DialogFrame/UI-DialogBox-Border", 
      tile = false, tileSize = 0, edgeSize = 32, 
      insets = { left = 4, right = 4, top = 4, bottom = 4 }
    }
  )
  f:SetBackdropColor(0.0,0.0,0.0,1.0)
  f:SetMovable(true)
  f:EnableMouse(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", frame.StartMoving)
  f:SetScript("OnDragStop", frame.StopMovingOrSizing)
  f:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",x,y)
  return (f)
end
function LFMAddon:CreateEditBox(frame,name,width,height,text,anchor,x,y,numeric)
  if (anchor==nil) then
    anchor="BOTTOMLEFT"
  end
  local eBox = CreateFrame("EditBox",name,frame,"InputBoxTemplate")
    eBox:SetFrameStrata("DIALOG")
    eBox:SetPoint(anchor,frame,anchor,x,y)
    eBox:SetWidth(width)
    eBox:SetHeight(height)
    eBox:SetAutoFocus(false)
    eBox:Show()
    if(numeric==true) then
      eBox:SetNumeric()
    end
    if(text~=nil) then
      eBox:SetText(text)
    end
    eBox:EnableKeyboard(true)
    --eBox:RegisterEvent("OnEnterPressed")
    eBox:SetScript("OnEnterPressed",function(self) 
      self:ClearFocus()
    end)
  return(eBox)
end
function LFMAddon:CreateButton(frame, name, text, width, height, anchor, x, y, template)
  if (template==nil) then
    template="OptionsButtonTemplate"
  end
  if (anchor==nil) then
    anchor="BOTTOMLEFT"
  end
  local button = CreateFrame("Button",name,frame,template)
    button:SetPoint(anchor,frame,anchor,x,y)
    button:SetWidth(width)
    button:SetHeight(height)
    button:SetText(text)
  return (button)
end
function LFMAddon:CreateFont(frame,name,text,anchor,x,y,size,font)
  if (anchor==nil) then
    anchor="BOTTOMLEFT"
  end
  if (size==nil) then
    size=15
  end
  if (font==nil) then
   font = "Fonts\\MORPHEUS.ttf"
 end
  if (font=="def") then
   font = "Fonts\\FRIZQT__.TTF"
  end
  local fontString = frame:CreateFontString(name)
    fontString:SetPoint(anchor,frame,anchor,x,y)
    fontString:SetFont(font,size)
    --print("Font set to: "..font)
    --Fonts\\ARIALN.TT ... Fonts\\FRIZQT__.TTF ... Fonts\\skurri.ttf ... Fonts\\MORPHEUS.ttf
    fontString:SetText(text)
  return(fontString)
end
function LFMAddon:CreateWindow(frame,name,width,height,anchor,x,y)
  if (anchor==nil) then
    anchor="BOTTOMLEFT"
  end
  local f = CreateFrame("Frame",name,frame)
    f:SetPoint(anchor,frame,anchor,x,y)
    f:SetWidth(width)
    f:SetHeight(height)
    f:SetBackdrop( 
    { 
      bgFile = "Interface/DialogFrame/UI-DialogBox-Background", 
      edgeFile = "Interface/DialogFrame/UI-DialogBox-Border", 
      tile = false, tileSize = 0, edgeSize = 8, 
      insets = { left = 4, right = 4, top = 4, bottom = 4 }
    }
  )
  f:SetBackdropColor(0.0,0.0,0.0,1.0)
  return(f)
end
function LFMAddon:CreateCheckBox(frame,name,anchor,x,y,tooltip,checked)
  if (anchor==nil) then
    anchor="BOTTOMLEFT"
  end
  local cBox = CreateFrame("CheckButton",name,frame,"ChatConfigCheckButtonTemplate")
    cBox:SetPoint(anchor,frame,anchor,x,y)
    cBox.tooltip = tooltip
    --cBox:SetWidth(16)
    if(checked==true) then
      cBox:SetChecked(1)
    else
      cBox:SetChecked(nil)
    end
  return(cBox)
end
                                                          -- HELP
function LFMAddon:SendHelp()
  print("|c00ffff00You call for help swaglord!")
  print("|c00ffff00->Use '|cFFFF0000/lfm reset|c00ffff00' to reset to default config (You need to use /reload to see effect).")
  print("|c00ffff00->Use '|cFFFF0000/lfm |c00ffff00or |cFFFF0000/lookingformore|c00ffff00' to show/hide the addon window.")
  print("|c00ffff00->Use '|cFFFF0000/lfm show |c00ffff00or |cFFFF0000/lookingformore show|c00ffff00' to show addon window.")
  print("|c00ffff00->Use '|cFFFF0000/lfm hide |c00ffff00or |cFFFF0000/lookingformore hide|c00ffff00' to hide addon window.")
end
                                                          -- END HELP
                                                          --SCRIPTS
    --SLASH COMMANDY
function LFMAddon:ShowWind()
    MainFrame:Show()
  end
  function LFMAddon:HideWind()
    MainFrame:Hide()
  end
  function LFMAddon:ShowHide()
    if MainFrame:IsShown() then
      MainFrame:Hide()
    else
      MainFrame:Show()
    end
  end
                                                                  --SUBMIT
function LFMAddon:SendButt_OnClick()
    if (achBox:GetChecked()==1)then
      achiv="+link achievement"
    else
      achiv=""
    end
    
    local run = runBox:GetText()
    local dps = dpsBox:GetNumber()
    local tank = tankBox:GetNumber()
    local heal = healBox:GetNumber()
    local ilvl = ilvlBox:GetNumber()
    local vystup = ""
    if(tank~=0 or dps~=0 or heal~=0) then
      vystup = ", Need "
    end
    if(tank>0 and tank<=39) then 
      vystup=vystup..tank.."x TANK"
    end
    if(dps>0 and dps<=39) then 
      vystup=vystup.." "..dps.."x DPS"
    end
    if(heal>0 and heal<=39) then 
      vystup=vystup.." "..heal.."x HEAL"
    end
    vystup=vystup.." /w me"
    if(ilvl~=0) then
      vystup=vystup.." with at least "..ilvl.." ilvl"
    end
    --print(LFMOptions.WindPos[1].." "..LFMOptions.WindPos[2])
    --print(LFMOptions.Saved)
    local chan=0
    if(chanIDBox:GetNumber() ~= 0)then
      chan=chanIDBox:GetNumber()
      SendChatMessage("{rt1} LookingForMore "..run..vystup..achiv.." --LFMAddon {rt1}","CHANNEL",nil,chan)
    else
      print("|c00ffff00LFMAddon: You can't send message to channel 0.")
    end
    --print("To channel:".. chan .." {rt1}LookingForMore "..run..vystup..achiv.." --LFMAddon")
    -- hafafg
    --change1
end

  

  
-- funguje: SendChatMessage("Test","CHANNEL",nil,GetChannelName("global"))
-- [
--Button args: frame, name, text, width, height, anchor, x, y, template
  --local Btn1 = LFMAddon:CreateButton(f, "Button1", "HAF", 64, 32, nil, 50, 60, nil) 
  
  --local BtnClose = LFMAddon:CreateButton(f, "Button3", "Close", 16,16, "TOPRIGHT",-5,-5,"UIPanelCloseButton")
  --Font args: frame,name,text,anchor,x,y,size
  --local Nadpis = LFMAddon:CreateFont(f,"Font1","|cffffcc00RDFhc builder v1","TOPLEFT",40,-10,25) 
  -- eBox args: frame,name,width,height, text,anchor,x,y
  --local eBox1 = LFMAddon:CreateEditBox(f,"editBox1",55,32,nil,nil,57,35,true)
  --local eBox2 = LFMAddon:CreateEditBox(f,"editBox2",55,32,nil,nil,120,35,true)
  
  --Btn1:SetScript("OnClick",function() Btn1_OnClick(eBox1:GetNumber(),eBox2:GetNumber()) end)
-- ]

--285056