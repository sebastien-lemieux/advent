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

## Part 2 (part 1 in previous commit)

rope = fill(Pos(0, 0), 10)

record = Set{Pos}()
push!(record, rope[10])

function adjust_once(h::Pos, t::Pos, push::Bool)
    new_t = t + sign(h - t)
    push && push!(record, new_t)
    return new_t
end


readFile("input.txt") do line
    global rope
    tmp = split(line)
    n = parse(Int, tmp[2])
    d = dir[tmp[1]]
    # println(d, n)
    rope[1] += d * n
    done = false
    while !done
        done = true
        for i=2:10
            if diag_dist(rope[i-1] - rope[i]) > 1
                rope[i] = adjust_once(rope[i-1], rope[i], i == 10)
                done = false
            end
        end
    end
end;

record # 2504