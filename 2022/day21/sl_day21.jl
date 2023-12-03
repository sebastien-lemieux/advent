include("../../sl_common.jl")

mutable struct Monkey
    name::String
    op::Function
    leftName::String
    rightName::String
    value::Union{Nothing, Int}
end

ops = Dict(
    '*' => *, '/' => /, '+' => +, '-' => -
)

function Monkey(str::String)
    length(str) == 17 && return Monkey(str[1:4], ops[str[12]], str[7:10], str[14:17], nothing)
    Monkey(str[1:4], identity, "", "", parse(Int, str[7:end]))
end

monkeys = Dict{String, Monkey}()

readFile("input.txt", Vector{Monkey}) do str
    m = Monkey(str)
    monkeys[m.name] = m
end

using DataStructures
solved(m::Monkey) = !isnothing(m.value)
solve!(m::Monkey) = m.value = m.op(monkeys[m.leftName].value, monkeys[m.rightName].value)

q = Queue{String}()
for (name, monkey) in monkeys
    !solved(monkey) && enqueue!(q, monkey.name)
end

while !isempty(q)
    m = monkeys[dequeue!(q)]
    if all(solved.([monkeys[m.leftName], monkeys[m.rightName]]))
        solve!(m)
        println(m)
    else
        enqueue!(q, m.name)
        println(q)
    end
end