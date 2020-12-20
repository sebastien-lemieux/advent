include("../sl_common.jl")

struct Tile
    id::Int
    pix::Matrix{Char}
end
n = 10

function readtile(io)
    id = replace(readline(io), r"Tile (\d+):" => s"\1")
    pix = fill('0', (n, n))
    for i=1:n
        str = readline(io)
        pix[i,:] .= [(c == '#' ? '1' : '0') for c in str]
    end
    readline(io) ## drop blank line
    return Tile(int(id), pix)
end

## flip-invariant codes
fic(b::Vector{Char}) = min(parse(Int, join(b), base=2),
                           parse(Int, reverse(join(b)), base=2))
function record!(d, t::Tile)
    function incr(x) d[x] = get(d, x, 0) + 1 end
    incr(fic(t.pix[1,:]))
    incr(fic(t.pix[n,:]))
    incr(fic(t.pix[:,1]))
    incr(fic(t.pix[:,n]))
end

tiles,bfic = open("input.txt") do f
    all = Dict{Int, Int}()
    tiles = Vector{Tile}()
    while !eof(f)
        t = readtile(f)
        push!(tiles, t)
        record!(all, t)
    end

    return tiles, all
end

prod = 1
for t in tiles
    matches = [bfic[x] for x in [fic(t.pix[1,:]), fic(t.pix[n,:]), fic(t.pix[:,1]), fic(t.pix[:,n])]]
    if count(matches .== 1) == 2
        println(t.id)
        prod *= t.id
    end
end
println(prod) ## Part 1: 17712468069479
