include("../sl_common.jl")

lines = readFile("input.txt") do line
    split(line, " = ")
end

## part 1

let mem = Dict{Int, Int}(),
    mask = (or=0, and=0)

    for (left, right) in lines
        if left == "mask"
            f(r) = parse(Int, replace(right, "X" => r); base=2)
            mask = (or=f("0"), and=f("1"))
        else
            mem[int(left[5:end-1])] = int(right) & mask.and | mask.or
        end
    end

    println("$(sum(values(mem)))") ## 4297467072083
end

## part 2

function floating(str)
    length(str) == 0 && return [0]
    aux = floating(str[1:end-1])
    str[end] == 'X' && return hcat(copy(aux) .<< 1, copy(aux) .<< 1 .+ 1)
    return aux .<< 1 .+ int(str[end])
end

function apply_rules(val, mask)
    ## from int to 36-bit binary string
    str = (join ∘ map)(x -> x == 0 ? '0' : '1', reverse(digits(val, base=2, pad=36)))
    ## apply mask rules
    (join ∘ map)(zip(str, mask)) do (s, m)
        m == '0' ? s : m
    end
end

let mem = Dict{Int, Int}(),
    curr_mask = ""

    for (left, right) in lines
        if left == "mask"  curr_mask = right
        else ## assignation
            addr = apply_rules(int(left[5:end-1]), curr_mask)
            foreach(floating(addr)) do v mem[v] = int(right) end
        end
    end
    println("$(sum(values(mem)))") ## 5030603328768
end
