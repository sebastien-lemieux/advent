include("../sl_common.jl")

lines = readFile("input.txt")

groups = map(join, split(lines, ""))

## Part 1

theSum = 0
for g in groups
    c = zeros(Int, 26)
    foreach(ch -> c[ch - 'a' + 1] += 1, g)
    theSum += length(filter(tmp -> tmp > 0, c))
end

println(theSum)

## Part 2

groups = split(lines, "")
fillTable!(t, str) = foreach(ch -> t[ch - 'a' + 1] += 1, str)

theSum = 0
for g in groups
    c = zeros(Int, 26)
    foreach(p -> fillTable!(c, p), g)
    theSum += length(filter(tmp -> tmp == length(g), c))
end

println(theSum)
