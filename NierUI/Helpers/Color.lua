
local Color = {}

Color.Default  = 0xFFCDC8B0 -- MAIN UI COLOR
Color.dDefault = 0xAACDC8B0 -- MAIN DIM UI COLOR
Color.Grey     = 0xFF464C46
Color.dGrey    = 0x77464C46
Color.White    = 0xFFCCCCCC
Color.Blue     = 0xFF589494 -- BLUE KIERAJI RATE / PARTY MEMBERS HPs
Color.Green    = 0xFF4DCD4D
Color.Yellow   = 0xFFCD954D
Color.Orange   = 0xFFCD664D
Color.Red      = 0xFFAD3E3E

-- FLOATING DEFAULT ALPHA COLOR VARIATION
function Color.fDefault(offset)
    local fAlpha = math.floor(math.abs(math.sin(offset * os.clock())) * 255)
    return "0x"..string.format("%x", fAlpha).."CDC8B0"
end

-- FLOATING GREY ALPHA COLOR VARIATION
function Color.fGrey(offset)
    local fAlpha = math.floor(math.abs(math.sin(offset * os.clock())) * 255)
    return "0x"..string.format("%x", fAlpha).."464C46"
end

function Color.fdGrey(offset)
    local fAlpha = math.floor(math.abs(math.sin(offset * os.clock())) * 119)
    return "0x"..string.format("%x", fAlpha).."464C46"
end

return Color