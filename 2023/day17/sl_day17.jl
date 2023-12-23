include("../../sl_common.jl")

using DataStructures

struct Path
    path::Vector{Pos}
    dir::Pos
    fwd_left::Int
    heat::Int
end
Path(p, d) = Path(p, d, 10, 0)
DataStructures.enqueue!(q::PriorityQueue{Path, T}, p::Path) where T <: Number = enqueue!(q, p, p.heat)

function update_heat(g, p)
    cur = last(p.path)
    prev = p.path[end-1]
    if iswithin(cur, size(g)) && (p.fwd_left ≥ 0)
        cur == prev && return [Path(p.path, p.dir, p.fwd_left, p.heat)]
        return [Path(p.path, p.dir, p.fwd_left, p.heat + g[cur])]
    else
        return Path[]
    end
end

move(p::Path, dir) = ((dir == p.dir) ? Path(vcat(p.path, last(p.path) + dir), dir, p.fwd_left - 1, p.heat) :
                                       Path(vcat(p.path, last(p.path)), dir, 10, p.heat))
move(p::Path) = move(p, p.dir)

function search(m)
    nrow, ncol = size(m)
    best = PriorityQueue{Path, Real}()

    enqueue!(best, Path([Pos(1, 1)], right))
    enqueue!(best, Path([Pos(1, 1)], down))

    mem = Dict{Tuple{Pos, Pos, Int}, Path}()

    while !isempty(best)
        cur = dequeue!(best)

        l = [move(cur)]
        (cur.fwd_left ≤ 6) && (last(cur.path) != Pos(nrow, ncol)) && push!(l, move(cur, left_turn(cur.dir)))
        (cur.fwd_left ≤ 6) && (last(cur.path) != Pos(nrow, ncol)) && push!(l, move(cur, right_turn(cur.dir)))

        for p in (reduce(l; init=Path[]) do ch, p
                return vcat(ch, update_heat(m, p))
            end)

            key = (last(p.path), p.dir, p.fwd_left)
            
            (last(p.path) == Pos(nrow, ncol)) && (p.fwd_left > 6) && continue
            
            cont = false
            if key ∈ keys(mem)
                (mem[key].heat > p.heat) && (mem[key] = p; cont = true)
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
        if theBest === nothing
            theBest = mem[k]
        else
            mem[k].heat < theBest.heat && (theBest = mem[k])
        end
    end
    theBest, mem
end

function display(g, p::Path)
    nrow, ncol = size(m)
    for i=1:nrow
        for j=1:ncol
            if Pos(i, j) ∈ p.path
                print('.')
            else
                print(g[i, j])
            end
        end
        println()
    end
end

m = readGrid("input.txt") do c
    parse(Int, c)
end

theBest, mem = search(m)
theBest.heat
display(m, theBest)

## 1006: too low
## 1010: finalement!
## 1023: wrong
## 1028: wrong
## 1035: wrong
## 1063: too high
## 1064: too high



