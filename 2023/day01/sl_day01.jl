include("../../sl_common.jl")

f = readFile("input.txt", Vector{String})

d = Dict(
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9,
)

Base.min(x::UnitRange) = x
Base.max(x::UnitRange) = x 

function dealWith(c::Char, fl)
    b = parse(Int, c)
    a = fl.first
    a == -1 && (a = b)
    return (first = a, last = b)
end

function dealWith(s::String, fl)
    isempty(s) && return fl
    f, l = fl
    a = filter(!isnothing, findfirst.(keys(d), s))
    b = filter(!isnothing, findlast.(keys(d), s))
    f == -1 && !isempty(a) && (f = d[s[min(a...)]])
    !isempty(b) && (l = d[s[max(b...)]])
    return (first=f, last=l)
end

theSum = 0

for s in f
    str = ""
    t = :Digit
    fl = (first = -1, last = -1)
    for c in s
        if isdigit(c)
            fl = dealWith(str, fl)
            fl = dealWith(c, fl)
            str = ""
        else
            str *= c
        end
    end
    fl = dealWith(str, fl)
    theSum += fl.first * 10 + fl.last
end

theSum