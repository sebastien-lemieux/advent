include("../sl_common.jl")

struct Cube{N} ## An N-dimensional cube
    v::NTuple{N, Int}
end
struct BBox{N}
    low::Cube{N}
    high::Cube{N}
end

import Base.min, Base.max, Base.-, Base.+, Base.hash
Cube(c...) = Cube(Tuple(c))
Base.hash(c::Cube, h::UInt) = hash(c.v)
Base.isequal(a::Cube, b::Cube) = Base.isequal(a.v, b.v)
-(a::Cube, b::Int) = Cube(a.v .- b)
+(a::Cube, b::Int) = Cube(a.v .+ b)
min(a::Cube, b::Cube) = Cube(min.(a.v, b.v))
max(a::Cube, b::Cube) = Cube(max.(a.v, b.v))
update(b::BBox, c::Cube) = BBox(min(b.low, c-1), max(b.high, c+1))
function all_iters(a::Cube{N}, b::Cube{N}) where N
    [a.v[i]:b.v[i] for i=1:N]
end

function set_active(a::Set{Cube{N}}, b::BBox{N}, coord::Cube{N}) where N
    push!(a, coord)
    return update(b, coord)
end

function initialize(fn::String, N::Int)
    active = Set{Cube{N}}()
    bbox = BBox(Cube(ntuple(x -> 1, N)), Cube(ntuple(x -> 1, N)))

    lines = readFile(collect, fn)
    m = length(lines[1])
    n = length(lines)

    v = zeros(Int, N)
    for i in 1:n
        v[1] = i
        for j in 1:m
            v[2] = j
            if lines[i][j] == '#'
                bbox = set_active(active, bbox, Cube(v...))
            end
        end
    end
    return active, bbox
end

enum_coord(low::Cube, high::Cube) =
    Set{Cube}([Cube(i) for i=collect(Iterators.product(all_iters(low, high)...))[:]])
enum_coord(b::BBox) = enum_coord(b.low, b.high)

neighbors(c::Cube) = delete!(enum_coord(c-1, c+1), c)

function next_cycle()
    global bbox
    next_active = typeof(active)()
    for c in enum_coord(bbox)
        nb_active = length(intersect(neighbors(c), active))
        # println("$c = $nb_active")
        if c in active
            if between(nb_active, 2, 3)  bbox = set_active(next_active, bbox, c) end
        else
            if nb_active == 3  bbox = set_active(next_active, bbox, c) end
        end

    end
    return next_active
end

active, bbox = initialize("input.txt", 3) ## part 1, N=3; part 2, N=4

for i in 1:6
    println("Starting cycle $i with $(length(active)) active cubes...")
    active = next_cycle()
end

println(length(active))
