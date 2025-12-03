open("./day1/input.txt", "r") do io
    count::Int16 = 0
    pos::Int16 = 50
    for line in eachline(io)

        if line[1] == 'R'
            pos = pos + parse(Int16, line[2:end])
        else
            pos = pos - parse(Int16, line[2:end])
        end

        pos = mod(pos, 100)

        if pos == 0
            count += 1
        end
    end
    println(count)
end