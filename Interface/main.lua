while not _G.SCP3008GUI do wait() end

local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer
local character = LP.Character or LP.CharacterAdded:Wait()
while not _G.SCP3008GUI.Interface do wait() end
local GUI = _G.SCP3008GUI.Interface

syn.protect_gui(GUI)
GUI.Parent = CoreGui

-- Constants
local GameObjects = game:GetService("Workspace"):WaitForChild("GameObjects")
local Physical = GameObjects:WaitForChild("Physical")
local Map = Physical:WaitForChild("Map")
local Ground = Map:WaitForChild("Ground")
local Items = Physical:WaitForChild("Items")
local StructureObjects, Consumables, StructureConsumablesMerged = {}, {}, {}

-- Utility Functions
function ReloadGroundItemsList()
  StructureObjects = {}
  Consumables = {}
  StructureConsumablesMerged = {}
  for _,container in pairs(Ground:GetChildren()) do
    if container:FindFirstChild("Items") then
      for _,object in pairs(container.Items:GetChildren()) do
        if object:IsA("Model") and object:FindFirstChild("Base") then
          table.insert(StructureObjects,object)
        end
      end
    end
  end
  for _,item in pairs(Items:GetChildren()) do
    if item:IsA("Model") and item:FindFirstChildWhichIsA("BasePart") then
      table.insert(Consumables,item)
    end
  end
  for i,v in pairs(StructureObjects) do
    table.insert(StructureConsumablesMerged,v)
  end
  for i,v in pairs(Consumables) do
    table.insert(StructureConsumablesMerged,v)
  end

  return StructureObjects, Consumables
end
ReloadGroundItemsList()

-- Interface
local Templates = GUI:WaitForChild("Templates")
local MenuContents = GUI:WaitForChild("Frame"):WaitForChild("MenuContents")
local MenuSelection = GUI:WaitForChild("Frame"):WaitForChild("MenuSelection")

-- Interface Initialization
MenuContents.Visible = true -- False when menu selection has more options
MenuSelection.Visible = false

for i,v in pairs(Templates:GetChildren()) do
  if v:IsA("GuiObject") then
    v.Visible = false
  end
end

for i,v in pairs(MenuContents:GetChildren()) do
  if v:IsA("Frame") then v.Visible = false end
end

for i,v in pairs(GUI:GetDescendants()) do
  if v:IsA("ScrollingFrame") then
    local layout = v:FindFirstChildWhichIsA("UIListLayout") or v:FindFirstChildWhichIsA("UIGridLayout")
    if layout then
      layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local contentSize = layout.AbsoluteContentSize
        v.CanvasSize = UDim2.new(0,0,0,contentSize.Y+5)
      end)
    end
  end
end

-- Interface Core Functionality
local InterfaceOpen = true
UIS.InputBegan:Connect(function(input,gpe)
  if gpe then return end
  if input.KeyCode == Enum.KeyCode.RightAlt then
    InterfaceOpen = not InterfaceOpen
    if InterfaceOpen then
      GUI:WaitForChild("Frame"):TweenPosition(UDim2.new(0.5,0,0.5,0),nil,nil,0.5,true)
    else
      GUI:WaitForChild("Frame"):TweenPosition(UDim2.new(0.5,0,1,GUI:WaitForChild("Frame").Size.Y.Offset),nil,nil,0.5,true)
    end
  end
end)

-- Interface > MenuContents
local BringObjects = MenuContents:WaitForChild("BringObjects")
local BringObjectsOptions = BringObjects:WaitForChild("Options")
local BringObjectsOptionsBring = BringObjectsOptions:WaitForChild("BringItem")
local BringObjectsOptionsReload = BringObjectsOptions:WaitForChild("ReloadList")
local BringObjectsOptionsSelected = BringObjectsOptions:WaitForChild("Selected")
local BringObjectsOptionsCount = BringObjectsOptions:WaitForChild("Count")
local BringObjectsOptionsDistance = BringObjectsOptions:WaitForChild("Distance")
local BringObjectsObjectList = BringObjects:WaitForChild("ObjectList")
local BringObjectsItemList = BringObjects:WaitForChild("ItemList")

local BringObjectsBringingItem = nil
local BringObjectsBringingCounter = 0 -- Internal, must be 0
local BringObjectsBringingCount = 0
local BringObjectsBringingMinimumDistance = 500

BringObjects.Visible = true -- Set visible temporary until a menu exists for selecting multiple options
local currentlyBringing = false

