function is_valid(s)::Bool

    if length(s) % 2 == 1
        return true
    end

    n::Int32 = floor(Int64, length(s) / 2)

    for i in 1:n
        if s[i] != s[n+i]
            return true
        end
    end

    return false

end

open("./day2/input.txt", "r") do io
    sum::Int64 = 0
    l::Int64 = 0
    u::Int64 = 0
    for line in eachline(io)
        strings = split(line, '-')
        l = parse(Int64, strings[1])
        u = parse(Int64, strings[2])
        for n in l:u
            if !is_valid(string(n))
                sum += n
            end
        end
    end
    println(sum)
end