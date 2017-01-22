Colors = {}
Colors.RED = "FF4136FF"
Colors.GREEN = "2ECC40FF"
Colors.BLUE = "0074D9FF"
Colors.YELLOW = "2ECCFFFF"
Colors.WHITE = "FFFFFFFF"

function convertHex(hex)
    local splitToRGB = {}
    if # hex < 6 then hex = hex .. string.rep("F", 6 - # hex) end --flesh out bad hexes
    for x = 1, # hex - 1, 2 do
        table.insert(splitToRGB, tonumber(hex:sub(x, x + 1), 16)) --convert hexes to dec
        if splitToRGB[# splitToRGB] < 0 then slpitToRGB[# splitToRGB] = 0 end --prevents negative values
    end
    return unpack(splitToRGB)
end

function set_color(color)
    love.graphics.setColor(convertHex(color))
end
