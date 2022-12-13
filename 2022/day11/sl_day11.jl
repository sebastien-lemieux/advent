mutable struct Monkey
    items::Vector{Int}
    op::Function
    div::Int
    throw_true::Int
    throw_false::Int
    active::Int
end

function readmonkey(s::IO)::Monkey
    readline(s)
    n_items = parse.(Int, split(readline(s)[19:end], ", "))
    n_op = eval(Meta.parse("old -> $(readline(s)[20:end])"))
    n_div = parse(Int, readline(s)[22:end])
    n_true = parse(Int, readline(s)[30:end]) + 1
    n_false = parse(Int, readline(s)[31:end]) + 1
    readline(s)
    return Monkey(n_items, n_op, n_div, n_true, n_false, 0)
end

f = open("input.txt")
m = Vector{Monkey}()
while !eof(f)
    push!(m, readmonkey(f))
end

master_div = prod(x -> x.div, m)

# for i=1:20 ## part 1
for i=1:10000
        for current in m
        while !isempty(current.items)
            it = popfirst!(current.items)
            current.active += 1
            # it = floor(Int, current.op(it) / 3) ## part 1
            it = current.op(it) % master_div
            if (it % current.div == 0)
                push!(m[current.throw_true].items, it)
                # println("Throw $(it) to monkey $(current.throw_true).")
            else
                push!(m[current.throw_false].items, it)
                # println("Throw $(it) to monkey $(current.throw_false).")
            end
        end
    end
end

sort(m, by= x->x.active, rev=true)[1:2]
## 303 * 298 # 90294 # part 1
136847 * 132782 # 18170818354



# 59768 too low