include("../../sl_common.jl")

priority(c) = islowercase(c) ? (c - 'a' + 1) : (c - 'A' + 27)

the_sum = 0
readFile("input.txt") do line
    global the_sum
    l = length(line)
    the_sum += priority(intersect(line[1:(l÷2)], line[(l÷2+1):l])[1])
end
the_sum

# Part 2

sack = readFile("input.txt", Vector{String})

the_sum = 0
for i=1:3:length(sack)
    the_sum += priority(intersect(sack[i], sack[i+1], sack[i+2])[1])
end
the_sum