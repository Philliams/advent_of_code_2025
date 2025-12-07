function parse_input(s)
    lines = split(s, "\r\n")
    numbers = lines[1:end-1]

    numbers = reduce(hcat, [
        [parse(Int64, e) for e in split(row)]
        for row in numbers
    ])

    ops = split(lines[end])

    return transpose(numbers), ops
end

function calculate_sum(numbers, ops)
    sum_ = 0
    for i in 1:length(ops)
        if ops[i] == "*"
            sum_ += reduce(*, numbers[:, i])
        else
            sum_ += reduce(+, numbers[:, i])
        end
    end
    return sum_
end

open("./day6/input.txt", "r") do io
    s::String = read(io, String)
    numbers, ops = parse_input(s)
    sum_ = calculate_sum(numbers, ops)
    println(sum_)
end