function parse_input(s)
    lines = split(s, "\r\n")
    entries = split.(lines, ",")
    f = r -> parse.(Int64, r)
    parsed = f.(entries)

    return parsed
end

function check_bounds(x1, y1, x2, y2)
    flags = [
        (x1[1] >= x2[1]) & (x1[1] <= x2[2]), # left bound in x range
        (x1[2] >= x2[1]) & (x1[2] <= x2[2]), # right bound in x range
        (y1[1] >= y2[1]) & (y1[1] <= y2[2]), # bottom bound in y range
        (y1[2] >= y2[1]) & (y1[2] <= y2[2]), # top bound in y range
    ]

    println("$flags, $((flags[1] | flags[2]) & (flags[3] | flags[4]))")

    return (flags[1] | flags[2]) & (flags[3] | flags[4])
end

function segments_intersect(a, b, c, d)
    x1 = sort([a[1], b[1]])
    y1 = sort([a[2], b[2]])

    x2 = sort([c[1], d[1]])
    y2 = sort([c[2], d[2]])

    println("x1=$x1, y1=$y1")
    println("x2=$x2, y2=$y2")
    
    return check_bounds(x1, y1, x2, y2) | check_bounds(x2, y2, x1, y1)
end

function check_vertex(vec, nodes, lookup)
    if vec in lookup
        return true
    end

    anchor = [vec[1], -1]
    n = length(nodes)
    count = 0
    for i in 1:n
        u = nodes[i]
        v = nodes[(i%n)+1]

        println("$anchor, $vec, $u, $v")
        s = (segments_intersect(anchor, vec, u, v))
        println("$s")
        count += s

    end
end


function get_largest_rectangle(pos)

    lookup = Set(pos)

    max_ = 0

    for i in 1:2
        for j in i+1:3

            a = pos[i]
            b = [pos[i][1], pos[j][2]]
            c = pos[j]
            d = [pos[j][1], pos[i][2]]

            vertices = [a, b, c, d]

            println("=====================")
            println("$a, $c")
            for v in vertices
                check_vertex(v, pos, lookup)
            end



        end
    end

    return max_
end




open("./day9/sample.txt", "r") do io
    s::String = read(io, String)
    pos = parse_input(s)
    area = get_largest_rectangle(pos)
    println(area)

end
