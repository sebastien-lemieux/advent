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

function visit(g, so_far, lava, time)
    pos = last(so_far)
    best = lava
    best_path = so_far
    for i=1:length(g.v)
        i ∈ so_far && continue
        new_time = time - g.e[pos, i] - 1
        new_time < 0 && continue
        tmp, path = visit(g, [so_far; [i]], lava + new_time * g.reward[i], new_time)
        if tmp > best
            best = tmp
            best_path = path
        end
    end
    return best, best_path
end

visit(g2, [1], 0, 30)


# Part 1: 1862
