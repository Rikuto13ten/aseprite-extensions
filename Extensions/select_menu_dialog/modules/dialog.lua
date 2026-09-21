local current_file = debug.getinfo(1, "S").source:sub(2)
local current_dir = current_file:match("(.*/)") or "./"
dofile(current_dir .. "util.lua")

local imageObj = {
    delete = GetImage("delete.png"),
    deselect = GetImage("deselect.png"),
    copy = GetImage("copy.png"),
    paste = GetImage("paste.png"),
    invert = GetImage("invert.png"),

    deletePress = GetImage("delete_press.png"),
    deselectPress = GetImage("deselect_press.png"),
    copyPress = GetImage("copy_press.png"),
    pastePress = GetImage("paste_press.png"),
    invert_press = GetImage("invert_press.png")
}

-- canvas のテンプレート
---@param dlg Dialog
---@param onmousedown function
---@param image Image
local function customDialogCanvas(dlg, onmousedown, image, pressImage)
    local srcRect = Rectangle(Point(0, 0), image.bounds.size)
    local dstw = 15
    local dsth = math.floor(dstw * (srcRect.h / srcRect.w))
    -- 表示したいサイズを設定
    local dstRect = Rectangle(0, 0, dstw, dsth)

    local showImage = image

    dlg:canvas {
        width = dstw,
        height = dsth,
        autoscaling = false,
        onmousedown = function(ev)
            showImage = pressImage
            dlg:repaint()
        end,
        onmouseup = function (ev)
            showImage = image
            dlg:repaint()
            onmousedown()
        end,
        onpaint = function(ev)
            ev.context:drawImage(showImage, srcRect, dstRect)
        end
    }
end

-- ダイアログの設定
---@param command command
---@return Dialog
function SelectionMenuDialog(command)
    local dlg = Dialog {
        title = "Selection Menu",
        resizeable = false,
        onclose = function()
            IsShowDialog = false
        end
    }

    customDialogCanvas(
        dlg,
        function()
            command.Cut()
            dlg:close()
            IsShowDialog = false
        end,
        imageObj.delete,
        imageObj.deletePress
    )

    customDialogCanvas(
        dlg,
        function ()
            command.DeselectMask()
            dlg:close()
            command:Refresh()
            IsShowDialog = false
        end,
        imageObj.deselect,
        imageObj.deselectPress
    )

    customDialogCanvas(
        dlg,
        function ()
            command.Copy()
        end,
        imageObj.copy,
        imageObj.copyPress
    )

    customDialogCanvas(
        dlg,
        function ()
            command.Paste()
        end,
        imageObj.paste,
        imageObj.pastePress
    )

    customDialogCanvas(
        dlg,
        function ()
            command.InvertMask()
        end,
        imageObj.invert,
        imageObj.invert_press
    )

    return dlg
end
