include("../../sl_common.jl")

struct Map
    src::Int
    s::Int
    r::Int
end

function map(m::Map, i)
    Δ = i - m.s
    (Δ >= 0 && Δ < m.r) && return m.src + Δ
    return i
end

VM = Vector{Map}
function map(v::VM, i)
    for m in v
        tmp = map(m, i)
        (tmp != i) && return tmp
    end
    return i
end

VVM = Vector{VM}
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

    v = VM()
    while (line = readline(f)) != ""
        push!(v, Map(parse.(Int, split(line))...))
    end
    return v
end

maps, seeds = open("input.txt") do f
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

struct Seq # A sequence of adjacent ID
    start::Int
    range::Int
end

source(m) = Seq(m.src, m.r)
dest(m) = Seq(m.dst, m.r)

start(s::Seq) = s.start
stop(s::Seq) = s.start + s.range - 1

# To sort at the end!
Base.isless(a::Seq, b::Seq) = start(a) < start(b) || (start(a) == start(b) && stop(a) < stop(b))
Base.:(==)(a::Seq, b::Seq) = start(a) == start(b) && stop(a) == stop(b)

function map(m::Map, s::Seq)
    src = source(m)
    dst = dest(m)
    (stop(s) < start(src) || stop(src) < start(s)) && return (Seq[], [Seq(start(s), s.range)])
    untransfered = Seq[]
    transfered = Seq[]

    # intersect + project
    i_start = max(start(s), start(src))
    i_offset = start(s) - start(src)
    (i_offset < 0) && (i_offset = 0)
    i_stop = min(stop(s), stop(src))
    push!(transfered, Seq(start(dst) + i_offset, i_stop - i_start + 1))

    (start(s) < start(src)) && push!(untransfered, Seq(start(s), start(src) - start(s)))
    (stop(s) > stop(src)) && push!(untransfered, Seq(stop(src) + 1, stop(s) - stop(src)))

    return (transfered, untransfered)
end


input = Seq[]

for i=1:2:length(seeds)
    push!(input, Seq(seeds[i], seeds[i+1]))
end


for vm in maps # through all parameters
    output = Seq[]
    while !isempty(input) # Use a stack to attempt to map each unmapped portions after split
        s = pop!(input)
        gotit = false
        for m in vm
            t, u = map(m, s)
            if !isempty(t)
                append!(output, t)
                append!(input, u)
                s = Seq(-1, -1)
                gotit = true
                break
            end
        end
        !gotit && push!(output, s)
    end
    input = output
end
sort(input)


# too high: 2060825227
# too high:  187421121
# got it:    125742456
