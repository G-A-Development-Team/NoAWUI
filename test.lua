local gui_ref = gui.Reference("Visuals")
local gui_tab = gui.Tab(gui_ref, "smkc_tabsss", "testtyy")


local custom = gui.Custom(gui_tab, "MyTestEr", 10, 10, 100, 100, function(x, y, x2, y2, active)
    draw.Color(255, 255, 255, 255)
    draw.Text(x, y, "helllllllllllllllllllllllo")
end, function() end, function() end)