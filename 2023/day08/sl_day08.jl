include("../../sl_common.jl")

inst, registry = open("input.txt") do f
    registry = Dict{String, Tuple{String, String}}()

    inst = readline(f)
    readline(f)
    while !eof(f)
        line = readline(f)

        registry[line[1:3]] = (line[8:10], line[13:15])
    end
    return inst, registry
end

cur = "AAA"
i = 0
while cur != "ZZZ"
    d = inst[i % length(inst) + 1]
    println("$cur : $d -> $(registry[cur])")
    cur = registry[cur][(d == 'L') ? 1 : 2]
    i += 1
end
i

