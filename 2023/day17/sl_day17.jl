include("../../sl_common.jl")

m = readGrid("test.txt") do c
    parse(Int, c)
end

using DataStructures

struct Path
    path::Vector{Pos}
    dir::Pos
    fwd_left::Int
    heat::Int
end
Path(p, d) = Path(p, d, 3, 0)
# left_turn(p::Path) = Path(p.path, turn_left(p.dir), p.fwd_left, p.heat)
# right_turn(p::Path) = Path(p.path, turn_right(p.dir), p.fwd_left, p.heat)
DataStructures.enqueue!(q::PriorityQueue{Path, T}, p::Path) where T <: Number = enqueue!(q, p, p.heat)

function update_heat(g, p)
    cur = last(p.path)
    iswithin(cur, size(g)) && p.fwd_left ≥ 1 && return [Path(p.path, p.dir, p.fwd_left, p.heat + g[cur])]
    return Path[]
end

move(p::Path, dir) = Path(vcat(p.path, last(p.path) + dir), dir, (dir == p.dir) ? (p.fwd_left - 1) : 3, p.heat)
move(p::Path) = move(p, p.dir)

nrow, ncol = size(m)
best = PriorityQueue{Path, Real}()

enqueue!(best, Path([Pos(1, 1)], right))
enqueue!(best, Path([Pos(1, 1)], down))

mem = Dict{Tuple{Pos, Pos, Int}, Path}()

while !isempty(best)
    cur = dequeue!(best)

    # l = [move(cur),
    #      move(cur, left_turn(cur.dir)) |> move,
    #      move(cur, right_turn(cur.dir)) |> move]

    l = [move(cur),
    move(cur, left_turn(cur.dir)),
    move(cur, right_turn(cur.dir))]

    for p in (reduce(l; init=Path[]) do ch, p
            return vcat(ch, update_heat(m, p))
        end)
        key = (last(p.path), p.dir, p.fwd_left)
        cont = false
        if key ∈ keys(mem)
            mem[key].heat > p.heat && (mem[key] = p; cont = true)
        else
            mem[key] = p
            cont = true
        end

        cont && last(p.path) != Pos(nrow, ncol) && enqueue!(best, p)
    end

end

theBest = nothing
for k ∈ keys(mem)
    k[1] != Pos(nrow, ncol) && continue
    println("$k -> $(mem[k].heat)")
    if theBest === nothing
        theBest = mem[k]
    else
        mem[k].heat < theBest.heat && (theBest = mem[k])
    end
end
theBest.heat


