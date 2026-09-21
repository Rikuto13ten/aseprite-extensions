local current_file = debug.getinfo(1, "S").source:sub(2)
local current_dir = current_file:match("(.*/)") or "./"
dofile(current_dir .. "modules/dialog.lua")
dofile(current_dir .. "modules/util.lua")

-- 最後の選択範囲を保持
---@type (Rectangle?)
local lastSelect = nil

---@type Dialog
local dialog = Dialog()

---@type boolean
IsShowDialog = false

-- 監視
local timer = Timer {
    interval = 0.2,
    ontick = function()
        -- sprite を開いていない時は nil なので return
        if app.sprite == nil then return end
        if app.sprite.selection.isEmpty then return end

        -- ここで選択範囲を取得しないと、正しく取得できない
        local newSelect = app.sprite.selection.bounds

        -- 選択範囲を比較する
        local isSameBounds = IsSameSelects(lastSelect, newSelect)

        -- 選択がある && 選択範囲に違いがある
        if (not isSameBounds) and (not IsShowDialog) then
            dialog = SelectionMenuDialog(app.command)
            local point = app.editor.mousePos
            dialog:show{
                wait = false,
                bounds = Rectangle(point, dialog.bounds.size)
            }
            dialog:repaint()

            lastSelect = newSelect
            IsShowDialog = true
        end
    end
}
timer:start()
