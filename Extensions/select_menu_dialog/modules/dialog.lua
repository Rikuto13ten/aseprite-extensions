---@return LangGroup
local function decodeJson()
    local current_file = debug.getinfo(1, "S").source:sub(2)
    local current_dir = current_file:match("(.*/)") or "./"
    local file = io.open(current_dir .. "../string/lang.json", "r")
    if not file then return end
    local jsonText = file:read("*a")
    file:close()
    return json.decode(jsonText)
end


---@return Lang
local function localizedText()
    local languageValue = app.preferences.general.language
    local data = decodeJson()
    if languageValue == "ja" then
        return data.ja
    else
        return data.en
    end
end

-- ダイアログの設定
---@param command command
---@return Dialog
function SelectionMenuDialog(command)
    local data = localizedText()

    local dlg = Dialog {
        title = "Selection Menu",
        resizeable = false,
        onclose = function ()
            IsShowDialog = false
        end
    }

    dlg:button {
        text = data.delete,
        onclick = function()
            command.Cut()
            dlg:close()
            IsShowDialog = false
        end
    }

    dlg:button {
        text = data.deselect,
        onclick = function()
            command.DeselectMask()
            dlg:close()
            command:Refresh()
            IsShowDialog = false
        end
    }

    dlg:button {
        text = data.copy,
        onclick = function ()
            command.Copy()
        end
    }

    dlg:button {
        text = data.paste,
        onclick = function ()
            command.Paste()
        end
    }

    dlg:button {
        text = data.invert,
        onclick =function ()
            command.InvertMask()
        end
    }

    return dlg
end
