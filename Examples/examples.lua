local navigation_open = true

RunScript("WinForm/main.lua")
LaunchStartup([[
{
    {
        "Json": "WinForm/Design/examples.design.txt",
    },
}
]], true)

function CollapseNavigation()
    print("clic")
    Navigation.Background[4] = 0
    if navigation_open then
        Navigation.Width = 40
        hamburger.X = 0
        hamburger.SetX = 0 
        Navigation_tabscontainer.Width = 40
        navigation_open = not navigation_open
    else
        Navigation.Width = 200
        hamburger.X = 160
        hamburger.SetX = 160
        Navigation_tabscontainer.Width = 200
        navigation_open = not navigation_open
    end
    QueueAnimation("FadeIn", Navigation, {
        MaxOpacity = 255,
        IncrementOpacity = 17,
        Reference = Navigation.Background
    })
end

callbacks.Register("Unload", function()
    UnloadScript("WinForm/main.lua")
end)