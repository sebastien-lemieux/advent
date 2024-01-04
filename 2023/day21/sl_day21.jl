include("../../sl_common.jl")

using DataStructures

include("../../sl_common.jl")
using DataStructures, CairoMakie, StatsBase

farm = readGrid("input.txt")
width = size(farm)[1] # For a square matrix

warp(i::Int, width::Int)::Int = ((i - 1) % width + width) % width + 1
warp(i::Pos, width::Int)::Pos = Pos(warp(i[1], width), warp(i[2], width))

function showGrid(farm, pos)
    g = copy(farm)
    g[pos |> collect] .= 'O'
    println(g)
end

function computeCounts(farm::Matrix{Char}, n::Int)
    width = size(farm)[1] # For a square matrix
    active = Set{Pos}([Pos((width+1)÷2, (width+1)÷2)])
    last_active = empty(active)
    theCounts = [1] # there's any implicit 1 at theCounts[0]
    theF = Int[]

    for i=1:n
        new_active = empty(active)
        for p in active
            for d in [up, down, left, right]
                farm[warp(p+d, width)] == '#' && continue
                p+d ∈ last_active && continue
                push!(new_active, p+d)
            end
        end

        push!(theCounts, (i>1) ? (theCounts[i-1] + length(new_active)) : length(new_active))
        # println("$i: $(last(theCounts)) $(length(new_active))")
        # showGrid(farm, new_active)
        last_active = active
        active = new_active

        f = 0
        if length(theCounts) > 4width + 1
            a = theCounts[end - 4width]
            b = theCounts[end - 2width]
            c = theCounts[end]
            d = b-a
            e = c-b
            f = e-d
            push!(theF, f)
        end
        println("$i: $(last(theCounts)) $(length(new_active)) $f")

    end
    return theCounts, theF
end

@time theCounts, f = computeCounts(farm, 12width)

x = 2:length(theCounts)
y = theCounts[x] - theCounts[x .- 1]
lines(x, y)

obj = 26501365 + 1
# obj = 5000 + 1

base = length(theCounts)
r = 2width - ((obj - base) % 2width)
base -= r
nb = (obj - base) ÷ 2width

a = theCounts[base - 4width]
b = theCounts[base - 2width]
c = theCounts[base]
# d = b-a
# e = c-b
# f = e-d # This is constant after a while...

# new_e = e + f
# new_c = 2c - b + f
# new_c = 2c - b + (c-b)-(b-a) = 3c - 3b + a

# Recurrence: fa(n) = 3 fa(n-1) - 3 fa(n-2) + fa(n-3)
# Characteristic eq: r^3 - 3r^2 + 3r - 1 = 0
# Roots: r - 1 = 0
# Solution: fa(n) = (α10 + α11 n + α12 n^2) * r^n = α10 + α11 n + α12 n^2
# a = [1 0 0], b = [1 1 1], c = [1 2 4]
α10, α11, α12 = Matrix{Int}([1 0 0; 1 1 1; 1 2 4] \ [a; b; c;;])

fa(n) = α10 + α11 * n + α12 * n^2

fa(2+nb)
