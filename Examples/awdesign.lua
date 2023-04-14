local navigation_open = true

RunScript("WinForm/main.lua")
LaunchStartup([[
{
    {
        "Json": "WinForm/Design/aw.design.txt",
    },
}
]], true)
print(ReferenceDesign)


local pb = CreatePictureBox({
    type = "picturebox",
    name = "pictureboxa",
    parent = "item_" .. ReferenceDesign.Name,
    background = "255,255,255,255",
    x = 5,
    y = 5,
    width = 60,
    height = 60,
    imageurl = "png,https://raw.githubusercontent.com/G-A-Development-Team/libs/main/image_2023-04-11_194705452.png"
})

ReferenceDesign:AddControl(pb)

local gui_kits = gui.Combobox(ReferenceDesign.ReferenceObj, "MKC_KitName", "Music Kit Changer", "jrllo")
callbacks.Register("Unload", function()
    UnloadScript("WinForm/main.lua")
end)