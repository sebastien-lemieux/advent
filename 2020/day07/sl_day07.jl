include("../sl_common.jl")

rules = readFile("input.txt")

## Build graph

is_in = Dict{String, Vector{String}}()
contains = Dict{String, Vector{Tuple{Int, String}}}()

for rule in rules
    m = match(r"(.*) bags contain (.*)\.", rule)
    (parent, children) = m.captures
    children = split(children, ", ")
    if children[1] != "no other bags"
        for child in children
            m = match(r"([0-9]+) (.*) bags?", child)
            (nb_str, color) = m.captures
            nb = int(nb_str)
            if haskey(is_in, color)
                push!(is_in[color], parent)
            else
                is_in[color] = [parent]
            end
            if haskey(contains, parent)
                push!(contains[parent], (nb, color))
            else
                contains[parent] = [(nb, color)]
            end
        end
    end
end

println(is_in)

## Part 1

active = ["shiny gold"]
done = []

while length(active) > 0
    curr = pop!(active)
    if !(curr in done)
        if haskey(is_in, curr)
            push!(active, is_in[curr]...)
        end
        curr != "shiny gold" && push!(done, curr)
    end
end

println(length(done))

## Part 2

function countBags(color)
    theSum = 1
    if !haskey(contains, color)
        return theSum
    end
    for (nb, bag) in contains[color]
        println("$nb $bag")
        theSum += nb * countBags(bag)
    end
    return theSum
end

countBags("shiny gold") - 1