local objectBringingInProgress = false
function callBeginObjectBring()
  if objectBringingInProgress then return end
  if not BringObjectsBringingItem then return end
  if not (BringObjectsBringingCount > 0) then return end
  local hrp = character:FindFirstChild("HumanoidRootPart")
  if not hrp then return end
  local pos = hrp.CFrame
  local movementFunc = character:FindFirstChild("server_PickupSystem"):FindFirstChild("MainEvent")


  local function bringToPosition(item,cf)
    character:MoveTo(item:FindFirstChildWhichIsA("BasePart").Position)
      wait(0.15)
      movementFunc:InvokeServer({
        ["Action"] = "Pickup",
        ["Model"] = item
      });
      wait(0.15)
      character:MoveTo(pos.p)
      wait(0.15)
      movementFunc:InvokeServer({
        ["CameraCFrame"] = CFrame.new(0,0,0,0,0,0,0,0,0,0,0,0),
        ["Action"] = "Drop",
        ["TargetCFrame"] = cf
      });
  end

  objectBringingInProgress = true
  for i,v in pairs(StructureConsumablesMerged) do
    if BringObjectsBringingCounter < BringObjectsBringingCount then
      if (v:FindFirstChildWhichIsA("BasePart") and (v:FindFirstChildWhichIsA("BasePart").Position - pos.p).Magnitude > BringObjectsBringingMinimumDistance) and v.Name == BringObjectsBringingItem then
        BringObjectsBringingCounter = BringObjectsBringingCounter + 1
        bringToPosition(v,pos+Vector3.new(math.random(-10,10),3,math.random(-10,10)))
      end
    else
      break
    end
  end
  objectBringingInProgress = false
end

local BringObjectsOptionsBringDB = false
BringObjectsOptionsBring.MouseButton1Click:Connect(function()
  if BringObjectsOptionsBringDB then return end -- Debounce
  if not BringObjectsBringingItem then return end -- Must select item first
  BringObjectsOptionsBringDB = true
  if objectBringingInProgress then -- Abort
    BringObjectsOptionsCount.Text = "0"
    BringObjectsBringingCount = 0
  else -- Start bringing
    BringObjectsBringingCount = math.ceil(tonumber(BringObjectsOptionsCount.Text) or 0)
    BringObjectsBringingMinimumDistance = math.ceil(tonumber(BringObjectsOptionsDistance.Text) or 500)
    BringObjectsOptionsCount.Text = tostring(BringObjectsBringingCount)
    BringObjectsOptionsDistance.Text = tostring(BringObjectsBringingMinimumDistance)
    BringObjectsOptionsBring.Text = "Abort Bringing"
    callBeginObjectBring()
  end
  wait(1)
  BringObjectsOptionsBring.Text = "Start Bringing"
  BringObjectsOptionsBringDB = false
end)

function BindBringObjectItemSelect(btn)
  btn.MouseButton1Click:Connect(function()
    BringObjectsBringingItem = btn.Name
    BringObjectsOptionsSelected.Text = "Item: "..btn.Name
  end)
end

local itemTemplate = Templates:WaitForChild("ObjectTemplate")
local objectDuplicateList = {}
local itemDuplicateList = {}
function reloadBringObjectItemList()
  ReloadGroundItemsList()
  objectDuplicateList = {}
  itemDuplicateList = {}
  for i,v in pairs(BringObjectsObjectList:GetChildren()) do
    if v:IsA("TextButton") then v:Destroy() end
  end
  for i,v in pairs(BringObjectsItemList:GetChildren()) do
    if v:IsA("TextButton") then v:Destroy() end
  end
  for i,v in pairs(StructureObjects) do
    objectDuplicateList[v.Name] = true
  end
  for i,v in pairs(Consumables) do
    itemDuplicateList[v.Name] = true
  end
  for name,_ in pairs(objectDuplicateList) do
    local temp = itemTemplate:Clone()
    temp.Name = name
    temp.Text = name
    temp.Parent = BringObjectsObjectList
    temp.Visible = true
    BindBringObjectItemSelect(temp)
  end
  for name,_ in pairs(itemDuplicateList) do
    local temp = itemTemplate:Clone()
    temp.Name = name
    temp.Text = name
    temp.Parent = BringObjectsItemList
    temp.Visible = true
    BindBringObjectItemSelect(temp)
  end
end
reloadBringObjectItemList()

BringObjectsOptionsReload.MouseButton1Click:Connect(function()
  BringObjectsOptionsReload.Visible = false
  reloadBringObjectItemList()
  wait(1)
  BringObjectsOptionsReload.Visible = true
end)

LP.CharacterAdded:Connect(function(char)
  character = char
  wait(3)
  reloadBringObjectItemList()
end)
