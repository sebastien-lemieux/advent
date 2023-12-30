include("../../sl_common.jl")

# struct Rule
#     var::Char
#     sign::Function
#     val::T
#     dest::String
# end

function rule(str::AbstractString)
    # prTln("Parse: $str")
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

struct Part{T <: Integer}
    x::T
    m::T
    a::T
    s::T
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
        # prTln(cur)
        cur = apply(pipes[cur], part)
    end
    return (cur == "A") ? true : false
end

a, parts = readFile([s -> Pipeline(s), s -> Part(s)], "test.txt")
pipes = Dict([(p.name, p) for p in a])

accepted = [accept(pipes, p) for p in parts]
sum(sum.(parts[accepted]))

## Part 2

import Base: ∩, <

struct PartRange{T}
    x::UnitRange{T}
    m::UnitRange{T}
    a::UnitRange{T}
    s::UnitRange{T}
end

PartRange() = PartRange(1:4000, 1:4000, 1:4000, 1:4000)
PartRange(r::PartRange; x=r.x, m=r.m, a=r.a, s=r.s) = PartRange(x, m, a, s)
Base.length(a::PartRange) = length(a.x) * length(a.m) * length(a.a) * length(a.s)
Base.:∩(a::PartRange, b::PartRange) = PartRange(a.x ∩ b.x, a.m ∩ b.m, a.a ∩ b.a, a.s ∩ b.s)
Base.:∩(a::UnitRange, b::UnitRange) = max(first(a), first(b)):min(last(a), last(b))
Base.:<(a::UnitRange{T}, b::T) where T <: Integer = first(a):min(last(a), b - 1)
Base.:>(a::UnitRange{T}, b::T) where T <: Integer = max(first(a), b + 1):last(a)
Base.:<=(a::UnitRange{T}, b::T) where T <: Integer = first(a):min(last(a), b)
Base.:>=(a::UnitRange{T}, b::T) where T <: Integer = max(first(a), b):last(a)

function rule(str::AbstractString)
    m = match(r"(.)([\>\<])(\d+):([ARa-z]+)", str)
    # println("in rule: $m")
    rev = (m[2] == "<" ? ">=" : "<=")
    # println(rev)
            #    return "(p::PartRange) -> (PartRange(p, $(m[1])=(p.$(m[1]) $(m[2]) $(m[3]))), PartRange(p, $(m[1])=(p.$(m[1]) $rev $(m[3]))))"
    return Meta.parse("(p::PartRange) -> (\"$(m[4])\", PartRange(p, $(m[1])=(p.$(m[1]) $(m[2]) $(m[3]))), PartRange(p, $(m[1])=(p.$(m[1]) $rev $(m[3]))))") |> eval
end

struct PipelineRange{T <: AbstractString, U <: Function}
    name::T
    rules::Vector{U}
    default::T
end

function PipelineRange(str::AbstractString)
    m = match(r"([a-z]+)\{(.*)\}", str)
    # println("pipeline: $str => $m")
    # println("name: $(m[1])")
    cond = split(m[2], ",")
    def = pop!(cond)
    # println(cond)
    # println("name: $(m[1])")
    f = [rule(str) for str in cond]
    # return f
    # println("f: $f")
    PipelineRange(m[1], Function[rule(str) for str in cond], def)
end


a, parts = readFile([s -> PipelineRange(s), s -> Part(s)], "input.txt")
pipes = Dict([(p.name, p) for p in a])


st = [(PartRange(), pipes["in"])]
acc = PartRange[]

function dealWith(dst, p)
    if dst == "A"
        push!(acc, p)
    elseif dst != "R"
        push!(st, (p, pipes[dst]))
    end
end

while !isempty(st)
    cur, p = pop!(st)
    for r in p.rules
        dst, yes, no = r(cur)
        dealWith(dst, yes)
        cur = no
    end
    dealWith(p.default, cur)
end

acc
length.(acc) |> sum