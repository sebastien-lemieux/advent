include("../../sl_common.jl")

m = hcat(readFile(line -> collect(line) .== '#', "input.txt")...)

nrow, ncol = size(m)
gpos = [pos for pos in CartesianIndices(m) if m[pos]]

erow = [i for i in 1:nrow if !any(m[i,:])]
ecol = [i for i in 1:ncol if !any(m[:,i])]

Base.abs(a::CartesianIndex{2}) = CartesianIndex(abs(a[1]), abs(a[2]))
dist(a, b) = sum(Tuple(abs(a - b)))

function expanded(a, b, mult = 2)
    d = dist(a, b)
    l1, h1 = minmax(a[1], b[1])
    l2, h2 = minmax(a[2], b[2])
    d += sum([l1 < x < h1 for x in erow]) * (mult - 1)
    return d + sum([l2 < x < h2 for x in ecol]) * (mult - 1)
end

theSum = 0
for i=1:length(gpos), j=(i+1):length(gpos)
    # println("$i - $j = $(dist(gpos[i], gpos[j]))")
    theSum += expanded(gpos[i], gpos[j])
end

theSum

## Part 2

theSum = 0
for i=1:length(gpos), j=(i+1):length(gpos)
    # println("$i - $j = $(dist(gpos[i], gpos[j]))")
    theSum += expanded(gpos[i], gpos[j], 1_000_000)
end

theSum

