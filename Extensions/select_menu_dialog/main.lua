local current_file = debug.getinfo(1, "S").source:sub(2)
local current_dir = current_file:match("(.*/)") or "./"
dofile(current_dir .. "modules/dialog.lua")
dofile(current_dir .. "modules/util.lua")
dofile(current_dir .. "modules/string.lua")

-- 最後の選択範囲を保持
---@type (Rectangle?)
local lastSelect = nil

---@type Dialog?
local dialog = nil

---@type boolean
IsShowDialog = false

-- 監視
local timer = Timer {
    interval = 0.1,
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
            dialog:show { wait = false }
            lastSelect = newSelect
            IsShowDialog = true
        end
    end
}
timer:start()
