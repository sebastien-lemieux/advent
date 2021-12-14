include("../../sl_common.jl")

depths = readFile(s -> parse(Int, s), "sl_input.txt", Array{Int, 1})

# Part 1

sum(depths[2:end] .> depths[1:end-1]) ## 1167

# Part 2

windows = depths[1:end-2] .+ depths[2:end-1] .+ depths[3:end]
sum(windows[2:end] .> windows[1:end-1])