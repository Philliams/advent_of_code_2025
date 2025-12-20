function parse_input(s)
    println(s)
    blocks = split(s, "\r\n\r\n")

    shapes = parse_shape.(blocks[1:end-1])
    problems = parse_problems(blocks[end])

    return shapes, problems
end

function check_tiling_valid(shapes, problem)
    total_area = reduce(*, problem[1])
    shape_areas = sum.(shapes)
    needed_area = sum(problem[2] .* shape_areas)
    return needed_area <= total_area
    
end

function parse_shape(block)
    lines = split(block, "\r\n")
    rows = [
        split(replace(e, "#" => 1, "." => 0), "")
        for e in lines[2:end]
    ]

    m = reduce(hcat, rows)
    return transpose(parse.(Int64, m))
end

function parse_problems(block)
    lines = split(block, "\r\n")
    problem_defs = []
    for l in lines
        tmp = split(l, ":")
        size = tmp[1]
        shape_counts = tmp[2]
        size = parse.(Int64, split(size, "x"))
        count = parse.(Int64, split(shape_counts, " ")[2:end])

        append!(problem_defs, [(size, count)])
    end
    return problem_defs
end


open("./day12/input.txt", "r") do io
    s::String = read(io, String)
    shapes, problems = parse_input(s)
    result = map(x -> check_tiling_valid(shapes, x), problems)
    println(sum(result))
end