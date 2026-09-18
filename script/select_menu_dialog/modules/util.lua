-- Rectangle の形と、座標を比較して一致していれば true
---@param last Rectangle?
---@param new Rectangle
---@return boolean
function IsSameSelects(last, new)
    if last == nil then
        return false
    end
    local isEquolBounds = (last.size == new.size)
    local isEquolBoundsOrigin = (last.origin == new.origin)

    -- サイズも座標も同じ -> true, サイズだけ同じで座標が違う(移動させただけ) -> true
    return (isEquolBounds and isEquolBoundsOrigin) or (isEquolBounds and not isEquolBoundsOrigin)
end
