
struct Coord
    x::Int
    y::Int
    skip::Int
end
Coord(x::Int, y::Int) = Coord(x, y, 0)

Base.:+(a::Coord, black::Coord) = Coord(a.x + black.x, a.y + black.y, a.skip + black.skip)

function Base.parse(::Type{Coord}, str::AbstractString)
    if str[1] == 'n'
        if str[2] == 'e' Coord(0, +1, 2)
        else Coord(-1, +1, 2)
        end
    elseif str[1] == 's'
        if str[2] == 'e' Coord(+1, -1, 2)
        else Coord(0, -1, 2)
        end
    elseif str[1] == 'w' Coord(-1, 0, 1)
    else Coord(+1, 0, 1)
    end
end

function find_coord(str::AbstractString)
    start = Coord(0, 0, 1)
    s = SubString(str, start.skip)
    while length(s) > 0
        start += parse(Coord, s)
        s = SubString(str, start.skip)
    end
    return Coord(start.x, start.y, 0)
end

length(symdiff(map(find_coord, readlines("input.txt")))) ## 341

## Part 2

neighbors(c::Coord) = Set([c] .+ [Coord(0,1), Coord(1,0), Coord(1,-1), Coord(0,-1), Coord(-1,0), Coord(-1,1)])
adj_black(c::Coord, black) = length(intersect(neighbors(c), black))

function one_iter!(black::Array{Coord,1})
    white = setdiff(union(neighbors.(black)...), black)
    new_black = filter(c -> adj_black(c, black) == 2, white)
    setdiff!(black, filter(c -> !(0 < adj_black(c, black) < 3), black))
    union!(black, new_black)
end

black = symdiff(map(find_coord, readlines("input.txt")))

@time for i=1:100
    one_iter!(black)
    println("Day $i: $(length(black))")
end
## 3700
