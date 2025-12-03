open("./day1/input.txt", "r") do io
    count::Int64 = 0
    pos::Int64 = 50
    newpos::Int64 = 0

    for line in eachline(io)

        delta = parse(Int64, line[2:end])

        if line[1] == 'R'
            newpos = pos + delta
            count += floor(Int64, newpos/100) - floor(Int64, pos/100)
        else
            newpos = pos - delta
            count += ceil(Int64, pos / 100) - ceil(Int64, newpos / 100)
        end

        pos = mod(newpos, 100)

    end
    println(count)
end