include("../sl_common.jl")

lines = readFile("input.txt")

timestamp = int(lines[1])
bus_id = map(int, filter(str -> str != "x", split(lines[2],",")))

wait_time = map(id -> id - (timestamp % id), bus_id)

tmp_bus = bus_id[argmin(wait_time)]
tmp_time = min(wait_time...)

println("$(tmp_bus * tmp_time)") ## 115

## part 2

bus_id = map(str -> str == "x" ? 0 : int(str), split(lines[2],","))

id = Vector{Int}()
et = Vector{Int}()

for i in 1:length(bus_id)
    if bus_id[i] != 0
        push!(id, bus_id[i])
        push!(et, i - 1)
    end
end

r = ((id .- et) .% id .+ id) .% id  ## reminders

# display(hcat(id, r))  ## bus_id with reminders to look for

function find_compat(r1, b1, r2, b2)
    # first timestamp compatible with 1 and 2
    while r1 % b2 != r2
        r1 += b1
    end
    return r1
end

function find_sol(id, r)
    curr_id = id[1]
    curr_rm = r[1]

    for i in 2:length(id)
        # println("$i : $curr_rm")
        next_rm = find_compat(curr_rm, curr_id, r[i], id[i])
        curr_id = curr_id * id[i]
        curr_rm = next_rm
    end
    return curr_rm
end

@time println(find_sol(id, r))
