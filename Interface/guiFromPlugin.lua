while not _G.SCP3008GUI do wait() end

local TestGui = Instance.new("ScreenGui")
TestGui.Name = "TestGui"
TestGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling




local Frame = Instance.new("Frame")
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(24, 28, 31)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.Size = UDim2.new(0, 500, 0, 300)
Frame.Parent = TestGui

local Templates = Instance.new("Folder")
Templates.Name = "Templates"
Templates.Parent = TestGui

local UICorner = Instance.new("UICorner")
UICorner.Parent = Frame

local TextLabel = Instance.new("TextLabel")
TextLabel.BackgroundTransparency = 1
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.Position = UDim2.new(0, 0, 0, 5)
TextLabel.Size = UDim2.new(1, 0, 0, 15)
TextLabel.Text = "SCP-3008 Utility GUI"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14
TextLabel.TextWrapped = true
TextLabel.Parent = Frame

local TextLabel2 = Instance.new("TextLabel")
TextLabel2.AnchorPoint = Vector2.new(0, 1)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Font = Enum.Font.Jura
TextLabel2.Position = UDim2.new(0, 0, 1, -5)
TextLabel2.Size = UDim2.new(1, 0, 0, 15)
TextLabel2.Text = "Developed by echesol | Right Alt to Close"
TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel2.TextScaled = true
TextLabel2.TextSize = 14
TextLabel2.TextWrapped = true
TextLabel2.Parent = Frame

local MenuContents = Instance.new("Frame")
MenuContents.AnchorPoint = Vector2.new(0.5, 0.5)
MenuContents.BackgroundTransparency = 1
MenuContents.Name = "MenuContents"
MenuContents.Position = UDim2.new(0.5, 0, 0.5, 0)
MenuContents.Size = UDim2.new(0.9, 0, 0.8, 0)
MenuContents.Parent = Frame

local MenuSelection = Instance.new("Frame")
MenuSelection.AnchorPoint = Vector2.new(0.5, 0.5)
MenuSelection.BackgroundTransparency = 1
MenuSelection.Name = "MenuSelection"
MenuSelection.Position = UDim2.new(0.5, 0, 0.5, 0)
MenuSelection.Size = UDim2.new(0.9, 0, 0.8, 0)
MenuSelection.Parent = Frame

local ObjectTemplate = Instance.new("TextButton")
ObjectTemplate.BackgroundColor3 = Color3.fromRGB(0, 102, 149)
ObjectTemplate.Font = Enum.Font.SourceSansBold
ObjectTemplate.Name = "ObjectTemplate"
ObjectTemplate.Size = UDim2.new(1, -8, 0, 25)
ObjectTemplate.Text = "Object Name"
ObjectTemplate.TextColor3 = Color3.fromRGB(0, 0, 0)
ObjectTemplate.TextSize = 20
ObjectTemplate.Parent = Templates

local BringObjects = Instance.new("Frame")
BringObjects.BackgroundTransparency = 1
BringObjects.Name = "BringObjects"
BringObjects.Size = UDim2.new(1, 0, 1, 0)
BringObjects.Parent = MenuContents

local BringObjects2 = Instance.new("TextButton")
BringObjects2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BringObjects2.Font = Enum.Font.SourceSans
BringObjects2.Name = "BringObjects"
BringObjects2.Size = UDim2.new(0, 200, 0, 50)
BringObjects2.Text = "Bring Objects"
BringObjects2.TextColor3 = Color3.fromRGB(0, 0, 0)
BringObjects2.TextSize = 14
BringObjects2.Parent = MenuSelection

local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.CellSize = UDim2.new(0, 100, 0, 40)
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.Parent = MenuSelection

local RemoveTools = Instance.new("TextButton")
RemoveTools.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
RemoveTools.Font = Enum.Font.SourceSans
RemoveTools.LayoutOrder = 4
RemoveTools.Name = "RemoveTools"
RemoveTools.Size = UDim2.new(0, 200, 0, 50)
RemoveTools.Text = "Remove Tools"
RemoveTools.TextColor3 = Color3.fromRGB(255, 255, 255)
RemoveTools.TextSize = 25
RemoveTools.Parent = MenuSelection

local UICorner2 = Instance.new("UICorner")
UICorner2.Parent = ObjectTemplate

local Options = Instance.new("Frame")
Options.BackgroundTransparency = 1
Options.Name = "Options"
Options.Size = UDim2.new(0.4, 0, 1, 0)
Options.Parent = BringObjects

