include("../../sl_common.jl")

s = readFile("input.txt") do line
    m = match(r".*:(.*)\|(.*)", line)

    ticket = falses(99)
    mine = falses(99)
    
    ticket[parse.(Int, split(m[1]))] .= 1
    mine[parse.(Int, split(m[2]))] .= 1

    tmp = sum(ticket .&& mine)
    (tmp > 0) ? 2^(tmp-1) : 0
    # (ticket, mine)
end

sum(s)

## Part 2

mutable struct Card
    nb::Int
    matches::Int
end
incr!(c::Card, i) = c.nb += i

s = readFile("input.txt") do line
    m = match(r".*:(.*)\|(.*)", line)

    ticket = falses(99)
    mine = falses(99)
    
    ticket[parse.(Int, split(m[1]))] .= 1
    mine[parse.(Int, split(m[2]))] .= 1

    Card(1, sum(ticket .&& mine))
end

for (i, c) in enumerate(s)
    for j in 1:c.matches
        incr!(s[i + j], c.nb)
    end
end

sum(c -> c.nb, s)