local isShowDialog = false

-- 最後の選択範囲を保持
---@type (Selection | nil)
local lastSelect = nil

-- Rectangle の形と、座標を比較
---@param last Selection | nil
---@param new Selection
---@return boolean
local function isSameSelects(last, new)
    if last == nil then
        return false
    end
    return (last.bounds == new.bounds) and (last.origin == new.origin)
end

-- ダイアログの設定
---@return Dialog
local function selectionMenuDialog()
    local dlg = Dialog {
        title="Selection Menu",
        onclose = function ()
            isShowDialog = false
        end
    }

    dlg:button {
        id = "delete",
        text = "Delete",
        onclick = function ()
            isShowDialog = false
            app.command.Cut()
            dlg:close()
        end
    }

    dlg:button {
        id = "deselect",
        text = "Deselect",
        onclick = function ()
            isShowDialog = false
            app.sprite.selection:deselect() -- 解除
            dlg:close() -- ダイアログを削除
            app.command.Refresh() -- 選択範囲の残像が残るので Refresh する
        end
    }
    return dlg
end

local function showDialog()
    local dialog = selectionMenuDialog()
    dialog:show {
        wait = false
    }
end

-- 監視
local timer = Timer{
    interval = 0.1 ,
    ontick = function ()
        local selection = app.sprite.selection

        -- 選択範囲がなくなったら、nil を入れる
        if selection.isEmpty then
            lastSelect = nil
        end

        -- 選択範囲を保持したまま、ダイアログを閉じたときに、ダイアログが再度表示されるのを防ぐ
        local _isSameBounds = isSameSelects(lastSelect, selection)
        -- ダイアログ非表示 && 選択がある && 選択範囲に違いがある
        if (not isShowDialog) and (not selection.isEmpty) and (not _isSameBounds) then
            showDialog()
            lastSelect = selection
            isShowDialog = true
        end
    end
}
timer:start()