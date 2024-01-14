include("../../sl_common.jl")

grid = readGrid("input.txt")
l = size(grid)[1]

struct State
    p::Pos
    m::BitMatrix
end

q = State[]
marked = falses(size(grid))
marked[1, 2] = true # block entry

push!(q, State(Pos(2, 2), marked))

forced_dir = Dict(
    '>' => [right],
    '^' => [up],
    '<' => [left],
    'v' => [down],
    '.' => dirs
)

soln = typeof(marked)[]
while !isempty(q)
    state = pop!(q)
    cur = state.p
    marked = state.m
    marked[cur] = true

    if cur == Pos(l, l-1)
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

# 1974: too low