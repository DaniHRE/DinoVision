local DinoVision = {
	esp = {
		CharacterSize = Vector2.new(5,6);
		Box = {
			TeamCheck = false;
			Box = false;
			Name = false;
			Distance = false;
            BoxTransparency = 1;
			Color = Color3.fromRGB(255, 255, 255);
			Outline = false;
			OutlineColor = Color3.fromRGB(0,0,0);	
		};

		Tracer = {
			TeamCheck = false;
			TeamColor = false;
			Tracer = false;
			Color = Color3.fromRGB(255, 255, 255);
			Outline = false;
			OutlineColor = Color3.fromRGB(0, 0, 0);
		};

		Highlights = {
			TeamCheck = false;
			Highlights = false;
			AlwaysVisible = false;
			OutlineTransparency = 0.5;
			FillTransparency = 0.5;
			OutlineColor = Color3.fromRGB(255, 0, 0);
			FillColor = Color3.fromRGB(255, 255, 255);
		};
	};
}

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = tostring(cloneref(game:GetService("MarketplaceService")):GetProductInfo(game.PlaceId).Name) .. "| " .. "DinoVision V2";
    Center = true,
    AutoShow = true,
})

local Tabs = {
    Main = Window:AddTab('Main'), 
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local BoxGB = Tabs.Main:AddLeftGroupbox('Box')
local EnemyGB = Tabs.Main:AddLeftGroupbox('Enemy')
local TracerGB = Tabs.Main:AddRightGroupbox("Tracer");
BoxGB:AddToggle('BoxEnabled', {
    Text = 'Enabled',
    Default = DinoVision.esp.Box.Box,
    Tooltip = 'Enable or disable Box ESP',
    Callback = function(Value)
        DinoVision.esp.Box.Box = Value;
    end
})

BoxGB:AddSlider('BoxTransparency', {
    Text = 'Transparency',
    Default = DinoVision.esp.Box.BoxTransparency,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        DinoVision.esp.Box.BoxTransparency = Value;
    end
})

BoxGB:AddLabel('Color'):AddColorPicker('BoxColor', {
    Default = DinoVision.esp.Box.Color,
    Title = 'Color',
    Transparency = 0,
    Callback = function(Value)
        DinoVision.esp.Box.Color = Value;
    end
})

BoxGB:AddDivider()

BoxGB:AddToggle('BoxOutlineEnabled', {
    Text = 'Outline',
    Default = DinoVision.esp.Box.Outline,
    Tooltip = 'Enable or disable Box Outline',
    Callback = function(Value)
        DinoVision.esp.Box.Outline = Value;
    end
})

BoxGB:AddLabel('Outline Color'):AddColorPicker('BoxOutlineColor', {
    Default = DinoVision.esp.Box.OutlineColor,
    Title = 'Outline Color',
    Transparency = 0,
    Callback = function(Value)
        DinoVision.esp.Box.OutlineColor = Value;
    end
})

EnemyGB:AddToggle('NameEnabled', {
    Text = 'Name',
    Default = DinoVision.esp.Box.Name,
    Tooltip = 'Enable or disable Name',
    Callback = function(Value)
        DinoVision.esp.Box.Name = Value;
    end
})

EnemyGB:AddToggle('DistanceEnabled', {
    Text = 'Distance',
    Default = DinoVision.esp.Box.Distance,
    Tooltip = 'Enable or disable Distance',
    Callback = function(Value)
        DinoVision.esp.Box.Distance = Value;
    end
})

TracerGB:AddToggle('TracerEnabled', {
    Text = 'Enabled',
    Default = DinoVision.esp.Tracer.Tracer,
    Tooltip = 'Enable or disable Tracer',
    Callback = function(Value)
        DinoVision.esp.Tracer.Tracer = Value;
    end
})

TracerGB:AddLabel('Color'):AddColorPicker('TracerColor', {
    Default = DinoVision.esp.Tracer.Color,
    Title = 'Color',
    Transparency = 0,
    Callback = function(Value)
        DinoVision.esp.Tracer.Color = Value;
    end
})

TracerGB:AddToggle('TracerOutline', {
    Text = 'Outline',
    Default = DinoVision.esp.Tracer.Outline,
    Tooltip = 'Enable or disable Tracer Outline',
    Callback = function(Value)
        DinoVision.esp.Tracer.Outline = Value;
    end
})


TracerGB:AddLabel('Outline Color'):AddColorPicker('TracerOutlineColor', {
    Default = DinoVision.esp.Tracer.OutlineColor,
    Title = 'Outline Color',
    Transparency = 0,
    Callback = function(Value)
        DinoVision.esp.Tracer.OutlineColor = Value;
    end
})

LeftGroupBox:AddToggle('HighlightEnabled', {
    Text = 'Enable Highlights',
    Default = DinoVision.esp.Highlights.Highlights,
    Tooltip = 'Enable or disable Highlights',
    Callback = function(Value)
        DinoVision.esp.Highlights.Highlights = Value;
    end
})

LeftGroupBox:AddLabel('Highlight Outline Color'):AddColorPicker('HighlightOutlineColor', {
    Default = DinoVision.esp.Highlights.OutlineColor,
    Title = 'Highlight Outline Color',
    Transparency = 0,
    Callback = function(Value)
        DinoVision.esp.Highlights.OutlineColor = Value;
    end
})

LeftGroupBox:AddSlider('Highlight Outline Transparency', {
    Text = 'Highlight Outline Transparency',
    Default = DinoVision.esp.Highlights.OutlineTransparency,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        DinoVision.esp.Highlights.OutlineTransparency = Value;
    end
})

LeftGroupBox:AddLabel('Highlight Fill Color'):AddColorPicker('HighlightFillColor', {
    Default = DinoVision.esp.Highlights.FillColor,
    Title = 'Highlight Fill Color',
    Transparency = 0,
    Callback = function(Value)
        DinoVision.esp.Highlights.FillColor = Value;
    end
})

LeftGroupBox:AddSlider('Highlight Fill Transparency', {
    Text = 'Highlight Fill Transparency',
    Default = DinoVision.esp.Highlights.FillTransparency,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        DinoVision.esp.Highlights.FillTransparency = Value;
    end
})

LeftGroupBox:AddToggle('Enabled', {
    Text = 'Always Visible Highlights',
    Default = DinoVision.esp.Highlights.AlwaysVisible,
    Tooltip = 'Enable or disable Highlights',
    Callback = function(Value)
        DinoVision.esp.Highlights.AlwaysVisible = Value;
    end
})

-- Inicializar ThemeManager e SaveManager
ThemeManager:SetLibrary(Library);
ThemeManager:ApplyToTab(Tabs['UI Settings']);
ThemeManager:ApplyTheme("Ubuntu");

SaveManager:SetLibrary(Library);
SaveManager:IgnoreThemeSettings();
SaveManager:SetFolder('Aftermath');
SaveManager:BuildConfigSection(Tabs['UI Settings']);
SaveManager:LoadAutoloadConfig();

Library:Notify("DinoVision Started 🆗")