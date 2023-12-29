include("../../sl_common.jl")

# struct Rule
#     var::Char
#     sign::Function
#     val::Int
#     dest::String
# end

function rule(str::AbstractString)
    # println("Parse: $str")
    m = match(r"(.)([\>\<])(\d+):([ARa-z]+)", str)
    return Meta.parse("(p::Part) -> (p.$(m[1]) $(m[2]) $(m[3])) ? (true, \"$(m[4])\") : (false, \"\")") |> eval
end

struct Pipeline{T <: AbstractString, U <: Function}
    name::T
    rules::Vector{U}
    default::T
end

function Pipeline(str::AbstractString)
    m = match(r"([a-z]+)\{(.*)\}", str)
    cond = split(m[2], ",")
    def = pop!(cond)
    Pipeline(m[1], [rule(str) for str in cond], def)
end

struct Part
    x::Int
    m::Int
    a::Int
    s::Int
end

function Part(str::AbstractString)
    m = match(r"{x=(\d+),m=(\d+),a=(\d+),s=(\d+)}", str)
    Part([parse(Int, s) for s in m]...)
end

Base.sum(p::Part) = p.x + p.m + p.a + p.s

function apply(pipe::Pipeline, part::Part)
    for r in pipe.rules
        t, d = r(part)
        t && return d
    end
    return pipe.default
end

function accept(pipes, part)
    cur = "in"
    while cur ∉ ["A", "R"]
        # println(cur)
        cur = apply(pipes[cur], part)
    end
    return (cur == "A") ? true : false
end

a, parts = readFile([s -> Pipeline(s), s -> Part(s)], [Pipeline, Part], "input.txt")
pipes = Dict([(p.name, p) for p in a])

accepted = [accept(pipes, p) for p in parts]
sum(sum.(parts[accepted]))

## Part 2

