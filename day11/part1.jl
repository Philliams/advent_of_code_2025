function parse_input(s)
    lines = split(s, "\r\n")
    graph::Dict{String, Set{String}} = Dict("out" => Set())
    for l in lines
        l = split(l, ":")
        k = string(l[1])
        v = Set(string.(split(l[2])))
        graph[k] = v
    end
    display(graph)
    return graph
end

mutable struct Node
    incoming::Set{String}
    outgoing::Set{String}
end

function kahns_algorithm(edges)

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

    display(G)
    display(collect(keys(G)))
    L = []
    S = Set(filter!(k -> length(G[k].incoming) == 0, collect(keys(G))))
    # S = Set(["you"])

    while length(S) > 0
        n = first(S)
        delete!(S, n)
        append!(L, [n])
        for e in G[n]
            delete!(G[n], e)
            if length(G[n]) == 0
                push!(S, e)
            end
        end
    end

    return L

end

function count_paths(G)
    topological_order = kahns_algorithm(G)
    println(topological_order)
end

open("./day11/sample.txt", "r") do io
    s::String = read(io, String)
    G = parse_input(s)
    count = count_paths(G)
    
end
