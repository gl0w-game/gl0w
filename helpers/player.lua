function Player(start_y, start_color, start_lane)
    player = {}
    player.pos_y = start_y
    player.color = start_color
    player.current_wave = start_lane
    return player
end

function change_player_color()
    if player.color == Colors.RED then
        player.color = Colors.GREEN
    elseif player.color == Colors.GREEN then
        player.color = Colors.BLUE
    elseif player.color == Colors.BLUE then
        player.color = Colors.RED
    end
end
