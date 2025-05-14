local Color = {}

Color.Default   = 0xFFCDC8B0 -- MAIN UI COLOR
Color.dDefault  = 0xAACDC8B0 -- MAIN DIM UI COLOR
Color.Grey      = 0xFF464C46
Color.dGrey     = 0x77464C46
Color.White     = 0xFFCCCCCC
Color.Blue      = 0xFF589494 -- BLUE KIERAJI RATE / PARTY MEMBERS HPs
Color.Green     = 0xFF4DCD4D
Color.Yellow    = 0xFFCD954D
Color.Orange    = 0xFFCD664D
Color.Red       = 0xFFAD3E3E
Color.dRed      = 0xAAAD3E3E
Color.Codes     = {
    _77 = 77,
    _AA = 170,
    _FF = 255
}      

-- FLOATING DEFAULT COLOR ALPHA VARIATION
function Color.fDefault(offset)
    local _val = math.floor(math.abs(math.sin(offset * os.clock())) * 255)
    return "0x"..string.format("%x", _val).."CDC8B0"
end

-- FLOATING GREY COLOR ALPHA VARIATION
function Color.fGrey(offset)
    local _val = math.floor(math.abs(math.sin(offset * os.clock())) * 255)
    return "0x"..string.format("%x", _val).."464C46"
end

function Color.fdGrey(offset)
    local _val = math.floor(math.abs(math.sin(offset * os.clock())) * 119)
    return "0x"..string.format("%x", _val).."464C46"
end

return Color