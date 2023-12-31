include("../../sl_common.jl")

farm = readGrid("input.txt")

function takeStep!(cur, farm, p)
    new_p = [p+d for d in [up, down, left, right]]
    new_p = filter(np -> (inBounds(farm, np) && farm[np] != '#'), new_p)
    push!(cur, new_p...)
end

cur = Set(filter(p -> farm[p] == 'S', CartesianIndices(farm)))

for i=1:64
    new_cur = Set{Pos}()
    for p in cur
        takeStep!(new_cur, farm, p)
    end
    # println("$i ($(length(new_cur))): $new_cur")
    cur = new_cur
end

length(cur)