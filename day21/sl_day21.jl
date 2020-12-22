include("../sl_common.jl")

lines = readFile("input.txt") do line
    (ing, _, alg, _) = match(r"^((\w+ )+\w+) \(contains ((\w+[, ]*)+)\)$", line).captures
    ing = split(ing, " ")
    alg = split(alg, ", ")
    println("[$ing] [$alg]")
    return (ing, alg)
end

d = Dict{String, Vector{Vector{String}}}()

for (ing, alg) in lines
    for a in alg
        tmp = get!(d, a, Vector{String}())
        push!(tmp, ing)
    end
end

algd = Dict{String, String}()

while length(algd) < length(d)
    for (a, ingv) in d
        tmp = setdiff(intersect(ingv...), values(algd))
        if length(tmp) == 1
            algd[a] = tmp[1]
        end
    end
end

algv = values(algd)
count = 0
for (ing, alg) in lines
    count += length(setdiff(ing, algv))
end
println(count) # Part 1: 2075
