include("../../sl_common.jl")

Cube = Tuple{Int, Int, Int}

cubes = readFile("input.txt", Vector{Cube}) do line
    Cube(parse.(Int, split(line, ','))) .+ 2
end

function adjacent(a, b)
    sum(abs.(a .- b)) == 1
end

n_adj = 0
for i=1:length(cubes)
    for j=(i+1):length(cubes)
        if adjacent(cubes[i], cubes[j])
            n_adj += 1
        end
    end
end

length(cubes) * 6 - n_adj * 2 # 3496

## Part 2

pos = falses(22, 22, 22)
for c in cubes
    pos[c...] = true
end

function process!(c, pos, n)
    if min(c...) ≥ 1 && max(c...) ≤ 22 && !pos[c...]
        push!(n, c)
        pos[c...] = true
    end
end

function neighbors!(c, pos)
    n = Vector{Cube}()
    (i, j, k) = c
    dirs = [a .* b for a in [-1, 1] for b in [(0,0,1), (0,1,0), (1,0,0)]]
    for d in dirs
        process!(c .+ d, pos, n)
    end
    return n
end

ext = [Cube((1, 1, 1))]
pos[1, 1, 1] = true

while !isempty(ext)
    c = pop!(ext)
    println(c)
    push!(ext, neighbors(c, pos)...)
end

cavities = filter(c -> !pos[c...], [Cube((i, j, k)) for i=1:22 for j=1:22 for k=1:22])

n_int = 0
for i=1:length(cubes)
    for j=1:length(cavities)
        if adjacent(cubes[i], cavities[j])
            n_int += 1
        end
    end
end

length(cubes) * 6 - n_adj * 2 - n_int # 2064
