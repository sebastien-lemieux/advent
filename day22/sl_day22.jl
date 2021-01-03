include("../sl_common.jl")

struct Deck
    c::Vector{Int}
end

Deck() = Deck(Vector{Int}())
Base.isempty(d::Deck) = isempty(d.c)
Base.length(d::Deck) = length(d.c)
Base.copy(d::Deck) = Deck(copy(d.c))
Base.copy(d::Deck, n::Int) = Deck(copy(d.c[end-n+1:end]))
Base.hash(d::Deck, h::UInt) = hash(d.c, h)

function readdeck(io::IO)
    readline(io) # Discard Player lines
    d = Deck()
    while true
        line = readline(io)
        line == "" && break # eof returns a ""?
        push!(d.c, int(line))
    end
    reverse!(d.c)
    return d
end

function play(p1::Deck, p2::Deck)
    while !isempty(p1) && !isempty(p2)
        c1 = pop!(p1.c)
        c2 = pop!(p2.c)
        if c1 > c2 pushfirst!(p1.c, c2, c1)
        else pushfirst!(p2.c, c1, c2) end
    end
end

function score(p::Deck)
    score = 0
    for (i, c) in enumerate(p.c) score += i * c end
    return score
end

p1, p2 = open("input.txt") do f
    readdeck(f), readdeck(f)
end

play(p1, p2)
score(p1) ## Part 1: 32598

## Part 2

function gplay(p1::Deck, p2::Deck)
    # global gmem
    # print("($(length(gmem))")
    hg = hash((p1, p2))

    rmem = Set{UInt}()
    while !isempty(p1) && !isempty(p2)
        # println("$p1 $p2 $mem")
        hr = hash((p1, p2))
        # haskey(gmem, hr) && return gmem[hr]
        if hr in rmem
            # println("Already seen")
            # print(")")
            # gmem[hg] = 1
            return 1
        else
            # println("Playing round")
            push!(rmem, hash((p1, p2)))
            winner = rplay(p1, p2)
        end
    end
    # print(")")
    # gmem[hg] = isempty(p1) ? 2 : 1
    # if length(gmem) % 10000 == 0
    #     println("Game completed: $(length(gmem))")
    # end
    # println("Game won by $(isempty(p1) ? 2 : 1)")
    return isempty(p1) ? 2 : 1
end

function rplay(p1::Deck, p2::Deck)
    c1 = pop!(p1.c)
    c2 = pop!(p2.c)
    # println("$(c1): $(p1.c) | $(c2): $(p2.c)")
    if length(p1) ≥ c1 && length(p2) ≥ c2
        # println("Recursion")
        winner = gplay(copy(p1, c1), copy(p2, c2))
        # winner = 1
    else
        if c1 > c2
            # println("Winner = 1")
            winner = 1
        else
            # println("Winner = 2")
            winner = 2
        end
    end
    if winner == 1 pushfirst!(p1.c, c2, c1)
    else pushfirst!(p2.c, c1, c2) end
    return winner
end

p1, p2 = open("input.txt") do f
    readdeck(f), readdeck(f)
end

# gmem = Dict{UInt, Int}()
# p1 = Deck(reverse([9, 2, 6, 3, 1]))
# p2 = Deck(reverse([5, 8, 4, 7, 10]))

@time gplay(p1, p2)
score(p1) # 35836
