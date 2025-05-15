local Color = {}

Color.Default   = 0xFFCDC8B0    -- MAIN UI COLOR
Color.dDefault  = 0xAACDC8B0    -- MAIN DIM UI COLOR
Color.Grey      = 0xFF464C46
Color.dGrey     = 0x77464C46
Color.White     = 0xFFCCCCCC
Color.Blue      = 0xFF589494    -- ONLY KIERAJI RATE IS RECOMMENDED
Color.Green     = 0xFF4DCD4D    -- ONLY KIERAJI RATE IS RECOMMENDED
Color.Yellow    = 0xFFCD954D    -- ONLY KIERAJI RATE IS RECOMMENDED
Color.Orange    = 0xFFCD664D
Color.dOrange   = 0xAACD664D
Color.Red       = 0xFFAD3E3E
Color.dRed      = 0xAAAD3E3E
Color.Byte     = {             -- TEMPORARY APLHA DIM ANIMATION FIX (IF NEEDED)
    c77 = 119,
    cAA = 170,
    cFF = 255
}      

-- FLOATING DEFAULT COLOR ALPHA VARIATION
function Color.fDefault(offset)
    local _val = math.floor(math.abs(math.sin(offset * os.clock())) * Color.Byte.cFF)
    return "0x"..string.format("%x", _val).."CDC8B0"
end

-- FLOATING GREY COLOR ALPHA VARIATION
function Color.fGrey(offset)
    local _val = math.floor(math.abs(math.sin(offset * os.clock())) * Color.Byte.cFF)
    return "0x"..string.format("%x", _val).."464C46"
end

function Color.fdGrey(offset)
    local _val = math.floor(math.abs(math.sin(offset * os.clock())) * Color.Byte.c77)
    return "0x"..string.format("%x", _val).."464C46"
end

return Color