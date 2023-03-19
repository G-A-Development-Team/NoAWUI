Inspect = {}
local comCount = 0


-- By: CarterPoe
function Inspect:Initialize()

end

function printChildren(node, indent, sender, comLabel)
    indent = indent or 0
    for i, child in ipairs(node.Children) do
        local identifier = math.random(5184, 98974)
        local panel = CreatePanel({
            type = "panel",
            name = "panel" .. identifier,
            parent = "Inspect_flowlayout",
            x = 0,
            y = 0,
            width = 766,
            height = 20, -- set height to height of each child panel
            background = "0,0,0,0",
            border = "50,50,50,150",
        })
        panel.Children = {
            [1] = CreateLabel({
                type = "label",
                name = "label" .. identifier,
                parent = "panel" .. identifier,
                x = 2,
                y = 2,
                color = "255,255,255,255",
                text = child.Name,
            })
        }
        --print(string.rep(" ", indent) .. child.Name)
        sender.Children[#sender.Children+1] = panel
        comCount = comCount + 1
        comLabel.Text = tostring(comCount)
        printChildren(child, indent + 2, sender, comLabel)
    end
end


function Inspect:Reload()
    local sender = getControlByName("Inspect", "Inspect_flowlayout")

    sender.Children = {}
    comCount = 0

    local comLabel = getControlByName("Inspect", "comCount")

    local Main = getFormByName("Main")
    --AddChildPanels(Main, sender, comLabel, 1)
    printChildren(Main, 0, sender, comLabel)

end

return Inspect