local zez = loadstring(game:HttpGet("https://raw.githubusercontent.com/zezhub/Library/refs/heads/main/lib/dev/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/zezhub/Library/refs/heads/main/lib/latest/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/zezhub/Library/refs/heads/main/lib/latest/InterfaceManager.lua"))()

local Window = zez:CreateWindow({
    Title = "zez " .. zez.Version,
    SubTitle = "by skyzzkl",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- Enables background blur (can be detectable; disable if needed)
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl, -- Fallback key to minimize the UI
    FloatBtn = {
        Enable = true,      -- Toggles the floating minimize button
        DecalId = 12345678, -- Optional image asset ID for the button
        Size = 60,          -- Button size (pixels)
        Sensitivity = 12    -- Drag sensitivity threshold (pixels)
    }
})

-- zez supports Lucide icons for tabs (https://lucide.dev/icons)
-- Icons are optional and purely visual
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Shortcut reference for all registered options
local Options = zez.Options

do
    zez:Notify({
        Title = "Notification",
        Content = "This is a notification",
        SubContent = "SubContent", -- Optional secondary text
        Duration = 5 -- Set to nil to make it persistent
    })

    Tabs.Main:AddParagraph({
        Title = "Paragraph",
        Content = "This is a paragraph.\nSecond line!"
    })

    Tabs.Main:AddButton({
        Title = "Button",
        Description = "Very important button",
        Callback = function()
            Window:Dialog({
                Title = "Title",
                Content = "This is a dialog",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            print("Confirmed the dialog.")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Cancelled the dialog.")
                        end
                    }
                }
            })
        end
    })

    -- Toggle element example
    local Toggle = Tabs.Main:AddToggle("MyToggle", { Title = "Toggle", Default = false })

    Toggle:OnChanged(function()
        print("Toggle changed:", Options.MyToggle.Value)
    end)

    Options.MyToggle:SetValue(false)

    -- Slider element example
    local Slider = Tabs.Main:AddSlider("Slider", {
        Title = "Slider",
        Description = "This is a slider",
        Default = 2,
        Min = 0,
        Max = 5,
        Rounding = 1,
        Callback = function(Value)
            print("Slider was changed:", Value)
        end
    })

    Slider:OnChanged(function(Value)
        print("Slider changed:", Value)
    end)

    Slider:SetValue(3)

    -- Single-choice dropdown example
    local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
        Title = "Dropdown",
        Values = {
            "one", "two", "three", "four", "five", "six", "seven",
            "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"
        },
        Multi = false,
        Default = 1
    })

    Dropdown:SetValue("four")

    Dropdown:OnChanged(function(Value)
        print("Dropdown changed:", Value)
    end)

    -- Multi-select dropdown example
    local MultiDropdown = Tabs.Main:AddDropdown("MultiDropdown", {
        Title = "Dropdown",
        Description = "Allows multiple selections.",
        Values = {
            "one", "two", "three", "four", "five", "six", "seven",
            "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"
        },
        Multi = true,
        Default = { "seven", "twelve" }
    })

    MultiDropdown:SetValue({
        three = true,
        five = true,
        seven = false
    })

    MultiDropdown:OnChanged(function(Value)
        local Values = {}
        for ValueName, _ in next, Value do
            table.insert(Values, ValueName)
        end
        print("Multidropdown changed:", table.concat(Values, ", "))
    end)

    -- Basic color picker example
    local Colorpicker = Tabs.Main:AddColorpicker("Colorpicker", {
        Title = "Colorpicker",
        Default = Color3.fromRGB(96, 205, 255)
    })

    Colorpicker:OnChanged(function()
        print("Colorpicker changed:", Colorpicker.Value)
    end)

    Colorpicker:SetValueRGB(Color3.fromRGB(0, 255, 140))

    -- Color picker with transparency support
    local TColorpicker = Tabs.Main:AddColorpicker("TransparencyColorpicker", {
        Title = "Colorpicker",
        Description = "Supports transparency control.",
        Transparency = 0,
        Default = Color3.fromRGB(96, 205, 255)
    })

    TColorpicker:OnChanged(function()
        print(
            "TColorpicker changed:", TColorpicker.Value,
            "Transparency:", TColorpicker.Transparency
        )
    end)

    -- Keybind example
    local Keybind = Tabs.Main:AddKeybind("Keybind", {
        Title = "KeyBind",
        Mode = "Toggle", -- Modes: Always, Toggle, Hold
        Default = "LeftControl", -- Key name (MB1 / MB2 for mouse buttons)

        -- Fired when the keybind is activated
        Callback = function(Value)
            print("Keybind clicked!", Value)
        end,

        -- Fired when the keybind itself is re-bound
        ChangedCallback = function(New)
            print("Keybind changed!", New)
        end
    })

    -- OnClick only fires in Toggle mode
    Keybind:OnClick(function()
        print("Keybind clicked:", Keybind:GetState())
    end)

    Keybind:OnChanged(function()
        print("Keybind changed:", Keybind.Value)
    end)

    -- Continuous keybind state checker example
    task.spawn(function()
        while true do
            wait(1)

            local state = Keybind:GetState()
            if state then
                print("Keybind is being held down")
            end

            if zez.Unloaded then break end
        end
    end)

    -- Changes keybind to MB2 and mode to Toggle
    Keybind:SetValue("MB2", "Toggle")

    -- Text input example
    local Input = Tabs.Main:AddInput("Input", {
        Title = "Input",
        Default = "Default",
        Placeholder = "Placeholder",
        Numeric = false,  -- Restricts input to numbers only
        Finished = false, -- Fires callback only on Enter
        Callback = function(Value)
            print("Input changed:", Value)
        end
    })

    Input:OnChanged(function()
        print("Input updated:", Input.Value)
    end)
end

-- Addons overview:
-- SaveManager: Handles config saving/loading
-- InterfaceManager: Handles UI-related persistence

-- Bind the UI library to both managers
SaveManager:SetLibrary(zez)
InterfaceManager:SetLibrary(zez)

-- Prevent theme-related settings from being saved
SaveManager:IgnoreThemeSettings()

-- Define specific option indexes to ignore (if needed)
SaveManager:SetIgnoreIndexes({})

-- Folder structure example:
-- Global themes in one folder, per-game configs in another
InterfaceManager:SetFolder("zezScriptHub")
SaveManager:SetFolder("zezScriptHub/specific-game")

-- Build settings UI sections
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Select the first tab on load
Window:SelectTab(1)

zez:Notify({
    Title = "zez",
    Content = "The script has been loaded.",
    Duration = 8
})

-- Loads the config marked as auto-load (if any)
SaveManager:LoadAutoloadConfig()
