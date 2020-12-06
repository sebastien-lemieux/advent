include("../sl_common.jl")

function seatId(str):Int  ## Convert binary to decimal
    id = 0
    for c in str
        id *= 2
        if c == 'B' || c == 'R'
            id += 1
        end
    end
    return id
end

allSeat = sort(readFile("input.txt", seatId, Array{Int, 1}))

## Part 1

println(max(allSeat))

## Part 2

shiftedId = (allSeat[1:end-1] .+ 1)             # missing seat ids
mask = allSeat[2:end] - shiftedId               # identify the empty seat(s)
println(filter(x -> x != 0, mask .* shiftedId)) # get id(s) of empty seat(s)
