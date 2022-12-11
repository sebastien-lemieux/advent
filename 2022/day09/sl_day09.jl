include("../../sl_common.jl")

struct Pos
    x::Int
    y::Int
end

Base.:*(a::Pos, b::Int) = Pos(a.x * b, a.y * b)
Base.:+(a::Pos, b::Pos) = Pos(a.x + b.x, a.y + b.y)
Base.:-(a::Pos, b::Pos) = Pos(a.x - b.x, a.y - b.y)
Base.sign(a::Pos) = Pos(sign(a.x), sign(a.y))
diag_dist(p::Pos) = max(abs(p.x), abs(p.y))
dir = Dict("U" => Pos(0, 1), "D" => Pos(0, -1), "L" => Pos(-1, 0), "R" => Pos(1, 0))

head = Pos(0, 0)
tail = Pos(0, 0)
record = Set{Pos}()
push!(record, Pos(0, 0))

function adjust_once(h, t)
    new_t = t + sign(h - t)
    # new_t == head && return t
    push!(record, new_t)
    return new_t
end


readFile("input.txt") do line
    global head, tail
    tmp = split(line)
    n = parse(Int, tmp[2])
    d = dir[tmp[1]]
    println(d, n)
    head += d * n
    while diag_dist(head - tail) > 1
        tail = adjust_once(head, tail)
    end
end; # 6313 too low

a = Pos(1,1)
f!(b) = (b *= 2)
a
f!(a)
a