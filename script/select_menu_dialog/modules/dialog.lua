-- ダイアログの設定
---@param command command
---@return Dialog
function SelectionMenuDialog(command)
    local dlg = Dialog {
        title = "Selection Menu",
        resizeable = false,
        onclose = function ()
            IsShowDialog = false
        end
    }

    dlg:button {
        text = Text.Delete,
        onclick = function()
            command.Cut()
            dlg:close()
            IsShowDialog = false
        end
    }

    dlg:button {
        text = Text.Deselect,
        onclick = function()
            command.DeselectMask()
            dlg:close()
            command:Refresh()
            IsShowDialog = false
        end
    }

    dlg:button {
        text = Text.Copy,
        onclick = function ()
            command.Copy()
        end
    }

    dlg:button {
        text = Text.Paste,
        onclick = function ()
            command.Paste()
        end
    }

    dlg:button {
        text = Text.Invert,
        onclick =function ()
            command.InvertMask()
        end
    }

    return dlg
end
