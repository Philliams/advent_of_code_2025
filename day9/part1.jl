function parse_input(s)
    lines = split(s, "\r\n")
    entries = split.(lines, ",")
    f = r -> parse.(Int64, r)
    parsed = f.(entries)

    return parsed
end

function get_largest_rectangle(pos)
    m = reduce(hcat, pos)

    min_x = minimum(m[1, :])
    max_x = maximum(m[1, :])
    min_y = minimum(m[2, :])
    max_y = maximum(m[2, :])

    anchor_a = [min_x, min_y]
    anchor_b = [max_x, min_y]
    
    sort!(pos, by = t -> sum(abs.(t .- anchor_a)))
    a = reduce(*, abs.(pos[1] .- pos[end]) .+ 1)
   
    println(pos[1], pos[end])

    sort!(pos, by = t -> sum(abs.(t .- anchor_b)))
    b = reduce(*, abs.(pos[1] .- pos[end]) .+ 1)

    println(pos[1], pos[end])

    return max(a, b)

end

open("./day9/input.txt", "r") do io
    s::String = read(io, String)
    pos = parse_input(s)
    pos = center_pos(pos)
    area = get_largest_rectangle(pos)
    println(area)
end
