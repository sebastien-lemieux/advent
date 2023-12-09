using DataFrames

df = open("input.txt") do f
    read() = parse.(Int, split(split(readline(f), ":")[2]))
    DataFrame(times=read(), dist=read())
end

function nbPoss(T, D)
    compute_root(sign) = (-T + sign * sqrt(T^2 - 4D)) / -2
    return floor(Int, compute_root(-1)) - ceil(Int, compute_root(1)) + 1
end

nbPoss.(df.times, df.dist) |> prod


## part 2

df = open("input.txt") do f
    read() = parse.(Int, join(split(split(readline(f), ":")[2])))
    DataFrame(times=read(), dist=read())
end

nbPoss.(df.times, df.dist)
