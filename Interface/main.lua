local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local GUI = _G.SCP3008GUI.Interface
while not GUI do wait() end

syn.protect_gui(GUI)
GUI.Parent = game:GetService("CoreGui")

local MenuContents = GUI:WaitForChild("Frame"):WaitForChild("MenuContents")
local MenuSelection = GUI:WaitForChild("Frame"):WaitForChild("MenuSelection")

MenuContents.Visible = false
MenuSelection.Visible = false
