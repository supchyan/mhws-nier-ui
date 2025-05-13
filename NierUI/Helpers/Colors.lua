
local Colors = {}

Colors.Default  = 0xFFCDC8B0 -- MAIN UI COLOR
Colors.dDefault = 0xAACDC8B0 -- MAIN DIM UI COLOR
Colors.Grey     = 0xFF464C46
Colors.White    = 0xFFcccccc
Colors.Blue     = 0xFF4d8acd
Colors.Green    = 0xFF4dcd4d
Colors.Yellow   = 0xFFcd954d
Colors.Orange   = 0xFFCD664D
Colors.Red      = 0xFFad3e3e

-- FLOATING YELLOW ALPHA COLOR VARIATION
function Colors.fDefault(offset)
    local fAlpha = math.floor(math.abs(math.sin(offset * os.clock())) * 255)
    return "0x"..string.format("%x", fAlpha).."CDC8B0"
end

return Colors