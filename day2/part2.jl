using Primes

function is_invalid(s)::Bool

    # get all divisors except 1 and length(s)
    divs = divisors(length(s))[2:end]

    for num_blocks in divs
        block_size = length(s) ÷ num_blocks
        
        flag = true
        for i in 2:num_blocks
            if s[1:block_size] != s[1 + (i-1) * block_size:(i) * block_size]
                flag = false
                break
            end
        end

        if flag
            return flag
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
            if is_invalid(string(n))
                sum += n
            end
        end
    end
    println(sum)
end