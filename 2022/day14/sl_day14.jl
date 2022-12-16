
Base.parse(::Type{CartesianIndex}, s::AbstractString) = CartesianIndex(parse.(Int, split(s, ","))...)

Pos = CartesianIndex{2}

Base.sign(p::Pos) = Pos(sign.(Tuple(p)))
function place_rock!(m::Matrix{Char}, a::Pos, b::Pos)
    d = sign(b - a)
    while a != b
        m[a] = '#'
        a += d
    end
    m[b] = '#'
end

function fall(m::Matrix{Char}, p::Pos)
    dir = [Pos(0,1), Pos(-1,1), Pos(1,1)]
    for d in dir
        m[p+d] == '.' && return p+d
    end
    return p
end

function fall(m::Matrix{Char}, max_depth)
    p = Pos(500,1)
    done = false
    while !done
        new_p = fall(m, p)
        new_p[2] >= max_depth && return false
        if new_p == p
            m[p] = 'o'
            println("settled")
            return true
        end
        p = new_p
    end
end

m = fill('.', 1000, 500)
f = open("input.txt")
max_depth = 1
while !eof(f)
    line = parse.(CartesianIndex, split(readline(f), " -> "))
    line = [p+Pos(0,1) for p in line]
    for i=1:(length(line)-1)
        place_rock!(m, line[i], line[i+1])
        max_depth = max(max_depth, line[i+1][2])
    end
end
println("Max depth: $(max_depth)")
max_depth += 2
place_rock!(m, Pos(1,max_depth), Pos(1000, max_depth))

while fall(m, max_depth) && m[500, 1] == '.'
end

sum(m .== 'o') # Part 1: 755, Part 2: 29805

