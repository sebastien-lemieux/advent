include("../sl_common.jl")

struct Cube
    x::Int
    y::Int
    z::Int
end
struct BBox
    low::Cube
    high::Cube
end

import Base.min, Base.max, Base.-, Base.+
-(a::Cube, b::Int) = Cube(a.x - b, a.y - b, a.z - b)
+(a::Cube, b::Int) = Cube(a.x + b, a.y + b, a.z + b)
min(a::Cube, b::Cube) = Cube(min(a.x, b.x), min(a.y, b.y), min(a.z, b.z))
max(a::Cube, b::Cube) = Cube(max(a.x, b.x), max(a.y, b.y), max(a.z, b.z))
update(b::BBox, c::Cube) = BBox(min(b.low, c-1), max(b.high, c+1))

function set_active(a::Set{Cube}, coord::Cube)
    push!(a, coord)
    global bbox = update(bbox, coord)
end

active = Set{Cube}()
bbox = BBox(Cube(1, 1, 1), Cube(1, 1, 1))

lines = readFile(collect, "input.txt")
m = length(lines[1])
n = length(lines)

for i in 1:n
    for j in 1:m
        (lines[i][j] == '#') && set_active(active, Cube(i, j, 0))
    end
end

function enum_coord(low::Cube, high::Cube)
    Set{Cube}([Cube(x, y, z) for x=low.x:high.x for y=low.y:high.y for z=low.z:high.z])
end
enum_coord(b::BBox) = enum_coord(b.low, b.high)
function neighbors(c::Cube)::Set{Cube}
    r = enum_coord(c-1, c+1)
    delete!(r, c)
    return r
end

function next_cycle()
    next_active = Set{Cube}()
    for c in enum_coord(bbox)
        nb_active = length(intersect(neighbors(c), active))
        # println("$c = $nb_active")
        if c in active
            between(nb_active, 2, 3) && set_active(next_active, c)
        else
            nb_active == 3 && set_active(next_active, c)
        end

    end
    return next_active
end

for _ in 1:6
    active = next_cycle()
end

println(length(active))
