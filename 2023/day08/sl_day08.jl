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

## part 2

cur_v = [k for k in keys(registry) if k[3] == 'A']

function find_loop(cur)
    i = 0
    z = Dict{Int, Int}()
    while true
        mi = i % length(inst)
        if cur[3] == 'Z'
            if haskey(z, mi)
                z = filter(p -> p.second >= z[mi], z)
                return z, i - z[mi]
            else
                z[i%length(inst)] = i
            end
        end

        d = inst[mi + 1]
        cur = registry[cur][(d == 'L') ? 1 : 2]
        i += 1
    end
end

[t[2] for t in find_loop.(cur_v)] |> lcm
