function parse_input(s)
    lines = split(s, "\r\n")
    entries = split.(lines, ",")
    f = r -> parse.(Int64, r)
    parsed = f.(entries)

    return parsed
end

function overlaps_exclusive(a, b)
    if a[2] <= b[1]
        return false
    elseif a[1] >= b[2]
        return false
    else
        return true
    end
end

function on_edge(a, b, v)
    
    h_flag = (a[1] == v[1]) & (a[2] <= v[2]) & (b[2] >= v[2])
    v_flag = (a[2] == v[2]) & (a[1] <= v[1]) & (b[1] >= v[1])

    return h_flag & v_flag
end

function intersects_exclusive(a, b, c, d)
    return (
        overlaps_exclusive(
            sort([a[1], b[1]]),
            sort([c[1], d[1]])
        )
        & overlaps_exclusive(
            sort([a[2], b[2]]),
            sort([c[2], d[2]])
        )
    )
end

function center_pos(pos)

    min_x = reduce(min, [t[1] for t in pos])
    min_y = reduce(min, [t[2] for t in pos])

    return map(x -> x - [min_x, min_y], pos)

end

function count_intersections(a, b, nodes)
    count = 0
    for i in 1:length(nodes)
        count += intersects_exclusive(a, b, nodes[i], nodes[(i%length(nodes)) + 1])
    end
    return count
end


function check_inside_polygon(point, nodes)

    a = point
    b = [-1, point[2]] # set something to the far left
    count = 0
    for i in 1:length(nodes)
        u = nodes[i]
        v = nodes[(i%length(nodes)) + 1]
        count += intersects_exclusive(a, b, u, v)
        count += on_edge(
            sort([u[1], v[1]]),
            sort([u[1], v[1]]),
            nodes[i]
        )
    end

    return count % 2 == 1

end

function validate_rect(vertices, nodes, lookup)
    
    for v in vertices
        if !(v in lookup)
            if !check_inside_polygon(v, nodes)
                println("invalid vertex $v")
                return false
            end
        end
    end

    n = length(vertices)
    for i in 1:n
        v = vertices[i]
        u = vertices[(i%n) + 1]

        c = count_intersections(u, v, nodes)

        if c > 0
            println("invalid edge $v, $u, $c")
            return false
        end
    end



    return true

end

function get_largest_rectangle(pos)

    lookup = Set(pos)

    max_ = 0

    for i in 1:length(pos)
        for j in i+1:length(pos)

            a = pos[i]
            b = [pos[i][1], pos[j][2]]
            c = pos[j]
            d = [pos[j][1], pos[i][2]]

            vertices = [a, b, c, d]
            
            println("================")
            println("$(pos[i]), $(pos[j])")

            if validate_rect(vertices, pos, lookup)
                println("VALID")
                # println("~~~~~~~~~~~~~")
                # println(vertices)
                # println(reduce(*, abs.(pos[i] .- pos[j]) .+ 1))
                max_ = max(
                    max_,
                    reduce(*, abs.(pos[i] .- pos[j]) .+ 1)
                )
            end
        end
    end

    return max_
end




open("./day9/sample.txt", "r") do io
    s::String = read(io, String)
    pos = parse_input(s)
    # pos = center_pos(pos)

    area = get_largest_rectangle(pos)
    println(area)

end
