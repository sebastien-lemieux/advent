v = split(readline("input.txt"), ",")

aHash(str)::Int = reduce((h, c) -> 17 * (h + Int(c)) % 256, str; init=0)

aHash("HASH")

[aHash(str) for str in v] |> sum

## part 2

struct Lens
    label::String
    focal::Int
end

mutable struct Box
    pos::Dict{String, Int}
    lenses::Vector{Lens}
end

Box() = Box(Dict{String, Int}(), Lens[])

function reindex!(b::Box)
    b.pos = empty(b.pos)
    for (i,l) in enumerate(b.lenses)
        b.pos[l.label] = i
    end
end

function add!(b::Box, l::Lens)
    # println("Adding: $l")
    if haskey(b.pos, l.label)
        # println("replace")
        b.lenses[b.pos[l.label]] = l
    else
        # println("add: $l to $b")
        push!(b.lenses, l)
        b.pos[l.label] = length(b.lenses)
    end
end

function remove!(b::Box, label::AbstractString)
    if haskey(b.pos, label)
        deleteat!(b.lenses, b.pos[label])
        delete!(b.pos, label)
        reindex!(b)
    end
end

function apply!(str, b)
    h = aHash(match(r"(.*)[-=]", str)[1]) + 1
    box = b[h]
    # println("before: $box")
    if (m = match(r"(.*)=(.*)", str)) !== nothing
        # println("add: $str -> $m")
        add!(box, Lens(m[1], parse(Int, m[2])))
    elseif (m = match(r"(.*)-", str)) !== nothing
        # println("remove: $str -> $m")
        remove!(box, m[1])
    end
    # println("after: $box")
end

power(i, b::Box) = ([i * slot * l.focal for (slot, l) in enumerate(b.lenses)] |> sum)

b = [Box() for _=1:256];

[apply!(str, b) for str in v];
[power(i, box) for (i, box) in enumerate(b)] |> sum
