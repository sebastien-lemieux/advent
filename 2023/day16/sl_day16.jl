include("../../sl_common.jl")

m = readGrid(identity, "input.txt")

struct Beam
    pos::Pos
    dir::Dir
end

move(b::Beam) = Beam(b.pos + b.dir, b.dir)

function modify!(g, nrj, b)
    nrow, ncol = size(g)
    # println("b = $b")
    # println("$(1 ≤ b.pos[1] ≤ nrow) - $(1 ≤ b.pos[2] ≤ ncol)")
    !((1 ≤ b.pos[1] ≤ nrow) && (1 ≤ b.pos[2] ≤ ncol)) && return Beam[]
    nrj[b.pos] = true
    res = Beam[b]
    let c = g[b.pos]
        if c == '|' && b.dir in [left, right]
            res = [Beam(b.pos, up), Beam(b.pos, down)]
        elseif c == '-' && b.dir in [up, down]
            res = [Beam(b.pos, left), Beam(b.pos, right)]
        elseif c == '/'
            b.dir == right && (res = [Beam(b.pos, up)])
            b.dir == down && (res = [Beam(b.pos, left)])
            b.dir == left && (res = [Beam(b.pos, down)])
            b.dir == up && (res = [Beam(b.pos, right)])
        elseif c == '\\'
            b.dir == right && (res = [Beam(b.pos, down)])
            b.dir == down && (res = [Beam(b.pos, right)])
            b.dir == left && (res = [Beam(b.pos, up)])
            b.dir == up && (res = [Beam(b.pos, left)])
        end
    end
    return move.(res)
end

nrj = falses(size(m));

vb = [Beam(Pos(1, 1), right)];
done = Set{Beam}();

while !isempty(vb)
    b = pop!(vb)
    res = modify!(m, nrj, b)
    # println("res = $res")
    for bi in res
        if bi ∉ done
            push!(vb, bi)
            push!(done, bi)
        end
    end
end

sum(nrj)

