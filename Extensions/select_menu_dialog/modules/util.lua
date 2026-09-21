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

-- 呼び出されたファイルのディレクトリを返す
---@return string
local function GetCurrentDirectory()
    local current_file = debug.getinfo(1, "S").source:sub(2)
    local current_dir = current_file:match("(.*/)") or "./";
    return current_dir
end

---@return string
local function getImageDir()
    local current_dir = GetCurrentDirectory()
    return current_dir .. "../assets/"
end

---@param imageName string
---@return Image
function GetImage(imageName)
    local dir = getImageDir()
    local image = Image { fromFile = dir .. imageName }
    return image
end