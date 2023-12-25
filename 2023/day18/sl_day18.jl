include("../../sl_common.jl")

struct Inst
    dir::Dir
    dist::Int
    color::String
end

function Base.parse(::Type{Inst}, str::AbstractString)
    m = match(r"(.) (\d+) \(#(......)\)", str)
    Inst(parse(Dir, m[1]), parse(Int, m[2]), m[3])
end

# m = parse(Inst, "R 6 (#4d17d2)")

inst = readFile(line -> parse(Inst, line), "test.txt", Vector{Inst})

function dig(cur, trench, inst::Inst)
    inst.dist == 0 && return cur, trench
    new_pos = cur + inst.dir
    push!(trench, new_pos)
    return dig(new_pos, trench, Inst(inst.dir, inst.dist - 1, inst.color))
end

function dig(cur, trench, v::Vector{Inst})
    length(v) == 0 && return cur, trench
    new_cur, new_trench = dig(cur, trench, v[1])
    return dig(new_cur, new_trench, v[2:end])
end

cur = Pos(0, 0)
new_cur, trench = dig(cur, Set{Pos}(), inst)

using StatsBase
using DataStructures

theMean = mean(trench)

function fill(p::Pos, trench)
    q = Queue{Pos}(); enqueue!(q, p)
    inside = Set{Pos}()
    while !isempty(q)
        p = dequeue!(q)
        p ∈ trench && continue
        if p ∉ inside
            push!(inside, p)
            for d in values(dirDict)
                enqueue!(q, p+d)
            end
        end
    end
    return inside
end

i = fill(theMean, trench)

length(i) + length(trench)

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

cur = Pos(0, 0)
new_cur, trench = dig(cur, Set{Pos}(), inst2)
theMean = mean(trench)


fill(theMean, inst2)
