function max_voltage(s::String, n::Int64)

    digits::Vector{Int64} = zeros(Int64, n)
    indices::Vector{Int64} = zeros(Int64, n+1)
    numerals::Vector{Int64} = [parse(Int64, e) for e in s]
    sum::Int64 = 0
    
    for i in 1:n
        for j in indices[i] + 1:length(s) - n + i
            if numerals[j] > digits[i]
                digits[i] = numerals[j]
                indices[i+1] = j
            end
        end
    end

    for i in 0:n-1
        sum += digits[end-i] * (10^(i))
    end
    return sum

end

open("./day3/input.txt", "r") do io
    sum::Int64 = 0
    for line in eachline(io)
        sum += max_voltage(line, 2)
    end
    println(sum)
end