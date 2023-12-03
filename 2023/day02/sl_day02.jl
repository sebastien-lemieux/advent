include("../../sl_common.jl")

gameId(line) = parse(Int, split(line)[2])
parseGame(line) = split(line, ";")
parsePull(line) = split(line, ",")
function parseCount(line)
    l = split(line)
    return parse(Int, l[1]), l[2]
end
testCount(c, d) = d[c[2]] < c[1]

## part 1

d = Dict(
    "red" => 12,
    "blue" => 14,
    "green" => 13
)

theSum = 0

possible = readFile("input.txt") do line
    println(line)
    a, b = split(line, ":")
    id = gameId(a)

    for p in parsePull.(parseGame(b))
        println(any([testCount(c, d) for c in parseCount.(p)]))
    end

    any([any([testCount(c, d) for c in parseCount.(p)])
         for p in parsePull.(parseGame(b))]) ? 0 : id
end


## part 2

readFile("input.txt") do line
    println(line)
    a, b = split(line, ":")
    id = gameId(a)

    d = Dict(
        "red" => 0,
        "blue" => 0,
        "green" => 0)

    for p in parsePull.(parseGame(b))
        for c in parseCount.(p)
            d[c[2]] = max(d[c[2]], c[1])
        end
    end
    d |> values |> prod
end |> sum
