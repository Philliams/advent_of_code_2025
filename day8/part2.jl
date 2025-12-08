mutable struct Cluster
    elements::Set{Int64}
    edges::Vector{Vector{Int64}}
end

function parse_input(s::String)
    lines = split(s, "\r\n")
    
    return transpose(reduce(hcat, parse_line.(lines)))

end

function parse_line(line)::Vector{Int64}
    return parse.(Int64, split(line, ','))
end

function get_clusters(positions, n)
    edges = []
    for i in 1:size(positions, 1)
        for j in i+1:size(positions, 1)
            v = positions[i, :]
            u = positions[j, :]
            dist = sum((v - u) .^ 2)
            append!(edges, [(dist, i, j)])
        end
    end

    sort!(edges, by = e -> e[1])
    # edges = edges[1:n]

    clusters::Dict{Int64, Cluster} = Dict()
    cluster_membership::Dict{Int64, Int64} = Dict()

    i = 0 # unique easy identifier
    for (d, a, b) in edges
        if !haskey(cluster_membership, a) & !haskey(cluster_membership, b)
            # create cluster and put them both in it
            c = Cluster(Set([a, b]), [[a, b]])
            clusters[i] = c
            cluster_membership[a] = i
            cluster_membership[b] = i

        elseif !haskey(cluster_membership, a)
            idx = cluster_membership[b]
            # attribute a to cluster b
            push!(clusters[idx].elements, a)
            append!(clusters[idx].edges, [[a, b]])
            cluster_membership[a] = idx

        elseif !haskey(cluster_membership, b)
            idx = cluster_membership[a]
            # attribute b to cluster a
            push!(clusters[idx].elements, b)
            append!(clusters[idx].edges, [[a, b]])
            cluster_membership[b] = idx
        else
            # combine clusters
            idx = cluster_membership[a]
            idy = cluster_membership[b]

            if idx != idy
                c = Cluster(
                    union(clusters[idx].elements, clusters[idy].elements),
                    vcat(clusters[idx].edges, clusters[idy].edges, [[a, b]])
                )

                delete!(clusters, idx)
                delete!(clusters, idy)

                for member in c.elements
                    cluster_membership[member] = i
                end

                clusters[i] = c
            else
                append!(clusters[idy].edges, [[a, b]])
            end

            
        end

        if length(clusters) == 1
            idx = cluster_membership[a]
            if length(clusters[idx].elements) == size(positions, 1)
                return positions[a, 1] * positions[b, 1]
            end
        end

        i+= 1

    end

    sizes = vcat([length(c.elements) for c in values(clusters)], [1, 1, 1])
    sort!(sizes)

    return reduce(*, sizes[end-2:end])

end

open("./day8/input.txt", "r") do io
    s::String = read(io, String)
    pos = parse_input(s)
    count = get_clusters(pos, 1000)
    println(count)
end
