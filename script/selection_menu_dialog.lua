local isShowDialog = false
-- 最後の選択範囲を保持
local lastSelectBounds = nil

-- 最後の選択範囲と、新しい選択範囲が同じならば true を返す
local function isSameBounds(last, new)
    return last == new
end

-- ダイアログの設定
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

        if selection.isEmpty then
            lastSelectBounds = nil
            return
        end

        -- 選択範囲を保持したまま、ダイアログを閉じたときに、ダイアログが再度表示されるのを防ぐ
        local _isSameBounds = isSameBounds(lastSelectBounds, selection.bounds)
        -- ダイアログ非表示 && 選択がある && 選択範囲に違いがある
        if (not isShowDialog) and (not selection.isEmpty) and (not _isSameBounds) then
            showDialog()
            lastSelectBounds = selection.bounds
            isShowDialog = true
        end
    end
}

timer:start()