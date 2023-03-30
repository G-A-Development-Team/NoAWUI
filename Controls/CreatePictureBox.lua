local ControlName = 'picturebox'
local FunctionName = 'CreatePictureBox'


-- By: Agentsix1
function CreatePictureBox(properties)
    local Control = CreateControl()
    Control.BackgroundImage = nil
	
	Control.ChangeImage = function (properties, src, img)
		
		switch(img:lower())
            .case("jpg", function() 
                local jpgData = http.Get(src);
                local imgRGBA, imgWidth, imgHeight = common.DecodeJPEG(jpgData);
                local texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
                properties.BackgroundImage = texture
            end)
            .case("png", function() 
				local pngData = http.Get(src);
                local imgRGBA, imgWidth, imgHeight = common.DecodePNG(pngData);
                local texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
                properties.BackgroundImage = texture
            end)
            .case("svg", function() 
				local svgData = http.Get(src);
                local imgRGBA, imgWidth, imgHeight = common.RasterizeSVG(svgData);
                local texture = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
                properties.BackgroundImage = texture
            end)
			.default(function() print("Image Type not found. key=" .. key) end)
            .process()
			
	end

    Control.AllowedCases = {
        --Positioning and Dimensions:
        "x",
        "y",
        "width",
        "height",

        --Events:
        "mouseclick",

        --Visuals:
        "image",
        "background",
        "roundness",
    }

    Control = Control.DefaultCase(Control, properties)


    Control.Render = function(properties, form)
        if not properties.Visible or not form.Visible then
            return properties
        end

        if string.find(properties.Name, "example_paneldrag3") then
            --print(properties.X + form.X)
            
        end

        if properties.BackgroundImage == nil then
            local args = split(properties.Image, ",")
            local src = args[2]
            local imgtype = args[1]
            switch(imgtype:lower())
                .case("jpg", function() 
                    
                    local jpgData = http.Get(src)
                        local imgRGBA, imgWidth, imgHeight = common.DecodeJPEG(jpgData);
                        Control.BackgroundImage = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
                    
                    
                end)
                .case("png", function() 
                    local pngData = http.Get(src)
                        local imgRGBA, imgWidth, imgHeight = common.DecodePNG(pngData);
                        Control.BackgroundImage = draw.CreateTexture(imgRGBA, imgWidth, imgHeight);
                    
                end)
                .case("svg", function() 
                    local svgData = http.Get(src)
                        local imgRGBA, imgWidth, imgHeight = common.RasterizeSVG(svgData);
                        Control.BackgroundImage =  draw.CreateTexture(imgRGBA, imgWidth, imgHeight);			
                end)
                .default(function() print("Attribute not found. key=" .. key) end)
                .process()
        end

        Renderer:ShadowRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, {0,0,0,40}, 25)
        
        if properties.BackgroundImage ~= nil then
            draw.SetTexture(properties.BackgroundImage)
		end
        Renderer:FilledRectangle({properties.X + form.X, properties.Y + form.Y}, {properties.Width, properties.Height}, properties.Background)
        draw.SetTexture(nil)

        if properties.MouseClick ~= nil then
            --print(control.MouseDown) 
            if input.IsButtonReleased(1) then
                if isMouseInRect(properties.X + form.X, properties.Y + form.Y, properties.Width, properties.Height) then
                    --gui.Command('lua.run "' .. properties.MouseClick .. '" ')
                end
            end
        end

        for _, control in ipairs(properties.Children) do
            control.Render(control, properties)
        end

        return properties
    end

    return Control
end


--- Dont change the below code
--- This required for it to function
WinFormControls[ControlName] = {}
WinFormControls[ControlName]['name'] = ControlName
WinFormControls[ControlName]['function'] = FunctionName