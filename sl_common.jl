
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
