include("../sl_common.jl")

const O = Vector{Int}
const P = Vector{O}
const G = Dict{Int,P}
_push!(g::G, i::Int, res::O) = push!(get!(g, i, P()), res)
_push!(g::G, i::Int, p::P) = for pp in p push!(get!(g, i, P()), pp) end

function parse_rule(g, term, line)

    (i, p) = split(line, ": ")
    p = split.(split(p, " | "), " ")
    i = int(i)

    if p[1][1][1] == '"' ## Terminals
        tmp = get!(term, i, Vector{Char}())
        push!(tmp, p[1][1][2])
    else ## Non-terminals
        for o in p
            _push!(g, i, int.(o))
        end
    end
end


function to_chomsky(g, term)
    ng = typeof(g)()
    nt = copy(term)

    for (i, p) in g
        for o in p
            if length(o) == 1
                if haskey(nt, o[1])
                    tmp = get!(nt, i, Vector{Char}())
                    for x in nt[o[1]] push!(tmp, x) end
                else
                    _push!(ng, i, g[o[1]])
                end
            else
                _push!(ng, i, o)
            end
        end
    end
    return ng, nt
end

function reverse_gt(g, t)
    gi = Dict{O, O}()
    for (i, p) in g
        for o in p
            push!(get!(gi, o, O()), i)
        end
    end
    ti = Dict{Char, O}()
    for (i, p) in t
        for o in p
            push!(get!(ti, o, O()), i)
        end
    end
    return gi, ti
end

function test_msg(gi, ti, msg)
    n = length(msg)

    cyk = [Set{Int}() for i=1:n, j=1:n]
    for i=1:n
        cyk[1,i] = Set(ti[msg[i]])
    end

    for l = 2:n
        for i = 1:(n-l+1)
            for p = 1:(l-1)
                sa = cyk[p, i]
                sb = cyk[l-p, i+p]
                for (a, b) in Iterators.product(sa, sb)
                    union!(cyk[l, i], Set(get(gi, [a, b], O())))
                end
            end
        end
    end
    return cyk[n,1]
end

g, term = open("input.txt") do f
    g = G()
    term = Dict{Int, Vector{Char}}()

    count = 0

    line = readline(f)
    while line != ""
        # println("rule: $line")
        parse_rule(g, term, line)
        line = readline(f)
    end

    ## For Part 2
    _push!(g, 8, [42, 8])
    _push!(g, 11, [42, 999])
    _push!(g, 999, [11, 31])

    g, term = to_chomsky(g, term)
    gi, ti = reverse_gt(g, term)

    line = readline(f)
    while !eof(f)
        tmp = test_msg(gi, ti, line)
        if 0 in tmp
            println(line)
            count += 1
        end
        line = readline(f)
    end
    tmp = test_msg(gi, ti, line)
    if 0 in tmp
        println(line)
        count += 1
    end
    println(stderr, "count = $count")
    return g, term
end

# Part 1: 149
# Part 2: 332
