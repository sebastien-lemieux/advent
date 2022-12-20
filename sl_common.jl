
## Common functions...

#between(x, low, high) = x ≥ low && x ≤ high
#int(str) = parse(Int, str)
incr(d, x) = d[x] = get(d, x, 0) + 1
Base.parse(::Type{UnitRange}, s::AbstractString) = UnitRange(parse.(Int, split(s, "-"))...)

Pos = CartesianIndex{2}
Base.parse(::Type{CartesianIndex}, s::AbstractString) = CartesianIndex(parse.(Int, split(s, ","))...)
Base.sign(p::Pos) = Pos(sign.(Tuple(p)))

function readFile(transf, fn::String, resType = Array{Any,1})
    allRes = resType()
    open(fn) do f
        while !eof(f)
            push!(allRes, transf(readline(f)))
        end
    end
    return allRes
end

readFile(fn::String, resType = Array{Any,1}) = readFile(identity, fn, resType)

struct StrIndex
    str2id::Dict{String, Int32}
    id2str::Vector{String}

    StrIndex(vs::Vector{String}) = new(Dict(vs[i] => i for i = 1:length(vs)), vs) # must be uniqued!
end

## indexing
Base.getindex(idx::StrIndex, s::String) = idx.str2id[s]
Base.getindex(idx::StrIndex, i::Integer) = idx.id2str[i]
Base.getindex(idx::StrIndex, v::AbstractVector{String}) = [idx[s] for s in v]
Base.getindex(idx::StrIndex, v::AbstractVector{<:Integer}) = [idx[i] for i in v]
Base.getindex(idx::StrIndex, v::AbstractVector{<:Bool}) = idx.id2str[v]
Base.length(idx::StrIndex) = length(idx.id2str)
