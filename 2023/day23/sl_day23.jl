include("../../sl_common.jl")

grid = readGrid("input.txt")

# struct State
#     p::Pos
#     m::BitMatrix
# end

forced_dir = Dict(
    '>' => [right],
    '^' => [up],
    '<' => [left],
    'v' => [down],
    '.' => dirs
)

function find_path(grid, forced_dir)
    n = size(grid)[1]
    q = State[]
    marked = falses(size(grid))
    marked[1, 2] = true # block entry

    push!(q, State(Pos(2, 2), marked))

    soln = typeof(marked)[]
    while !isempty(q)
        state = pop!(q)
        cur = state.p
        marked = state.m
        marked[cur] = true

        if cur == Pos(n, n-1)
            push!(soln, marked)
            println("find solution #$(length(soln)): $(sum(last(soln))-1)")
        else
            for d in forced_dir[grid[cur]]
                next_p = cur + d
                (marked[next_p] || (grid[next_p] == '#')) && continue
                # println(next_p)
                push!(q, State(next_p, copy(marked)))
            end
        end
        # println("size q: $(length(q))")
        # length(q) > 10 && break
    end

    [sum(m)-1 for m in soln] |> maximum
end

find_path(grid, forced_dir)

# part 2
# using Revise

struct State
    p::Pos
    m::Matrix{Int}
end

# forced_dir = Dict(
#     '>' => dirs,
#     '^' => dirs,
#     '<' => dirs,
#     'v' => dirs,
#     '.' => dirs
# )

# function find_path(grid, forced_dir)
using DataStructures
grid = readGrid("test.txt")

n = size(grid)[1]
q = Deque{State}()
marked = fill(Int32(-1), size(grid))
marked[1, 2] = 99 # block entry
marked[2, 2] = 1

push!(q, State(Pos(2, 2), marked))

soln = typeof(marked)[]
while !isempty(q)
    state = popfirst!(q)
    cur = state.p
    marked = state.m
    l = marked[cur]

    # check if best at this Pos
    need_removed = false
    for s in q
        other_cur = s.p
        other_marked = s.m
        other_l = other_marked[other_cur]
        if other_marked[cur] >= l
            println("Die: $cur -> $other_cur, $(other_marked[cur]), $l")
            # show(stdout, other_marked)
            need_removed = true
            break
        end
    end
    need_removed && continue
    
    if cur == Pos(n, n-1)
        push!(soln, marked)
        println("find solution #$(length(soln)): $(l)")
    else
        for d in dirs # forced_dir[grid[cur]]
            next_p = cur + d
            grid[next_p] == '#' && continue
            if marked[next_p] < 0 # && marked[next_p] < l+1 # Avoid backing up
                tmp_m = copy(marked)
                tmp_m[next_p] = l+1
                push!(q, State(next_p, tmp_m))
                println(next_p)
            end
        end
    end
    # println("size q: $(length(q))")
    # length(q) > 4 && break
end

[m[n,n-1] for m in soln] |> maximum
# end

# find_path(grid, forced_dir)
include("../../sl_common.jl")
using Graphs: DiGraph, Graph, add_vertices!, add_vertex!, add_edge!, neighbors, nv, degree, ne
using Compose, Colors, GraphPlot, DataStructures

struct State
    p::Pos
    m::Matrix{Bool}
end

grid = readGrid("input.txt")
n = size(grid)[1]
grid[1, 2] = '#'
grid[n, n-1] = '#'
g = DiGraph{Int32}()

nodes = Pos[]
add_vertices!(g, 2)
push!(nodes, Pos(2, 2), Pos(n-1, n-1))

for i=2:n-1, j=2:n-1
    p = Pos(i, j)
    grid[p] == '#' && continue
    count = 0
    for d in dirs
        grid[p + d] != '#' && (count += 1)
    end
    if count > 2
        push!(nodes, p)
        add_vertex!(g)
    end
end

function find_path(grid, nodes, a, b)
    n = size(grid)[1]
    q = State[]
    marked = falses(size(grid))
    marked[a] = true

    push!(q, State(a, marked))
    println("start: $a  end: $b")

    while !isempty(q)
        state = pop!(q)
        cur = state.p
        marked = state.m
        # println(cur)

        if cur == b
            return sum(marked)-1
            # if tmp_l < best_length
            #     best_length = tmp_l
            # end
        elseif cur != a && cur ∈ nodes
            # drop this State
        else
            for d in dirs
                next_p = cur + d
                (marked[next_p] || (grid[next_p] == '#')) && continue
                tmp_m = copy(marked)
                tmp_m[next_p] = true
                push!(q, State(next_p, tmp_m))
            end
        end
        # println("size q: $(length(q))")
        # length(q) > 10 && break
    end

    return nothing
end

# edg = Dict{Tuple{Int, Int}, Int}()
max_dist = 500
capacity = zeros(Int32, nv(g), nv(g))
for i=1:length(nodes), j=i+1:length(nodes)
    tmp_l = find_path(grid, nodes, nodes[i], nodes[j])
    if tmp_l !== nothing
        add_edge!(g, i, j)
        add_edge!(g, j, i)
        capacity[i, j] = max_dist - tmp_l
        capacity[j, i] = max_dist - tmp_l
    end
end
le = [capacity[e.src, e.dst] for e in edges(g)]

Compose.set_default_graphic_size(1000px,1000px)
display(g, nodes, le) = gplot(g, nodelabel=1:length(nodes), edgelabel=le, edgelabelc=colorant"white", edgestrokec=colorant"blue")
display(g, nodes, le)

using GraphsFlows

flow, flow_matrix = GraphsFlows.push_relabel(g, 3, 32, capacity)
part1, part2, flow = GraphsFlows.mincut(g, 3, 32, capacity, PushRelabelAlgorithm())



deg = [degree(g, i) for i in 1:nv(g)]
deg[1] = 0
deg[2] = 10
fst = (1, 1, deg)
q = Deque{typeof(fst)}()
push!(q, fst)
best = 0
c = 0

while !isempty(q)
    cur, l, cdeg = popfirst!(q)
    (c % 1000 == 0) && println("cur: $cur, l:$l, $cdeg")
    if cur == 2 && l > best
        best = l+1
        println("Bingo: $best")
        continue
    end
    nb = neighbors(g, cur)
    println(nb)
    for i in nb
        # cur == 32 && println("testing $i")
        cdeg[i] == 0 && continue
        dg = copy(cdeg)
        dg[cur] = 0
        others = neighbors(g, i)
        invalid = false
        for o in others
            cur == 32 && println("o: $o")
            # println("dg[$o]: $(dg[o])")
            dg[o] == 0 && continue
            dg[o] -= 1
            if dg[o] == 1
                # cur == 32 && println("elimination of $i by $o")
                invalid = true
                break
            end
        end
        invalid && continue
        push!(q, (i, l + edg[(cur, i)], dg))
        # println("pushed $i")
        c += 1
    end
    # cur == 32 && break
    # c > 300 && break
end

best

# 5844: too low
# 5846: too low
# 6402: too low