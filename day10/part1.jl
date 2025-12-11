using Combinatorics

function parse_lights(s)
    binary_string = replace(s, '#' => '1', "." => '0')[2:end-1]
    return parse(Int64, reverse(binary_string), base=2)
end

function parse_toggles(s)
    num::Int64 = 0
    digits = parse.(Int64, split(s[2:end-1], ","))
    return sum(2 .^ digits)
end

function parse_line(line)
    lights = parse_lights(line[1])
    switches = parse_toggles.(line[2:end-1])

    return lights, switches
end

function parse_input(s)
    lines = split.(split(s, "\r\n"), " ")
    return parse_line.(lines)
    
end

function count_toggles(sub_problem)
    target = sub_problem[1]
    toggles = sub_problem[2]

    iterator = powerset(toggles)
    iterator = Iterators.drop(iterator, 1)# discard null set
    for combination in iterator
        if reduce(xor, combination) == target
            return length(combination)
        end
    end
end

open("./day10/input.txt", "r") do io
    s::String = read(io, String)
    parsed_data = parse_input(s)
    totals = count_toggles.(parsed_data)
    println(sum(totals))
end
