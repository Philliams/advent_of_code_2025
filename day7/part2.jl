function parse_input(s::String)
    println(s)
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

function merge_sort_style_counting(t_pos_sum, s_pos)
    # assume s_pos is already sorted
    t_pos = collect(keys(t_pos_sum))
    sort!(t_pos)
    return_set::Dict{Int64, Int64} = Dict()

    i = 1
    j = 1
    while (i <= length(t_pos)) & (j <= length(s_pos))
        idx = t_pos[i]
        idy = s_pos[j]
        if idx == idy
            return_set[idx + 1] = get(return_set, idx + 1, 0) + t_pos_sum[idx]
            return_set[idx - 1] = get(return_set, idx - 1, 0) + t_pos_sum[idx]

            i += 1
            j += 1
        elseif  idx < idy
            return_set[idx] = get(return_set, idx, 0) + t_pos_sum[idx]
            i += 1
        elseif idx > idy
            j += 1
        end
    end

    return return_set
end

function count_splits(start_position, splitter_positions, s)
    positions::Dict{Int64, Int64} = Dict(start_position => 1)
    total = 0
    lines = split(s, "\r\n")
    i = 1
    for row in splitter_positions
        i += 2
        positions = merge_sort_style_counting(positions, row)
    end

    return sum(values(positions))

end

open("./day7/input.txt", "r") do io
    s::String = read(io, String)
    start_pos, split_pos = parse_input(s)
    total = count_splits(start_pos, split_pos, s)
    println(total)
end