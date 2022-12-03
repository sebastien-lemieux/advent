include("../../sl_common.jl")


round(a::Int, b::Int) = ((a == b) ? 3 : ((((a+1)%3) == b) ? 6 : 0)) + (b+1)


data = readFile("input.txt") do line
    println(line)
    round(line[1] - 'A', line[3] - 'X')
end

sum(data)

## Part 2

data = readFile("input.txt") do line
    # println(line)
    opp = line[1] - 'A'
    res = line[3] - 'Y'
    play = (opp + res + 3) % 3
    # println("$(opp), $(res) = $(play)")
    return round(opp, play)
end

