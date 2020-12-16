include("../sl_common.jl")

seq = int.(split("0,14,6,20,1,4", ","))

while length(seq) < 2020
    m = (seq[1:end-1] .== seq[end])
    if any(m)
        tmp = collect(1:length(seq)-1)[m]
        push!(seq, length(seq) - max(tmp...))
    else
        push!(seq, 0)
    end
end
println(seq[2020]) ## 257

## part 2

# seq = int.(split("3,1,2", ","))
seq = int.(split("0,14,6,20,1,4", ","))

D = Dict{Int,Int}

function addToMem(mem::D, val::Int, i::Int)
    mem[val] = i
end

let mem = D(), a = collect(1:100)
    for (i, val) in enumerate(seq[1:end-1])
        addToMem(mem, val, i)
    end
    i = length(seq)
    last = seq[end]
    while i < 30000000
        val = (haskey(mem, last) ? (i - getindex(mem, last)) : 0)
        mem[last] = i
        i += 1
        # println("$i : $val")
        last = val
    end
    flush(stdout) ## Weird bug with Juno "eating" the following println without a flush :(
    println(stderr, last) ## 8546398
    # display(mem)
end
