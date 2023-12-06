include("../../sl_common.jl")

struct Map
    dst::Int
    src::Int
    r::Int
end

function map(m::Map, i)
    Δ = i - m.src
    (Δ >= 0 && Δ < m.r) && return m.dst + Δ
    return i
end

function map(v::Vector{Map}, i)
    for m in v
        tmp = map(m, i)
        (tmp != i) && return tmp
    end
    return i
end

VVM = Vector{Vector{Map}}
function map(v::VVM, i)
    for vm in v
        i = map(vm, i)
    end
    return i
end

function parseBlock(f)
    line = readline(f)
    while line == ""
        line = readline(f)
    end
    println("Ignored line: $line")

    v = Vector{Map}()
    while (line = readline(f)) != ""
        push!(v, Map(parse.(Int, split(line))...))
    end
    return v
end

maps, seeds = open("test.txt") do f
    tmp = split(readline(f), ":")[2]
    seeds = parse.(Int, split(tmp))

    v = VVM()
    while !eof(f)
        push!(v, parseBlock(f))
    end
    return v, seeds
end


min([map(maps, s) for s in seeds]...)

## Part 2

locations = []

for i=1:2:length(seeds)
    base = seeds[i]
    r = seeds[i+1]

    for s in base:(base + r - 1)
        push!(locations, map(maps, s))
    end
end

#ouch!