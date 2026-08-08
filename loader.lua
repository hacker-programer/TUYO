-- Utils

function sumDict(args) -- recibe una lista de tables
    local new = {}

    for v in ipairs(args) do
        for k, vv in pairs(v) do
            table.insert(new, k, vv)
        end
    end

    return new
end

function sumList(args) -- recibe una lista de listas
    local new = {}

    for v  in ipairs(args) do
        for vv in ipairs(v) do
            table.insert(new, vv)
        end
    end

    return new
end

-- Cheat

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local window = Rayfield:CreateWindow({
    name = "TUYO",
    subtitle = "The Unobfuscated Script Yours Overhaul",
})

local player = game.Players.LocalPlayer
local character = player.Character
local root = character:WaitForChild("HumanoidRootPart")

local types = {
    tool = "tool"
}

function newTool(human_name, internal_name) 
    return {
        humanName = humanName,
        internalName = internal_name,
        itemName = internal_name .. "Item",
        tipo = types.tool
    }
end

-- hachas

local goodAxe = newTool("hacha buena", "GoodAxe")
local strongAxe = newTool("hacha fuerte", "StrongAxe")
local iceAxe = newTool("hacha de hielo", "IceAxe")

-- lanzas

local spear = newTool("lanza", "SpearGround")
local poisonSpear = newTool("lanza", "PoisonSpearGround")

local items = {
    cortarArboles = {
        hachas = {
            goodAxe,
            strongAxe
        }
    },
    armas = {
        armasBlancas = {
            hachas = items.cortarArboles.hachas,
            lanzas = {
                spear,
                poisonSpear
            }
        }
    }
}

local fatItems = sumList(
    {
        items.cortarArboles.hachas,
        items.armas.armasBlancas.lanzas
    }
)

local traer = window:CreateTab({
    name = "Traer",
    icon = "layers-arrow-up"
})

function traerF(item_name)
    for _, Obj in pairs(Workspace.Items:GetDescendants()) do
        if Obj.Name == item_name and Obj:IsA("Model") and Obj.PrimaryPart then
            Obj.PrimaryPart.CFrame = root.CFrame
        end
    end
end

local bringInfo = {}

for v in ipairs(fatItems) do
    table.insert(bringInfo, v.internal_name, {
        amountToBring = 0
    })
    insert(bringInfo[v.internal_name], "button", traer:CreateButton(
        {
            name = "Traer todos los objetos: \"" .. v.human_name .. "\".",
            callback = function()
                traerF(v.item_name)
            end
        }
    ))

    insert(bringInfo[v.internal_name], "input", traer:CreateInput(
        {
            name = "Cantidad de objetos traer (0 es todos).",
            numeric = true,
            value = "0",
            placeholder = "Pon un numero (0 es todos).",
            flag = "AmountBringOf" .. v.internal_name,
            callback = function(text)
                bringInfo[v.internal_name].amountToBring = tonumber(text)
                local cantidad = tonumber(text)
                if cantidad == "0" then
                    cantidad = "todos los"
                end
                bringInfo[v.internal_name].button:Set("Traer " .. cantidad .. "objetos: \"" .. v.human_name .. "\".")
            end
        }
    ))

end