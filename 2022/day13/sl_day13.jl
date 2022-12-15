comesfirst(left::Int, right::Int) = (left < right) ? +1 : (left > right) ? -1 : 0
comesfirst(left::Vector, right::Int) = comesfirst(left, [right])
comesfirst(left::Int, right::Vector) = comesfirst([left], right)

function comesfirst(left::Vector, right::Vector)
    # println("Comparing $(left) with $(right)")

    if isempty(left)
        isempty(right) && return 0
        return +1
    else
        isempty(right) && return -1
    end
    tmp = comesfirst(first(left), first(right))
    tmp != 0 && return tmp
    return comesfirst(left[2:end], right[2:end])
end

i = 1
the_sum = 0
f = open("input.txt")
while !eof(f)
    left = eval(Meta.parse(readline(f)))
    right = eval(Meta.parse(readline(f)))
    readline(f)
    println("$(left) <-> $(right)")
    comesfirst(left, right) == +1 && (the_sum += i)
    i += 1
end

the_sum # 5557

## Part 2

all_data = []
f = open("input.txt")
while !eof(f)
    push!(all_data, eval(Meta.parse(readline(f))))
    push!(all_data, eval(Meta.parse(readline(f))))
    readline(f)
end
push!(all_data, [[2]]) ## 301
push!(all_data, [[6]]) ## 302

o = sortperm(all_data, lt=(a, b) -> comesfirst(a, b) == +1)
findfirst(o .== 301) * findfirst(o .== 302) ## 22425