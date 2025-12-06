# O(n^2) in the number of ranges, O(1) in the spans
# a hashmap might instead be O(nm) for n ranges and m span size
# this is for good for few large spans, hashmap might be better for many small spans
function merge_ranges(ranges)
    i = 0
    while true
        i += 1
        for j in i+1:length(ranges)
            if overlaps(ranges[i], ranges[j])
                ranges[i] = [
                    min(ranges[i][1], ranges[j][1]),
                    max(ranges[i][2], ranges[j][2])
                ]
                deleteat!(ranges, j)
                i = 0
                break
            end
        end
        
        if i > length(ranges)
            return ranges
        end
    end
    
end

function overlaps(a, b)
    if a[2] < b[1]
        return false
    elseif a[1] > b[2]
        return false
    else
        return true
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

function count_total_items(disjoint_ranges)
    count::Int64 = 0
    for r in disjoint_ranges
        count += (r[2] - r[1]) + 1
    end
    return count
end


open("./day5/input.txt", "r") do io
    s::String = read(io, String)
    ranges, ids = parse_input(s)
    disjoint_ranges = merge_ranges(ranges)
    count = count_total_items(disjoint_ranges)
    
    println(count)
end