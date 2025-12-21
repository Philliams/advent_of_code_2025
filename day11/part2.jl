function parse_input(s)
    lines = split(s, "\r\n")
    graph::Dict{String, Set{String}} = Dict("out" => Set())
    for l in lines
        l = split(l, ":")
        k = string(l[1])
        v = Set(string.(split(l[2])))
        graph[k] = v
    end
    return graph
end

mutable struct Node
    incoming::Set{String}
    outgoing::Set{String}
end

function build_graph(edges)

    G::Dict{String, Node} = Dict()

    for (k, v) in edges
        if !haskey(G, k)
            G[k] = Node(Set(), Set())
        end

        G[k].outgoing = union(G[k].outgoing, Set(v))
        for e in v
            if !haskey(G, e)
                G[e] = Node(Set(), Set())
            end
            push!(G[e].incoming, k)
        end
    end

    return G

end

function count_paths(G)
    graph = build_graph(G)

    # count all the paths from svr -> dac, then dac -> fft, then fft -> out
    lookup = Dict("svr" => 1)
    a1 = recurse_count_paths(graph, lookup, "dac")
    lookup = Dict("dac" => 1)
    a2 = recurse_count_paths(graph, lookup, "fft")
    lookup = Dict("fft" => 1)
    a3 = recurse_count_paths(graph, lookup, "out")

    # count all the pats from svr -> fft, then fft -> dac, then dac -> out
    lookup = Dict("svr" => 1)
    b1 = recurse_count_paths(graph, lookup, "fft")
    lookup = Dict("fft" => 1)
    b2 = recurse_count_paths(graph, lookup, "dac")
    lookup = Dict("dac" => 1)
    b3 = recurse_count_paths(graph, lookup, "out")

    return a1 * a2 * a3 + b1 * b2 * b3

end

function recurse_count_paths(G, lookup, n)

    for e in G[n].incoming
        if !haskey(lookup, e)
            lookup[e] = recurse_count_paths(G, lookup, e)
        end
    end

    return sum([lookup[e] for e in G[n].incoming])

end

open("./day11/input.txt", "r") do io
    s::String = read(io, String)
    G = parse_input(s)
    count = count_paths(G)
    println(count)
end
