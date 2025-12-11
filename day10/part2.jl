using JuMP
import HiGHS

function parse_toggles_binary(switches, lights)
    n = length(split(lights, ","))
    toggles::Vector{Vector{Int64}} = []
    
    for s in switches
        v = zeros(Int64, n)
        for d in split(s[2:end-1], ",")
            v[parse(Int64, d) + 1] = 1
        end

        append!(toggles, [v])
    end

    return toggles

end

function parse_voltage(s)
    volts = parse.(Int64, split(s[2:end-1], ","))
    return volts
end

function parse_line(line)
    switches_binary = parse_toggles_binary(line[2:end-1], line[end])
    voltages = parse_voltage(line[end])

    return switches_binary, voltages
end

function parse_input(s)
    lines = split.(split(s, "\r\n"), " ")
    return parse_line.(lines)
    
end

function solve_problem(sub_problem)
    n = length(sub_problem[1])
    toggles_binary = reduce(hcat, sub_problem[1])
    voltages = sub_problem[2]

    

    # define our MILP
    model = Model(HiGHS.Optimizer)
    @variable(model, x[1:n] >= 0, Int) # x will be the count for each switch
    @constraint(model, toggles_binary * x == voltages)
    @objective(model, Min, sum(x))

    set_silent(model)
    optimize!(model)
    # assert_is_solved_and_feasible(model)
    # solution_summary(model)
    return sum(value(x))


end

open("./day10/input.txt", "r") do io
    s::String = read(io, String)
    parsed_data = parse_input(s)
    totals = solve_problem.(parsed_data)
    println(sum(totals))
end
