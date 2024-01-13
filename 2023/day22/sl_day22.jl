include("../../sl_common.jl")

struct PileP
    x::Int
    y::Int
    z::Int
end

struct Brick
    s::PileP
    e::PileP
end

function Base.parse(::Type{PileP}, str::AbstractString)
    x, y, z = parse.(Int, split(str, ","))
    return PileP(x+1, y+1, z)
end

function Base.parse(::Type{Brick}, str::String)
    s, e = parse.(PileP, split(str, "~"))
    return Brick(s, e)
end

bottom(b::Brick) = min(b.s.z, b.e.z)
top(b::Brick) = max(b.s.z, b.e.z)
blocks(b::Brick) = [PileP(x, y, bottom(b)) for x=b.s.x:b.e.x for y=b.s.y:b.e.y]

function settle(b::Brick, lastZ)
    s = b.s
    e = b.e

    max_z = maximum([lastZ[p.x, p.y] for p in blocks(b)])
    fall = bottom(b) - max_z - 1
    for p in blocks(b)
        lastZ[p.x, p.y] = max_z + (top(b) - bottom(b) + 1)
    end
    return lastZ, Brick(PileP(s.x, s.y, s.z - fall), PileP(e.x, e.y, e.z - fall))
end

function supports(a::Brick, b::Brick)
    bottom(b) - top(a) != 1 && return false
    pa = [Pos(p.x, p.y) for p in blocks(a)]
    pb = [Pos(p.x, p.y) for p in blocks(b)]
    return isempty(pa ∩ pb) ? false : true
end

bricks = readFile(s -> parse(Brick, s), "input.txt")
sort!(bricks, by=(b -> bottom(b)))

lastZ = zeros(Int, (10,10))
sbricks = empty(bricks)

l = length(bricks)
ontop = falses(l, l)
for b in bricks
    lastZ, new_b = settle(b, lastZ)
    for (i, a) in enumerate(sbricks)
        if supports(a, new_b)
            j = length(sbricks)+1
            ontop[j, i] = true
        end
    end
    push!(sbricks, new_b)
end

nsup = sum(ontop, dims=2) # number of supports below each brick
tmp = [sum(==(1), ontop[:,i] .* nsup) for i=1:l] # supporting a single support brick
sum(==(0), tmp)

