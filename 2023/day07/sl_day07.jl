include("../../sl_common.jl")

import Base: <

value(c) = findfirst(==(c), "23456789TJQKA")

const handValue = Dict(
    [1, 1, 1, 1, 1] => 1,
    [2, 1, 1, 1] => 2,
    [2, 2, 1] => 3,
    [3, 1, 1] => 4,
    [3, 2] => 5,
    [4, 1] => 6,
    [5] => 7
)

using StatsBase: countmap
handType(h) = handValue[sort(collect(values(countmap(h))), rev=true)]

struct Play
    hand::Vector{Int}
    bind::Int
end

function Base.isless(a::Play, b::Play)
    at = handType(a.hand)
    bt = handType(b.hand)
    return at < bt || (at == bt && a.hand < b.hand)
end

hands = readFile("input.txt") do line
    hand_str, bid_str = split(line)
    hand = [value(c) for c in hand_str]
    Play(hand, parse(Int, bid_str))
end

theSum = 0
for (i, p) in enumerate(sort(hands))
    theSum += i * p.bind
end
theSum

## part 2

value(c) = findfirst(==(c), "J23456789TQKA")
const joker = value('J')
const ace = value('A')

function handTypeWithJ(h)
    function ht2(prefix, phand)
        isempty(phand) && return [prefix] # done
        car = phand[1]
        cdr = phand[2:end]
        car == 1 && return vcat([ht2(vcat(prefix, [i]), cdr) for i in (joker+1):ace]...) # expand joker
        return ht2(vcat(prefix, car), cdr) # just go on
    end
    
    hs = ht2(Int[], h)
    return max(handType.(hs)...)
end

function Base.isless(a::Play, b::Play)
    at = handTypeWithJ(a.hand)
    bt = handTypeWithJ(b.hand)
    return at < bt || (at == bt && a.hand < b.hand)
end

theSum = 0
for (i, p) in enumerate(sort(hands))
    theSum += i * p.bind
end
theSum

