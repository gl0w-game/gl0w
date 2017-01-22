function sleep(n)
    local t0 = clock()
    while clock() - t0 <= n do end
end

function clamp(min, val, max)
    return math.max(min, math.min(val, max));
end
