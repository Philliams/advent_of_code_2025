function calculate_sum(s)
    # parse the input
    lines = split(s, "\r\n")
    numbers = lines[1:end-1]
    ops = lines[end]

    chars = stack(collect.(numbers); dims=1)

    code_pos = []
    for i in 1:length(ops)
        if ops[i] != ' '
            append!(code_pos, i)
        end
    end
    append!(code_pos, size(chars, 2) + 2)
    
    # calculate the solution
    sum_::Int64 = 0
    for i in 1:length(code_pos) - 1
        op = ops[code_pos[i]]
        vals = chars[:, code_pos[i]:code_pos[i+1] - 2]
        numbers = map(row -> parse(Int64, join(row, "")), eachcol(vals))

        if op == '*'
            sum_ += reduce(*, numbers)
        else
            sum_ += reduce(+, numbers)
        end

    end

    return sum_

end

open("./day6/input.txt", "r") do io
    s::String = read(io, String)
    sum_ = calculate_sum(s)
    println(sum_)
end