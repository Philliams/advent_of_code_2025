function parse_input(s)
    lines = split(s, "\r\n")
    entries = split.(lines, ",")
    f = r -> parse.(Int64, r)
    parsed = f.(entries)

    return parsed
end

function flood_fill(start_pos, raster_map)

    stack = [start_pos]

    while length(stack) > 0
        pos = popfirst!(stack)
        try
            if raster_map[pos[1], pos[2]] == 0
                
                    raster_map[pos[1], pos[2]] = 2
                    append!(stack, [
                        pos .+ [0, 1],
                        pos .- [0, 1],
                        pos .+ [1, 0],
                        pos .- [1, 0],
                    ])
            end
        catch e
           # ignore 
        end
    end
end

function raster(pos)
    x = Set([e[1] for e in pos])
    y = Set([e[2] for e in pos])

    xmap = Dict()
    ymap = Dict()

    for (i, x) in enumerate(sort(collect(x)))
        xmap[x] = 2 * i + 1
    end
    for (i, y) in enumerate(sort(collect(y)))
        ymap[y] = 2 * i + 1
    end

    raster_map = zeros(Int16, 2 * (length(x) + 1) + 1, 2 * (length(y) + 1) + 1)

    edges = [(pos[end], pos[1])]
    for i in 1:length(pos) - 1
        append!(edges, [(pos[i], pos[i+1])])
    end

    for e in edges
        # if vertical
        # println(e)
        if e[1][1] == e[2][1]
            idx = xmap[e[1][1]]
            y1 = ymap[e[1][2]]
            y2 = ymap[e[2][2]]
            y1, y2 = sort([y1, y2])

            for idy in y1:y2
                raster_map[idx, idy] = 1
            end
        # if horizontal
        else 
            idy = ymap[e[1][2]]
            x1 = xmap[e[1][1]]
            x2 = xmap[e[2][1]]
            x1, x2 = sort([x1, x2])
            for idx in x1:x2
                raster_map[idx, idy] = 1
            end
        end
    end

    start_pos = [
        xmap[pos[1][1]],
        ymap[pos[1][2]]
    ]


    start_pos = [1, 1]

    flood_fill(start_pos, raster_map)
    replace!(raster_map, 0 => 1)
    replace!(raster_map, 2 => 0)

    return raster_map, xmap, ymap

end

function get_largest_rectangle(pos, raster_map, xmap, ymap)
    # display(transpose(raster_map))
    area = 0
    for i in 1:length(pos)
        for j in i+1:length(pos)
            a = pos[i]
            b = pos[j]

            idx1 = xmap[a[1]]
            idx2 = xmap[b[1]]
            idy1 = ymap[a[2]]
            idy2 = ymap[b[2]]

            idx1, idx2 = sort([idx1, idx2])
            idy1, idy2 = sort([idy1, idy2])

            rect = raster_map[idx1:idx2, idy1:idy2]

            check = reduce(&, rect .> 0)
            if check
                area = max(area, reduce(*, abs.(a .- b) .+ 1))
            end

        end
    end
    return area
end


open("./day9/input.txt", "r") do io
    s::String = read(io, String)
    pos = parse_input(s)
    raster_map, xmap, ymap = raster(pos)
    area = get_largest_rectangle(pos, raster_map, xmap, ymap)
    println(area)
end
