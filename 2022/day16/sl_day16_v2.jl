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

using OffsetArrays

function find_best(g2::Graph)
    # pool = collect(2:length(g2.v))
    n = length(g2.v)
    path = ones(Int, 0:n)
    lava = zeros(Int, 0:n)
    minutes = zeros(Int, 0:n)
    minutes[0] = 30
    path[0] = 1
    lava[0] = 0

    best = 0
    i=1
    while i > 0
        path[i] += 1
        if path[i] > n
            path[i] = 1
            i -= 1
        # elseif path[i] ∉ path[1:(i-1)]
        # elseif all(path[1:(i-1)] .!= path[i])
        else
            invalid = false
            for j=1:(i-1)
                if path[j] == path[i]
                    invalid = true
                    break
                end
            end
            invalid && continue
            # rand() < 0.000001 && println(path[1:i])
            minutes[i] = minutes[i-1] - g2.e[path[i-1], path[i]] - 1
            lava[i] = lava[i-1] + g2.reward[path[i]] * minutes[i]
            if minutes[i] ≥ 0
                best = max(best, lava[i])
            end
            minutes[i] > 0 && i < n && (i += 1)
        end

        # eval?
        
    end
    best
end

using BenchmarkTools
@btime find_best(g2)

using Profile
Profile.clear_malloc_data()
find_best(g2)

# g2

# struct Sol
#     open::Set{Int}
#     pos::Tuple{Int, Int}
#     left::Tuple{Int, Int}
# end

# mem = Dict{Sol, Int}()

# function visit(g::Graph, s::Sol, lava::Int)
#     # if haskey(mem, s)
#     #     println("dang!")
#     #     return mem[s]
#     # end
#     best = lava
#     for i=1:length(g.v)
#         (i ∈ s.open) && continue
#         new_left = s.left[1] - g.e[s.pos[1], i] - 1
#         if new_left >= 0
#             best = max(best, visit(g, Sol(union(s.open, i), (i, s.pos[2]), (new_left, s.left[2])), lava + g.reward[i] * new_left))
#         end
#         new_left = s.left[2] - g.e[s.pos[2], i] - 1
#         if new_left >= 0
#             best = max(best, visit(g, Sol(union(s.open, i), (s.pos[1], i), (s.left[1], new_left)), lava + g.reward[i] * new_left))
#         end
#     end
#     # print(".")
#     # mem[s] = best
#     return best
# end

# @time visit(g2, Sol(Set{Int}(), (1, 1), (26, 26)), 0)