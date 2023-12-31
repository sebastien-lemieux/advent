include("../../sl_common.jl")

farm = readGrid("test.txt")

function takeStep!(cur, farm, p)
    new_p = [p+d for d in [up, down, left, right]]
    new_p = filter(np -> (inBounds(farm, np) && farm[np] != '#'), new_p)
    push!(cur, new_p...)
end

cur = Set(filter(p -> farm[p] == 'S', CartesianIndices(farm)))

for i=1:64
    new_cur = Set{Pos}()
    for p in cur
        takeStep!(new_cur, farm, p)
    end
    # println("$i ($(length(new_cur))): $new_cur")
    cur = new_cur
end

length(cur)

## Part 2

curc = Dict{Pos, Int}()

function bringInBounds(grid, p::Pos)::Pos
    function _tmp(i)
        x = p[i] - 1 # zero-based
        theMax = size(grid)[i]
        ((x < 0) ? ceil(Int, -x / theMax) * theMax + x : x % theMax) + 1
    end
    Pos([_tmp(i) for i=1:length(p)]...)
end
# bringInBounds(farm, CartesianIndex(-10000000, 1))


function takeStep!(curc, farm, p, prev_count)
    # new_p = [bringInBounds(farm, p+d) for d in [up, down, left, right]]
    new_p = [p+d for d in [up, down, left, right]]

    new_p = filter(np -> farm[np] != '#', new_p)
    for np in new_p
        incr(curc, np, prev_count)
    end
end

# p = CartesianIndex(0, 6)

curc = Dict{Pos, Int}()
curc[filter(p -> farm[p] == 'S', CartesianIndices(farm))...] = 1
prev = 1
last_seen = empty(curc)
last_count = empty(curc)
loop = Dict{Pos, NTuple{2, Int}}()
theCount = empty(loop)
nbGarden = count(∈(['.', 'S']), farm)

for i=1:50
    new_curc = empty(curc)
    # borders = empty(curc)
    for (p, c) in curc
        new_p = [p+d for d in [up, down, left, right]]
        for np in new_p
            farm[bringInBounds(farm, np)] == '#' && continue
            new_curc[np] = 1
            !inBounds(farm, np) && continue
            if haskey(last_seen, np)
                if !haskey(loop, np)
                    loop[np] = (last_seen[np], i)
                    theCount[np] = (last_count[np], length(curc))
                end
            else
                last_seen[np] = i
                last_count[np] = length(curc)
            end
        end
    end
    # centered = empty(new_curc)
    # for (p, c) in new_curc
    #     centered[bringInBounds(farm, p)] = get(centered, p, 0) + c
    # end

    if length(loop) == nbGarden
        periods = [l[2] - l[1] for l in values(loop)]
        theLcm = lcm(periods...)

    else
        pred = 0
    end

    println("$i: $(length(new_curc)) $(length(loop)) $(length(new_curc) - prev)")
    curc = new_curc
    prev = length(curc)
end