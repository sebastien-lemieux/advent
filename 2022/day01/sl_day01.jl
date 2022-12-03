include("../../sl_common.jl")

data = readFile("input.txt") do line
    if line == ""
        return -1
    else
        return parse(Int, line)
    end
end
push!(data, -1)

the_max = 0
tmp_sum = 0
for it in data
    if it == -1
        the_max = max(the_max, tmp_sum)
        tmp_sum = 0
    else
        tmp_sum += it
    end
end
the_max

## Part 2

maxs = Vector{Int}()
tmp_sum = 0
for it in data
    if it == -1
        push!(maxs, tmp_sum)
        tmp_sum = 0
    else
        tmp_sum += it
    end
end

sum(sort(maxs, rev=true)[1:3])