local ObjectList = Instance.new("ScrollingFrame")
ObjectList.Active = true
ObjectList.AnchorPoint = Vector2.new(1, 0)
ObjectList.BackgroundTransparency = 1
ObjectList.Name = "ObjectList"
ObjectList.Position = UDim2.new(1, 0, 0, 0)
ObjectList.ScrollBarThickness = 5
ObjectList.Size = UDim2.new(0.4, 0, 0.6, -10)
ObjectList.Parent = BringObjects

local ItemList = Instance.new("ScrollingFrame")
ItemList.Active = true
ItemList.AnchorPoint = Vector2.new(1, 0)
ItemList.BackgroundTransparency = 1
ItemList.Name = "ItemList"
ItemList.Position = UDim2.new(1, 0, 0.6, 0)
ItemList.ScrollBarThickness = 5
ItemList.Size = UDim2.new(0.4, 0, 0.4, 0)
ItemList.Parent = BringObjects

local Selector = Instance.new("Frame")
Selector.AnchorPoint = Vector2.new(0.5, 0)
Selector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Selector.BorderSizePixel = 0
Selector.Name = "Selector"
Selector.Position = UDim2.new(0.5, 0, 1, -2)
Selector.Size = UDim2.new(1, 0, 0, 2)
Selector.Parent = RemoveTools

local Selected = Instance.new("TextLabel")
Selected.BackgroundTransparency = 1
Selected.Font = Enum.Font.GothamSemibold
Selected.Name = "Selected"
Selected.Size = UDim2.new(1, 0, 0, 30)
Selected.Text = "Item: None Selected"
Selected.TextColor3 = Color3.fromRGB(255, 255, 255)
Selected.TextSize = 14
Selected.Parent = Options

local ReloadList = Instance.new("TextButton")
ReloadList.AnchorPoint = Vector2.new(0, 1)
ReloadList.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
ReloadList.Font = Enum.Font.SourceSans
ReloadList.LayoutOrder = 4
ReloadList.Name = "ReloadList"
ReloadList.Position = UDim2.new(0, 0, 1, 0)
ReloadList.Size = UDim2.new(1, 0, 0, 20)
ReloadList.Text = "Reload Lists"
ReloadList.TextColor3 = Color3.fromRGB(255, 255, 255)
ReloadList.TextSize = 15
ReloadList.Parent = Options

local BringItem = Instance.new("TextButton")
BringItem.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
BringItem.Font = Enum.Font.SourceSans
BringItem.LayoutOrder = 4
BringItem.Name = "BringItem"
BringItem.Position = UDim2.new(0, 0, 0, 65)
BringItem.Size = UDim2.new(1, 0, 0, 20)
BringItem.Text = "Start Bringing"
BringItem.TextColor3 = Color3.fromRGB(255, 255, 255)
BringItem.TextSize = 15
BringItem.Parent = Options

local Distance = Instance.new("TextBox")
Distance.AnchorPoint = Vector2.new(1, 0)
Distance.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
Distance.Font = Enum.Font.GothamSemibold
Distance.Name = "Distance"
Distance.PlaceholderText = "Min Distance"
Distance.Position = UDim2.new(1, 0, 0.125, 0)
Distance.Size = UDim2.new(0.5, -2, 0, 30)
Distance.Text = ""
Distance.TextColor3 = Color3.fromRGB(255, 255, 255)
Distance.TextSize = 14
Distance.Parent = Options

local Count = Instance.new("TextBox")
Count.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
Count.Font = Enum.Font.GothamSemibold
Count.Name = "Count"
Count.PlaceholderText = "Count"
Count.Position = UDim2.new(0, 0, 0.125, 0)
Count.Size = UDim2.new(0.5, -2, 0, 30)
Count.Text = ""
Count.TextColor3 = Color3.fromRGB(255, 255, 255)
Count.TextSize = 14
Count.Parent = Options

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 2)
UIListLayout.Parent = ObjectList

local UIListLayout2 = Instance.new("UIListLayout")
UIListLayout2.Padding = UDim.new(0, 2)
UIListLayout2.Parent = ItemList

local UICorner3 = Instance.new("UICorner")
UICorner3.Parent = ReloadList

local UICorner4 = Instance.new("UICorner")
UICorner4.Parent = BringItem




_G.SCP3008GUI.Interface = TestGui
