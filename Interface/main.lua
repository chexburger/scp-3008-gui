local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local GUI = _G.SCP3008GUI.Interface
local LP = game:GetService("Players").LocalPlayer
local character = LP.Character or LP:CharacterAdded:Wait()
while not GUI do wait() end

syn.protect_gui(GUI)
GUI.Parent = game:GetService("CoreGui")

-- Constants
local GameObjects = game:GetService("Workspace"):WaitForChild("GameObjects")
local Physical = GameObjects:WaitForChild("Physical")
local Map = Physical:WaitForChild("Map")
local Ground = Map:WaitForChild("Ground")
local Items = Physical:WaitForChild("Items")
local StructureObjects, Consumables = Ground, Items

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

BringObjectsOptionsBring.MouseButton1Click:Connect(function()
  if not BringObjectsBringingItem then return end
  BringObjectsBringing = not BringObjectsBringing
  BringObjectsOptionsBring.Text = BringObjectsBringing == true and "Abort Bringing" or "Start Bringing"
  if BringObjectsOptionsBring then
    BringObjectsBringingCount = math.ceil(tonumber(BringObjectsOptionsCount.Text) >= 0 and tonumber(BringObjectsOptionsCount.Text) or 0)
  else
    BringObjectsBringingCount = 0
  end
end)

function BindBringObjectItemSelect(btn)
  btn.MouseButton1Click:Connect(function()
    BringObjectsBringingItem = btn.Name
    BringObjectsOptionsSelected.Text = "Item: "..btn.Name
  end)
end

local itemTemplate = Templates:WaitForChild("ObjectTemplate")
local duplicateList = {}
function reloadBringObjectItemList()
  duplicateList = {}
  for _,container in pairs(StructureObjects:GetChildren()) do
    if container:FindFirstChild("Items") then
      for _,object in pairs(container.Items:GetChildren()) do
        if object:IsA("Model") and object:FindFirstChild("Base") then
          duplicateList[object.Name] = true
        end
      end
    end
  end
  for name,_ in pairs(duplicateList) do
    local temp = itemTemplate:Clone()
    temp.Name = name
    temp.Text = name
    temp.Parent = BringObjectsObjectList
    temp.Visible = true
    BindBringObjectItemSelect(temp)
  end
end

reloadBringObjectItemList()

LP.CharacterAdded:Connect(function()
  wait(3)
  reloadBringObjectItemList()
end)
