print("TUYO V1.0.0")

-- Utils

function sumDict(args) -- recibe una lista de tables
    local new = {}

    for _, v in ipairs(args) do
        for k, vv in pairs(v) do
            new[k] = vv
        end
    end

    return new
end

function sumList(args) -- recibe una lista de listas
    local new = {}

    for _, v in ipairs(args) do
        for _, vv in ipairs(v) do
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
        human_name = human_name,
        internal_name = internal_name,
        item_name = internal_name .. "Item",
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
            strongAxe,
            iceAxe
        }
    },
    armas = {
        armasBlancas = {
            lanzas = {
                spear,
                poisonSpear
            }
        }
    }
}

items.armas.armasBlancas.hachas = items.cortarArboles.hachas

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

function traerF(item_name, cantidad)
    local i = 0
    for _, Obj in pairs(Workspace.Items:GetDescendants()) do
        if Obj.Name == item_name and Obj:IsA("Model") and Obj.PrimaryPart then
            Obj.PrimaryPart.CFrame = root.CFrame
            i += 1
            if i >= cantidad and cantidad ~= 0 then
                break
            end
        end
    end
end

local bringInfo = {}

for _, v in ipairs(fatItems) do
    bringInfo[v.internal_name] = {
        amountToBring = 0
    }

    bringInfo[v.internal_name].label = traer:CreateLabel({
        Title = "Traer todos los objetos: \"" .. v.human_name .. "\"."
    })

    bringInfo[v.internal_name].button = traer:CreateButton(
        {
            name = "Traer los objetos: \"" .. v.human_name .. "\".",
            callback = function()
                traerF(v.item_name, bringInfo[v.internal_name].amountToBring)
            end
        }
    )

    bringInfo[v.internal_name].input = traer:CreateInput(
        {
            name = "Cantidad de objetos a traer (0 es todos).",
            numeric = true,
            value = "0",
            placeholder = "Pon un número (0 es todos).",
            flag = "AmountBringOf" .. v.internal_name,
            callback = function(text)
                bringInfo[v.internal_name].amountToBring = tonumber(text)
                local cantidad = text
                if cantidad == "0" then
                    cantidad = "todos los"
                end
                bringInfo[v.internal_name].label:UpdateLabel("Traer " .. cantidad .. " objetos: \"" .. v.human_name .. "\".")
            end
        }
    )

end