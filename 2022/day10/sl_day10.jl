include("../../sl_common.jl")

addz = [1]

readFile("input.txt") do line
    line = split(line, " ")
    if line[1] == "addx"
        push!(addz, 0)
        push!(addz, parse(Int, line[2]))
    else ## noop
        push!(addz, 0)
    end
end

X = cumsum(addz)
cycle = 1:length(X)
sum(X[20:40:end] .* cycle[20:40:end]) ## 17380

## Part 2

screen = fill(' ', (6, 40))

for i=1:length(cycle)
    col = cycle[i] % 40 + 1
    row = cycle[i] ÷ 40 + 1
    ((col-1) >= X[i] && (col-1) <= (X[i]+2)) && (screen[row, col] = '#')
end

screen # FGCUZREC (There is a glitch at [4,1]!)