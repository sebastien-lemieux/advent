include("../../sl_common.jl")

pf = readGrid(identity, "input.txt")

nrow, ncol = size(pf)

function computeLoad(pf)
    total = 0
    for j=1:ncol
        load = nrow
        for i=1:nrow
            if pf[i, j] == 'O'
                total += load
                load -= 1
            elseif pf[i, j] == '#'
                load = nrow - i
            end
        end
    end
    return total
end

## Part 2

function pushNorth!(pf)
    nrow, ncol = size(pf)
    for j=1:ncol
        load = nrow
        for i=1:nrow
            # println(pf[i,j])
            if pf[i, j] == 'O'
                pf[i, j] = '.'
                pf[(nrow - load + 1), j] = 'O'
                load -= 1
            elseif pf[i, j] == '#'
                load = nrow - i
            end
        end
    end
end

rotate(g) = [g[size(g)[1] - j + 1, i] for i=1:size(g)[1], j=1:size(g)[2]]
rotate(g, n) = (n == 0) ? g : rotate(rotate(g), n - 1)

# look for cycle

function findConfig(pf, nStep)
    g = copy(pf)
    g = rotate(g, 3)
    for i=1:nStep
        g = rotate(g)
        pushNorth!(g)
    end
    g = rotate(g, (((-nStep % 4)+5)%4))
    return g
end

function findCycle(pf)
    d = Dict{Matrix{Char}, Int}()

    g = copy(pf)
    id = 1
    while true
        g = findConfig(g, 4)

        if haskey(d, g)
            return d[g], id
        else
            d[g] = id
        end
        id += 1
    end
end

function computeLoad(pf)
    total = 0
    for i=1:size(pf)[1], j=1:size(pf)[2]
        pf[i, j] == 'O' && (total += size(pf)[1] - i + 1)
    end
    return total
end

from, to = findCycle(pf)

nStep = (1000000000 - from) % (to - from) + from

findConfig(pf, 4*nStep) |> computeLoad
# [findConfig(pf, 4*i) |> computeLoad for i=1:20] |> println