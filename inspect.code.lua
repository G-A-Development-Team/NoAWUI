Inspect = {}
local comCount = 0


-- By: CarterPoe
function Inspect:Initialize()

end

function Inspect:ShowElement(args)
    local Main = getControlByName("Inspect", "Inspect_flowlayout")
    for i, child in ipairs(Main.Children) do
        if child.Height == 200 then
            child.Height = 20
            child.Background = {1,1,1,1}
            for k, v in pairs(child.Children) do
                if v.Name == "flowlayout_darkside" then
                    table.remove(child.Children, k)
                end
            end
        end
    end

    local element = split(args, ",")[1]
    local inspect = split(args, ",")[2]
    local sender = getControlByName("Inspect", inspect)
    local senderM = getControlByName("Main", element)
    sender.Height = 200
    sender.Background = {50,50,50,255}

    local flow = CreateFlowLayout({
        type = "flowlayout",
        name = "flowlayout_darkside",
        parent = sender.Name,
        x = 2,
        y = 2,
        width = 761,
        height = 195, -- set height to height of each child panel
        background = "100,100,100,255",
        border = "50,50,50,150",
    })
    
    for k, v in pairs(senderM) do
        if type(v) =="string" or type(v) == "number" or type(v) == "boolean" then
            local identifier = math.random(5184, 98974)
            local panel = CreatePanel({
                type = "panel",
                name = "panel" .. identifier,
                parent = flow.Name,
                x = 0,
                y = 0,
                width = 760,
                height = 20, -- set height to height of each child panel
                background = "1,1,1,1",
                border = "50,50,50,150",
                --mouseclick = "Inspect:ShowElement('" .. child.Name .. "," .. "panel" .. identifier .. "')"
            })
            panel.Children = {
                [1] = CreateLabel({
                    type = "label",
                    name = "label" .. identifier,
                    parent = "panel" .. identifier,
                    x = 2,
                    y = 2,
                    color = "255,255,255,255",
                    text = k .. " = " .. tostring(v),
                })
            }
            flow.Children[#flow.Children+1] = panel
        end
    end

    sender.Children[#sender.Children+1] = flow
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
            background = "1,1,1,1",
            border = "50,50,50,150",
            mouseclick = "Inspect:ShowElement('" .. child.Name .. "," .. "panel" .. identifier .. "')"
        })
        panel.Children = {
            [1] = CreateLabel({
                type = "label",
                name = "label" .. identifier,
                parent = "panel" .. identifier,
                x = 2,
                y = 2,
                color = "255,255,255,255",
                text = string.rep("   ", indent) ..  " - " .. child.Name,
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