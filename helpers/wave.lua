colission_range = 18
alter_freq = 0.0001
alter_amplitude = 0.1
alter_offset = 1
alter_timer=0

MIN_AMP = 5
MAX_AMP = 250
MIN_FREQ = 0.01
MAX_FREQ = 0.12

function Wave(color, offset_x, offset_y, speed, freq, amplitude)
    wave = {}
    wave.color = color
    wave.offset_x = offset_x
    wave.offset_y = offset_y
    wave.speed = speed
    wave.freq = freq
    wave.amplitude = amplitude
    wave.pos_player_x = 0
    wave.estado = 0
    return wave
end

function wave_point(pos_y, speed, freq, amplitude)
    return math.sin(maintimer * -speed + freq * pos_y) * amplitude
end
