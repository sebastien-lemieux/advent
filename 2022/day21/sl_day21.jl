include("../../sl_common.jl")

mutable struct Monkey
    name::String
    op::Function
    leftName::String
    rightName::String
    value::Union{Nothing, Int}
end

ops = Dict(
    '*' => *, '/' => ÷, '+' => +, '-' => -
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

function solve!(m::Monkey)
    if isnothing(m.value)
        a = solve!(monkeys[m.leftName])
        b = solve!(monkeys[m.rightName])
        m.value = m.op(a, b)
    end
    return m.value
end

solve!(monkeys["root"])

## part 2

function pathTo(current, to)
    m = monkeys[current]
    current == to && return [m]
    monkeys[current].op == identity && return nothing
    a = pathTo(m.leftName, to)
    b = pathTo(m.rightName, to)
    if isnothing(a)
        if isnothing(b)
            return nothing
        else
            return push!(b, m)
        end
    else
        return push!(a, m)
    end
end
stack = pathTo("root", "humn")

rev = Dict(
    Base.:+ => ((b, c) -> c-b, (a, c) -> c-a),
    Base.:÷ => ((b, c) -> b*c, (a, c) -> a÷c),
    Base.:- => ((b, c) -> c+b, (a, c) -> a-c),
    Base.:* => ((b, c) -> c÷b, (a, c) -> c÷a)
)


function findVal(m, val)
    m.name == "humn" && return val
    next = pop!(stack)
    a = monkeys[m.leftName].value
    b = monkeys[m.rightName].value
    c = val
    m.leftName == next.name && return findVal(next, rev[m.op][1](b, c))
    m.rightName == next.name && return findVal(next, rev[m.op][2](a, c))
end

root = pop!(stack)
next = pop!(stack)
if root.leftName == next.name
    findVal(next, monkeys[root.rightName].value)
end
