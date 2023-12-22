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

function energize(g, b)
    nrj = falses(size(g));

    vb = [b];
    done = Set{Beam}();

    while !isempty(vb)
        b = pop!(vb)
        res = modify!(g, nrj, b)
        # println("res = $res")
        for bi in res
            if bi ∉ done
                push!(vb, bi)
                push!(done, bi)
            end
        end
    end

    sum(nrj)
end

energize(m, Beam(Pos(1, 1), right))

## Part 2

function testAll(g)
    nrow, ncol = size(g)
    return [
        max([energize(g, Beam(Pos(1, i), down)) for i=1:ncol]...),
        max([energize(g, Beam(Pos(nrow, i), up)) for i=1:ncol]...),
        max([energize(g, Beam(Pos(i, 1), right)) for i=1:nrow]...),
        max([energize(g, Beam(Pos(i, ncol), left)) for i=1:nrow]...)
    ]
end

max(testAll(m)...)