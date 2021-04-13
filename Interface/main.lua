local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local GUI = _G.SCP3008GUI.Interface
local LP = game:GetService("Players").LocalPlayer
local character = LP.Character or LP.CharacterAdded:Wait()
while not GUI do wait() end

syn.protect_gui(GUI)
GUI.Parent = game:GetService("CoreGui")

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
  for i,v in pairs(StructureObjects:GetChildren()) do
    table.insert(StructureConsumablesMerged,v)
  end
  for i,v in pairs(Consumables:GetChildren()) do
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

local BringObjectsBringing = false
local BringObjectsBringingItem = nil
local BringObjectsBringingCounter = 0 -- Internal, must be 0
local BringObjectsBringingCount = 0
local BringObjectsBringingDistance = math.huge()

BringObjects.Visible = true -- Set visible temporary until a menu exists for selecting multiple options

function callBeginObjectBring()
  if not BringObjectsBringing then return end
  if not BringObjectsBringingItem then return end
  if not BringObjectsBringingCount > 0 then return end
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

  for i,v in pairs(StructureConsumablesMerged) do
    if (v:FindFirstChildWhichIsA("BasePart").Position - pos.p).Magnitude < BringObjectsBringingDistance then
      if BringObjectsBringingCounter < BringObjectsBringingCount then
        BringObjectsBringingCounter = BringObjectsBringingCounter + 1
        bringToPosition(v,pos+Vector3.new(math.random(-3,3),-3,math.random(-3,3)))
      end
    end
  end
end

BringObjectsOptionsBring.MouseButton1Click:Connect(function()
  if not BringObjectsBringingItem then return end
  BringObjectsBringing = not BringObjectsBringing
  BringObjectsOptionsBring.Text = BringObjectsBringing == true and "Abort Bringing" or "Start Bringing"
  if BringObjectsOptionsBring then
    BringObjectsBringingCount = math.ceil(tonumber(BringObjectsOptionsCount.Text) >= 0 and tonumber(BringObjectsOptionsCount.Text) or 0)
    BringObjectsBringingAmount = math.ceil(tonumber(BringObjectsOptionsDistance.Text) >= 0 and tonumber(BringObjectsOptionsDistance.Text) or math.huge())
  else
    BringObjectsBringingCount = 0
    BringObjectsBringingDistance = math.huge()
  end
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
  objectDuplicateList = {}
  itemDuplicateList = {}
  for i,v in pairs(BringObjectsObjectList:GetChildren()) do
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

LP.CharacterAdded:Connect(function(char)
  character = char
  wait(3)
  reloadBringObjectItemList()
end)
