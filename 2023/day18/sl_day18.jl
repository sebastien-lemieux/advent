include("../../sl_common.jl")

struct Inst
    start::Pos
    dir::Dir
    dist::Int
    color::String
end
Inst(dir, dist, color) = Inst(Pos(0, 0), dir, dist, color)

function Base.parse(::Type{Inst}, str::T) where T<:AbstractString
    m = match(r"(.) (\d+) \(#(......)\)", str)
    Inst(parse(Dir, m[1]), parse(Int, m[2]), m[3])
end

m = parse(Inst, "R 6 (#4d17d2)")

inst = readFile(line -> parse(Inst, line), "input.txt", Vector{Inst})

function dig(cur, trench, inst::Inst)
    println(typeof(cur))
    push!(trench, Inst(cur, inst.dir, inst.dist, inst.color))
    return cur + inst.dist * inst.dir, trench
end

function dig(cur, v::Vector{Inst})
    trench = Vector{Inst}()
    cur = Pos(0, 0)
    for inst in v
        cur, trench = dig(cur, trench, inst)
    end
    return cur, trench
end

new_cur, trench = dig(Pos(0, 0), inst)

using StatsBase
using DataStructures

theMean = mean([i.start + (i.dist÷2) * i.dir for i in trench])

# function fill(p::Pos, trench)
#     q = Queue{Pos}(); enqueue!(q, p)
#     inside = Set{Pos}()
#     while !isempty(q)
#         p = dequeue!(q)
#         p ∈ trench && continue
#         if p ∉ inside
#             push!(inside, p)
#             for d in values(dirDict)
#                 enqueue!(q, p+d)
#             end
#         end
#     end
#     return inside
# end

# i = fill(theMean, trench)

# length(i) + length(trench)

## Part 2

function extract(i::Inst)
    theDir = "RDLU"
    d = parse(Int, "0x$(i.color[1:5])")
    code = parse(Int, "0x$(i.color[6])") + 1
    dir = parse(Dir, "RDLU"[code:code])
    return Inst(dir, d, i.color)
end

# extract(parse(Inst, "R 6 (#4d17d2)"))

inst2 = [extract(i) for i in inst]

new_cur, trench = dig(Pos(0, 0), inst2)

# [i.dist * i.start[2] * i.dir[1] for i in trench] |> sum

function computeArea(trench)
    l = length(trench)
    area = 0
    for j = 1:l
        i = (j+l-2)%l+1 # before
        k = (j)%l+1     # after
        i_dir = trench[i].dir
        j_dir = trench[j].dir
        k_dir = trench[k].dir
        println("$i $j $k $(trench[j].dir)")
        mod = 0
        d = 0
        new_d = 0
        if j_dir == down
            d = trench[j].dist
            i_dir == right && k_dir == left && (d += 1)
            i_dir == left && k_dir == right && (d -= 1)
            mod = d * trench[j].start[2]
            new_d = d - trench[j].dist
        elseif j_dir == up
            d = trench[j].dist
            i_dir == right && k_dir == left && (d -= 1)
            i_dir == left && k_dir == right && (d += 1)
            mod = -d * (trench[j].start[2] - 1)
            new_d = d - trench[j].dist
        end
        println("$j -> $mod ($area) : $new_d")
        area += mod
    end
    return area
end

computeArea(trench)