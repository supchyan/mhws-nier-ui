local Config    = require("NierUI.Config")
local Font     = {}

local FontDef = {
    Size    = Config.UI_Scale * 14,
    Size_L  = Config.UI_Scale * 16,
    Name    = "mononoki",
    Italic  = false,
    Bold    = true
}

d2d.register(
    function() 
        Font.Default   = d2d.Font.new(FontDef.Name, FontDef.Size, FontDef.Bold, FontDef.Italic)
        Font.Large     = d2d.Font.new(FontDef.Name, FontDef.Size_L, FontDef.Bold, FontDef.Italic)
    end,
    function() end
)

return Font