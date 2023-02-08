include("../../sl_common.jl")

struct Valve
    name::String
    rate::Int
    tunnels::Vector{String}
end

struct Graph
    v::StrIndex
    reward::Vector{Int}
    e::Matrix{Int}
end

data = readFile("input.txt", Vector{Valve}) do line
    name, rate, tunnels = match(r"Valve (.*) has flow rate=(.*); tunnels? leads? to valves? (.*)", line)
    return Valve(name, parse(Int, rate), split(tunnels, ", "))
end

sort!(data, by = v -> v.name)

function fw_algo!(e::Matrix{Int})
    n = first(size(e))
    for i=1:n, j=1:n
        i == j && continue
        for k=1:n
            (k == i || k == j) && continue
            e[i, j] = min(e[i, j], e[i, k] + e[k, j])
            # println("$i $j $k old = $(e[i, j]) new = $(e[i, k] + e[k, j]) update = $(new_e[i, j])")
        end
    end
end

function Graph(data::Vector{Valve})
    v = StrIndex([x.name for x in data])
    n = length(v)
    reward = [x.rate for x in data]
    e = fill(999, (n,n))
    [e[i, i] = 0 for i=1:n]
    for valve in data
        e[v[valve.name], v[valve.tunnels]] .= 1
    end
    for i = 1:n
        fw_algo!(e)
    end
    return Graph(v, reward, e)
end

g = Graph(data)

function compress_graph(g::Graph)
    o = findall(g.reward .> 0)
    pushfirst!(o, 1)
    n = length(o)
    v = StrIndex(g.v[o])
    reward = g.reward[o]
    e = [g.e[o[i], o[j]] for i=1:n, j=1:n]
    return Graph(v, reward, e)
end

g2 = compress_graph(g)

function visit(g, so_far_m, so_far_e, lava, time_m, time_e)
    rand() < 0.00001 && println("$so_far_m  $so_far_e")
    pos_m = last(so_far_m)
    pos_e = last(so_far_e)
    best = lava
    best_path_m = so_far_m
    best_path_e = so_far_e
    for i=1:length(g.v)
        (i ∈ so_far_m || i ∈ so_far_e) && continue
        new_time_m = time_m - g.e[pos_m, i] - 1
        new_time_m < 0 && continue
        tmp, path_m, path_e = visit(g, [so_far_m; [i]], so_far_e, lava + new_time_m * g.reward[i], new_time_m, time_e)
        if tmp > best
            best = tmp
            best_path_m = path_m
            best_path_e = path_e
        end
    end
    for i=1:length(g.v)
        (i ∈ so_far_m || i ∈ so_far_e) && continue
        new_time_e = time_e - g.e[pos_e, i] - 1
        new_time_e < 0 && continue
        tmp, path_m, path_e = visit(g, so_far_m, [so_far_e; [i]], lava + new_time_e * g.reward[i], time_m, new_time_e)
        if tmp > best
            best = tmp
            best_path_m = path_m
            best_path_e = path_e
        end
    end
    return best, best_path_m, best_path_e
end

visit(g2, [1], [1], 0, 26, 26)


# Part 1: 1862
# Part 2: 2422