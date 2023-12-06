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

function map(v::Vector{Vector{Map}}, i)
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

maps, seeds = open("input.txt") do f
    tmp = split(readline(f), ":")[2]
    seeds = parse.(Int, split(tmp))

    v = Vector{Vector{Map}}()
    while !eof(f)
        push!(v, parseBlock(f))
    end
    return v, seeds
end


min([map(maps, s) for s in seeds]...)
