include("../sl_common.jl")

struct Tile
    id::Int
    pix::Matrix{Char}
end
n = 10

Tile() = Tile(0, fill('0', (n, n)))

function readtile(io)
    id = int(replace(readline(io), r"Tile (\d+):" => s"\1"))
    pix = fill('0', (n, n))
    for i=1:n
        str = readline(io)
        pix[i,:] .= [(c == '#' ? '1' : '0') for c in str]
    end
    readline(io) ## drop blank line
    return Tile(id, pix)
end

# flip-invariant codes
code(b::Vector{Char}) = parse(Int, join(b), base=2)
fic(b::Vector{Char}) = min(code(b), code(reverse(b)))
all_fic(t::Tile) = [fic(t.pix[1,:]), fic(t.pix[n,:]), fic(t.pix[:,1]), fic(t.pix[:,n])]

function record!(d, t::Tile)
    for x in all_fic(t) incr(d, x) end
end


all = Dict{Int, Int}()
tiles = Vector{Tile}()

open("input.txt") do f
    empty!.([all, tiles])
    while !eof(f)
        t = readtile(f)
        push!(tiles, t)
        record!(all, t)
    end

    return tiles, all
end

## Part 1

prod = 1
corner = Tile() # Remember one corner for part 2
for t in tiles
    matches = [all[x] for x in [fic(t.pix[1,:]), fic(t.pix[n,:]), fic(t.pix[:,1]), fic(t.pix[:,n])]]
    if count(matches .== 1) == 2
        println(t.id)
        prod *= t.id
        corner = t
    end
end
println(prod) ## 17712468069479

## Part 2

# Tile indexed by flip-invariant codes
ti = Dict{Int, Vector{Tile}}()
for t in tiles
    for m in all_fic(t)
        tmp = get!(ti, m, Vector{Tile}())
        push!(tmp, t)
    end
end

# fr: flipped/rotated, predicate-based
function find_fr(t::Tile, pred, flip=false)
    o = (flip ? Tile(t.id, reverse(t.pix, dims=1)) : t)
    for i=1:4
        tmp = Tile(o.id, rotl90(o.pix, i))
        pred(tmp) && return tmp
    end
    if !flip return find_fr(o, pred, true) end
    return Tile(0, fill(0, (n, n)))
end

# Placed tiles, it's a square (144 tiles, 4 corners, 40 sides)
N = 12
placed = Set{Int}()
ptiles = fill(Tile(), (N, N))

# Rotate/flip/place the first corner
corner = find_fr(corner, t -> (all[fic(t.pix[1,:])] == 1) && (all[fic(t.pix[:,1])] == 1))
push!(placed, corner.id)
ptiles[1,1] = corner

for i = 1:N
    if i > 1
        ## place first in row, up-referenced
        border = ptiles[i-1, 1].pix[n,:]
        nt = filter(t -> !(t.id in placed), ti[fic(border)])[1]
        nt = find_fr(nt, t -> (t.pix[1,:] == border))
        ptiles[i, 1] = nt
        push!(placed, nt.id)
    end
    for j = 2:N
        # Place the rest, left-referenced
        border = ptiles[i, j-1].pix[:,n]
        nt = filter(t -> !(t.id in placed), ti[fic(border)])[1]
        nt = find_fr(nt, t -> (t.pix[:,1] == border))
        ptiles[i, j] = nt
        push!(placed, nt.id)
    end
end

# display([t.id for t in ptiles]) # Placed tiles

# Final map and monster map
final = [ptiles[(i-1)÷8+1,(j-1)÷8+1].pix[(i-1)%8+2,(j-1)%8+2] for i=1:8*N, j=1:8*N]
final_m = [false for _ in final]

monster = hcat(collect("                  # ") .== '#',
               collect("#    ##    ##    ###") .== '#',
               collect(" #  #  #  #  #  #   ") .== '#')'

function mark_pos(final, final_m, monster, i, j)
    invalid(a::Char, b::Bool) = b && (a != '1')
    s = size(monster)
    tmp = view(final, i:i+s[1]-1, j:j+s[2]-1)
    if !any(invalid.(tmp, monster))
        println("marking $i $j")
        tmp = view(final_m, i:i+s[1]-1, j:j+s[2]-1)
        tmp .= tmp .| monster
    end
end

function scan(final, final_m, monster)
    for i=1:size(final, 1) - size(monster, 1) + 1
        for j=1:size(final, 2) - size(monster, 2) + 1
            mark_pos(final, final_m, monster, i, j)
        end
    end
end

monster_f = reverse(monster, dims=1) # Flipped monster
for i=0:3
    scan(final, final_m, rotl90(monster, i))
    scan(final, final_m, rotl90(monster_f, i))
end

# Rough water AND not in monster
count((final .== '1') .& (.~final_m)) ## 2173
