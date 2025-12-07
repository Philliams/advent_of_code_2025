struct Node
    edges::Vector{Node}
    x::Int64
    y::Int64
end

function parse_input(s::String)
    lines = split(s, "\r\n")
    start_position = findfirst('S', lines[1])
    splitter_positions::Vector{Vector{Int64}} = []
    for i in 3:2:length(lines)
        append!(
            splitter_positions,
            [findall(c -> c == '^', lines[i])]
        )
    end

    return start_position, splitter_positions
end

function merge_sort_build_nodes(positions, s_pos, y)

    t_pos = collect(keys(positions))
    sort!(t_pos)

    return_set::Dict{Int64, Node} = Dict()

    i = 1
    j = 1
    while (i <= length(t_pos)) & (j <= length(s_pos))
        if t_pos[i] == s_pos[j]

            if !haskey(return_set, t_pos[i] - 1)
                return_set[t_pos[i] - 1] = Node(Vector{Node}(undef, 0), t_pos[i] - 1, y)
            end

            if !haskey(return_set, t_pos[i] + 1)
                return_set[t_pos[i] + 1] = Node(Vector{Node}(undef, 0), t_pos[i] + 1, y)
            end
            
            append!(
                positions[t_pos[i]].edges,
                [
                    return_set[t_pos[i] - 1],
                    return_set[t_pos[i] + 1] 
                ]
            )
            i += 1
            j += 1
        elseif  t_pos[i] < s_pos[j]
            return_set[t_pos[i]] = positions[t_pos[i]]
            i += 1
        elseif s_pos[j] < t_pos[i]
            j += 1
        end
    end

    return return_set

end

function construct_tree(start_pos, splitter_positions)

    root = Node(Vector{Node}(undef, 0), start_pos, 0)

    positions::Dict{Int64, Node} = Dict(start_pos => root)

    y = 1

    for row in splitter_positions
        positions = merge_sort_build_nodes(positions, row, y)
        y += 1
    end

    for p in keys(positions)
        append!(
            positions[p].edges,
            [Node(Vector{Node}(undef, 0), p, y)]
        )
    end

    return root
end

function recurse_count_paths(root)
    if length(root.edges) == 0
        return 1
    else

        sum_ = 0
        for n in root.edges
            sum_ += recurse_count_paths(n)
        end
        return sum_
    end
end

function recurse_print(root, indent)
    println("~~~~~~~~~~~~~")
    println("$(repeat("\t", indent))- x:$(root.x), y:$(root.y)")
    for edge in root.edges
        recurse_print(edge, indent+1)
    end
end

open("./day7/sample.txt", "r") do io
    s::String = read(io, String)
    println(s)
    start_pos, split_pos = parse_input(s)
    root = construct_tree(start_pos, split_pos)
    count = recurse_count_paths(root)
    # recurse_print(root, 0)
    println(count)
end