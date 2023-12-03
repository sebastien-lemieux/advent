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
    @view(mat[(i-1):(i+1), (j-1):(j+1)]) .= val
end

mb = fill(false, n, n)
for i in eachindex(IndexCartesian(), mb)
    if !(isdigit(mc[i]) || mc[i] == '.')
        tagNeighbors(mb, true, i)
    end
end

theSum = 0
str = ""

dealWith(str, theSum) = begin
    println("$str, $theSum, $(parse(Int, str))")
    isempty(str) ? theSum : (theSum + parse(Int, str))
end

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

# not 9474340