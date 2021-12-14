include("../../sl_common.jl")

struct Pos
    h::Int
    d::Int
end

inst = Dict("forward" => (p, X) -> Pos(p.h + X, p.d),
            "up"      => (p, X) -> Pos(p.h, p.d - X),
            "down"    => (p, X) -> Pos(p.h, p.d + X))


open("sl_input.txt") do f
    cur = Pos(0, 0)
    for line in split.(eachline(f))
        cur = inst[line[1]](cur, parse(Int, line[2]))
        println(cur)
    end
    println(cur.h * cur.d) ## 1499229
end

## Part 2

struct Pos2
    p::Pos
    a::Int ## aim
end

inst = Dict("forward" => (p, X) -> Pos2(Pos(p.p.h + X, p.p.d + p.a * X), p.a),
            "up"      => (p, X) -> Pos2(p.p, p.a - X),
            "down"    => (p, X) -> Pos2(p.p, p.a + X))

open("sl_input.txt") do f
    cur = Pos2(Pos(0, 0), 0)
    for line in split.(eachline(f))
        cur = inst[line[1]](cur, parse(Int, line[2]))
        println(cur)
    end
    println(cur.p.h * cur.p.d) ## 1340836560
end


## low: 8995374