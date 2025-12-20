function parse_input(s)
    lines = split(s, "\r\n")
    entries = split.(lines, ",")
    f = r -> parse.(Int64, r)
    parsed = f.(entries)

    return parsed
end

function overlaps_inclusive(a, b)

    a = [min(a[1], a[2]), max(a[1], a[2])]
    b = [min(b[1], b[2]), max(b[1], b[2])]

    if a[2] < b[1]
        return false
    elseif a[1] > b[2]
        return false
    else
        return true
    end
end

function segments_overlap_inclusive(a, b, c, d)

    v1 = a[1] == b[1]
    v2 = c[1] == d[1]

    if v1 & v2 # both vertical
        return (
            (a[1] == c[1])
            & overlaps_inclusive([a[2], b[2]], [c[2], d[2]])
        )
    elseif v1 # ab vertical, cd horizontal
        return (
            overlaps_inclusive([a[1], a[1]], [c[1], d[1]]) # x value of AB overlaps with cd range
            & overlaps_inclusive([a[2], b[2]], [c[2], c[2]]) # y value of cd overlaps with ab range
        )
    elseif v2 # ab horizontal, cd vertical
        return (
            overlaps_inclusive([a[2], a[2]], [c[2], d[2]]) # y value of AB overlaps with cd range
            & overlaps_inclusive([a[1], b[1]], [c[1], c[1]]) # x value of cd overlaps with ab range
        )
    else # both horizontal
        return (
            (a[2] == c[2])
            & overlaps_inclusive([a[1], b[1]], [c[1], d[1]])
        )
    end

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

function segments_overlap_exclusive(a, b, c, d)

    v1 = a[1] == b[1]
    v2 = c[1] == d[1]

    if v1 & v2 # both vertical
        return false
    elseif v1 # ab vertical, cd horizontal
        return (
            overlaps_exclusive([a[1], a[1]], [c[1], d[1]]) # x value of AB overlaps with cd range
            & overlaps_exclusive([a[2], b[2]], [c[2], c[2]]) # y value of cd overlaps with ab range
        )
    elseif v2 # ab horizontal, cd vertical
        return (
            overlaps_exclusive([a[2], a[2]], [c[2], d[2]]) # y value of AB overlaps with cd range
            & overlaps_exclusive([a[1], b[1]], [c[1], c[1]]) # x value of cd overlaps with ab range
        )
    else # both horizontal
        return false
    end

end

function point_in_shape(edges, v, corners)
    if v in corners
        # println("CORNER")
        return true
    end

    count = 0
    v0 = [-1, v[2]]
    for e in edges
        if segments_overlap_inclusive(e[1], e[2], v, v)
            # println("ON EDGE, $e")
            return true # if it's on a edge, it's in the shape
        end

        if segments_overlap_inclusive(e[1], e[2], v0, v)
            count += 1 # point-in-polygon (PIP) algorithm
        end
    end
    # println(count)
    return count % 2 == 1
end

function check_rect_edges(a, b, c, d, edges)
    for e in edges
        if segments_overlap_exclusive(a, b, e[1], e[2])
            return false
        end

        if segments_overlap_exclusive(b, c, e[1], e[2])
            return false
        end
            
        if segments_overlap_exclusive(c, d, e[1], e[2])
            return false
        end

        if segments_overlap_exclusive(d, a, e[1], e[2])
            return false
        end
    end
    return true
end

function get_largest_rectangle(pos)

    known_corners = Set(pos)
    edges = [(pos[end], pos[1])]
    for i in 1:length(pos) - 1
        append!(edges, [(pos[i], pos[i+1])])
    end

    check = v -> point_in_shape(edges, v, known_corners)

    a = [2, 3]
    c = [9, 5]
    b = [a[1], c[2]]
    d = [c[1], a[2]]
    
    println("$a $(check(a))")
    println("$b $(check(b))")
    println("$c $(check(c))")
    println("$d $(check(d))")
    println(check_rect_edges(a, b, c, d, edges))
    # vec = [10, 5]
    # res = check(vec)
    # # println("$res, $vec")
    # max_ = 0
    # for i in 1:length(pos)
    #     for j in i+1:length(pos)

    #         a = pos[i]
    #         b = [pos[i][1], pos[j][2]]
    #         c = pos[j]
    #         d = [pos[j][1], pos[i][2]]

    #         # check if all vertices are inside square
    #         check = v -> point_in_shape(edges, v, known_corners)
    #         all_inside = (
    #             check(a)
    #             & check(b)
    #             & check(c)
    #             & check(d)
    #         )

    #         # check if any of the rectangle edges cross edges
    #         all_edges = check_rect_edges(a, b, c, d, edges)
    #         # println("=======================")
    #         # println("$a -> $b -> $c -> $d, $all_inside, $all_edges")
    #         # println("$(check(a)), $(check(b)), $(check(c)), $(check(d))")

    #         if all_inside & all_edges
    #             # println("valid, $a, $c")
    #             max_ = max(max_, reduce(*, abs.(a .- c) .+ 1))
    #         else
    #             # println("invalid, $a ($(check(a))), $b ($(check(b))), $c ($(check(c))), $d ($(check(d)))")
    #         end

    #     end
    # end

    # return max_
    
end


open("./day9/sample.txt", "r") do io
    s::String = read(io, String)
    pos = parse_input(s)
    area = get_largest_rectangle(pos)
    println(area)

end
