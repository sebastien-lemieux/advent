include("../../sl_common.jl")

function next_layer(layer::T) where T <: AbstractArray
    res = T()
    all_zero = true
    for i in 2:length(layer)
        tmp = layer[i] - layer[i-1]
        push!(res, layer[i] - layer[i-1])
        all_zero && tmp != 0 && (all_zero = false)
    end
    return res, all_zero
end

function find_last(layer::T) where T <: AbstractArray
    println("lets go: $layer")
    next, all_zero = next_layer(layer)
    all_zero && return last(layer)
    l = find_last(next)
    println("$l layer: $(last(layer)) next: $(last(next))")
    last(layer) + l
end

function find_first(layer::T) where T <: AbstractArray
    next, all_zero = next_layer(layer)
    println("Lets go: $layer : $next")
    all_zero && return first(layer)
    l = find_first(next)
    println("$l layer: $(first(layer)) next: $(first(next))")
    first(layer) - l
end


hists = readFile("input.txt") do line
    z = parse.(Int, split(line))
    return find_first(z)
end |> sum

find_first([10, 13, 16, 21, 30, 45])
find_first([1, 3, 6, 10, 15, 21, 28])
find_first([0, 3, 6, 9, 12, 15])
