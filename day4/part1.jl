function parse_input_to_matrix(s)
    lines = split(s, "\r\n")
    n = length(lines)
    m = length(lines[1])

    arr = zeros(Int32, n + 2, m + 2)
    
    for i in 1:n
        for j in 1:m
            if lines[i][j] == '@'
                arr[i+1, j+1] = 1
            end
        end
    end

    return arr

    

end

function count_accessible(arr)

    n = size(arr, 1)
    m = size(arr, 2)

    count = 0

    for i in 2:n-1
        for j in 2:m-1
            if arr[i, j] == 1
                if sum(arr[i-1:i+1, j-1:j+1]) < 5
                    count += 1
                end
            end
        end
    end
    return count
end

open("./day4/input.txt", "r") do io
    s::String = read(io, String)
    arr = parse_input_to_matrix(s)
    count = count_accessible(arr)
    println(count)
end