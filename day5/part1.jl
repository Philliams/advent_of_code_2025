# using : https://www.youtube.com/watch?v=q0QOYtSsTg4
mutable struct IntervalTree
    lb::Int64
    ub::Int64
    max_:: Int64
    left:: Union{IntervalTree, Nothing}
    right:: Union{IntervalTree, Nothing}
end

function insert_node(intervaltree, interval)

    if interval[1] < intervaltree.lb
        if isnothing(intervaltree.left)
            intervaltree.left = IntervalTree(interval[1], interval[2], interval[2], nothing, nothing, )
        else
            insert_node(intervaltree.left, interval)
        end
    else
        if isnothing(intervaltree.right)
            intervaltree.right = IntervalTree(interval[1], interval[2], interval[2], nothing, nothing, )
        else
            insert_node(intervaltree.right, interval)
        end
    end

    intervaltree.max_ = max(intervaltree.max_, interval[2])

end

function search_point(intervaltree, x)
    # false base-case
    if isnothing(intervaltree)
        return false
    end

    # true base case
    if (intervaltree.lb <= x) & (intervaltree.ub >= x)
        return true
    end

    # seach cases
    if isnothing(intervaltree.left)
        return search_point(intervaltree.right, x)
    elseif intervaltree.left.max_ < x
        return search_point(intervaltree.right, x)
    else
        return search_point(intervaltree.left, x)
    end
end

function parse_input(s)
    sections = split(s, "\r\n\r\n")

    ranges = split(sections[1], "\r\n")
    ids = split(sections[2], "\r\n")
    
    ranges = [[parse(Int64, e) for e in split(s, "-")] for s in ranges]
    ids = [parse(Int64, e) for e in ids]

    return ranges, ids

end

function build_interval_tree(ranges)
    root = IntervalTree(ranges[1][1], ranges[1][2], ranges[1][2], nothing, nothing)
    for i in 2:length(ranges)
        insert_node(root, ranges[i])
    end
    return root
end

function count_valid(root, ids)
    count = 0
    for id in ids
        if search_point(root, id)
            count += 1
        end
    end
    return count
end

open("./day5/input.txt", "r") do io
    s::String = read(io, String)
    ranges, ids = parse_input(s)
    root = build_interval_tree(ranges)
    count = count_valid(root, ids)
    println(count)

end

# root = IntervalTree(17, 19, 19, nothing, nothing)
# insert_node(root, [5, 8])
# insert_node(root, [4, 8])
# insert_node(root, [15, 18])
# insert_node(root, [7, 10])
# insert_node(root, [21, 24])
