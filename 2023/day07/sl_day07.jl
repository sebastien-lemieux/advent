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