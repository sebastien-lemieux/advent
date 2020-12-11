include("../sl_common.jl")

lines = readFile("input.txt", int, Vector{Int})
push!(lines, 0)
push!(lines, max(lines...) + 3)
lines = sort(lines)

n = length(lines)

## part 1

c = zeros(3)
for i in 2:n
    c[lines[i] - lines[i - 1]] += 1
end

println("$c -> $(c[1] * c[3])")

## part 2

mem = fill(-1, n) ## -1 == undefined
mem[n] = 1 ## prefilled base case

function countWays(from = 1)
    if mem[from] >= 0 return mem[from] end
    tmp::Int = 0
    foreach(to -> tmp += countWays(to),
      filter(to -> to <= n && (lines[to] - lines[from] <= 3),
        (from+1):(from+3)))
    mem[from] = tmp
    return tmp
end

countWays()
# 18512297918464
