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

function merge_sort_style_counting(t_pos, s_pos)
    # assume s_pos is already sorted
    t_pos = collect(t_pos)
    sort!(t_pos)
    return_set::Set{Int64} = Set()
    count = 0

    i = 1
    j = 1
    while (i <= length(t_pos)) & (j <= length(s_pos))
        if t_pos[i] == s_pos[j]
            push!(return_set, t_pos[i] - 1)
            push!(return_set, t_pos[i] + 1)
            # assuming uniqueness in the vectors
            count += 1
            i += 1
            j += 1
        elseif  t_pos[i] < s_pos[j]
            push!(return_set, t_pos[i])
            i += 1
        elseif s_pos[j] < t_pos[i]
            j += 1
        end
    end

    return return_set, count
end

function count_splits(start_position, splitter_positions, s)
    positions::Set{Int64} = Set([start_position])
    total = 0
    lines = split(s, "\r\n")
    i = 1
    for row in splitter_positions
        for p in positions
            lines[i] = string(lines[i][1:p-1], "|", lines[i][p+1:end])
            lines[i+1] = string(lines[i+1][1:p-1], "|", lines[i+1][p+1:end])
        end
        i += 2
        positions, count = merge_sort_style_counting(positions, row)
        total += count
    end

    for p in positions
        lines[i] = string(lines[i][1:p-1], "|", lines[i][p+1:end])
        lines[i+1] = string(lines[i+1][1:p-1], "|", lines[i+1][p+1:end])
    end

    # display(lines)

    return total

end

open("./day7/input.txt", "r") do io
    s::String = read(io, String)
    start_pos, split_pos = parse_input(s)
    total = count_splits(start_pos, split_pos, s)
    println(total)
end