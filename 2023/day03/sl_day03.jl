include("../../sl_common.jl")

v = readFile("input.txt", Vector{String})
# Assumes square matrix

n = length(v)

mc = Matrix{Char}(undef, n, n)
for (i, l) in enumerate(v)
    mc[i, :] .= collect(l)
end

# No symbols on borders

function tagNeighbors(mat::Matrix{T}, val::T, c::CartesianIndex) where T
    i, j = Tuple(c)
    @view(mat[(i-1):(i+1), (j-1):(j+1)]) .= [val]
end

mb = fill(false, n, n)
mg = fill(CartesianIndex(0, 0), n, n)
for i in eachindex(IndexCartesian(), mc)
    if !(isdigit(mc[i]) || mc[i] == '.')
        tagNeighbors(mb, true, i)
    end
    mc[i] == '*' && (tagNeighbors(mg, i, i); println(i))
end

## part 1

theSum = 0
str = ""

dealWith(str, theSum) = (isempty(str) ? theSum : (theSum + parse(Int, str)))

for i in 1:n
    tag = false
    for j in 1:n
        c = mc[i, j]
        if isdigit(c)
            str *= c
            mb[i, j] && (tag = true)
        else
            tag && (theSum = dealWith(str, theSum))
            str = ""
            tag = false
        end
    end
    tag && (theSum = dealWith(str, theSum))
end

theSum

## part 2

d = empty(Dict(), CartesianIndex, Vector{Int})
dealWith(str, c::CartesianIndex) = push!(get!(d, c, valtype(d)()), parse(Int, str))

for i in 1:n
    tag = CartesianIndex(0, 0)
    for j in 1:n
        c = mc[i, j]
        if isdigit(c)
            str *= c
            mg[i, j] != CartesianIndex(0, 0) && (tag = mg[i, j])
        else
            tag != CartesianIndex(0, 0) && dealWith(str, tag)
            str = ""
            tag = CartesianIndex(0, 0)
        end
    end
    tag != CartesianIndex(0, 0) && (theSum = dealWith(str, tag))
end

map(prod, [x for x in values(d) if length(x) == 2]) |> sum