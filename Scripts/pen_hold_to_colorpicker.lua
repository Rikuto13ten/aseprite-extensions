local boolToggle = function (flag)
    
end

local layerObj = function()
    ---@type Layer[]
    local reverseSortArray = {}
    local layerArray = app.sprite.layers
    for i = #layerArray, 1, -1 do
        table.insert(reverseSortArray, layerArray[i])
    end
    return reverseSortArray
end

---@param layerArray Layer[]
local customDialog = function(layerArray)
    local dlg = Dialog {
        title = "Layer               "
    }
    for i = 1, #layerArray do
        local index = tostring(i)
        local layer = layerArray[i]
        dlg:entry {
            id = "entry" .. index,
            text = layer.name,
            vexpand = false,
            focus = false
        }
        dlg:slider {
            id = "slider" .. index,
            min = 0,
            max = 255,
            value = layer.opacity,
            onrelease = function()
                layer.opacity = dlg.data["slider" .. index]
                app.command.Refresh()
            end
        }
        dlg:button {
            text = "Rename",
            onclick = function ()
                layer.name = dlg.data["entry" .. index]
            end
        }
        dlg:button {
            text = "visible",
            onclick =function ()
                layer.isVisible = not layer.isVisible
            end
        }
        dlg:button {
            text = "delete",
            onclick =function ()
                app.layer = layer
                app.command.RemoveLayer()
            end
        }
        dlg:button {
            text = "down new",
            onclick = function ()
                app.layer = layer
                app.command.NewLayer {before=true}
            end
        }
        dlg:button {
            text = "top new",
            onclick = function ()
                app.layer = layer
                app.command.NewLayer {before=false}
            end
        }

        dlg:separator()
    end
    return dlg
end

local function main()
    ---@type Layer[]
    if app.sprite == nil then
        return
    end
    local _array = layerObj()
    local dlg = customDialog(_array)
    dlg:show { wait = false, autoscrollbars = true }

    app.sprite.events:on('change', function()
        local origin = dlg.bounds.origin
        dlg:close()
        _array = layerObj()
        dlg = customDialog(_array)
        dlg:show {
            wait = false,
            bounds = Rectangle(origin, dlg.bounds.size),
            autoscrollbars = true
        }
    end)
end

main()
