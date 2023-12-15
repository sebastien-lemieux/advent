include("../../sl_common.jl")

m = 
m = hcat(readFile("input.txt", Vector{Vector{Char}}) do line
    collect(line)
end...) |> permutedims

d = fill(-1, size(m))

start = findfirst(==('S'), m)
d[start] = 0

ncol, nrow = size(m)

using DataStructures

q = Queue{Tuple{CartesianIndex{2}, CartesianIndex{2}}}()
enqueue!(q, (start, CartesianIndex(0, 0)))

function connect(from, to, dir)
    right = "-FL"
    left = "-J7"
    up = "|JL"
    down = "|F7"
    dir == CartesianIndex(-1, 0) && from in "S"*up && to in down && return true
    dir == CartesianIndex(+1, 0) && from in "S"*down && to in up && return true
    dir == CartesianIndex(0, -1) && from in "S"*left && to in right && return true
    dir == CartesianIndex(0, +1) && from in "S"*right && to in left && return true
    return false
end

function expand()
    cur, back = dequeue!(q)
    row = cur[1]
    col = cur[2]
    sym = m[cur]
    dist = d[cur]
    function dealWith(dir)
        next = cur + dir
        if connect(sym, m[next], dir)
            if d[next] == -1
                d[next] = dist + 1
                enqueue!(q, (next, cur))
            else
                println("Crash at $next = $(d[next])")
                while !isempty(q) dequeue!(q) end
            end
        end
    end
    if sym in ['S', '-', 'J', '7'] && col > 1 
        dir = CartesianIndex(0, -1)
        (cur+dir) != back && dealWith(dir)
    end
    if sym in ['S', '-', 'F', 'L'] && col < ncol
        dir = CartesianIndex(0, +1)
        (cur+dir) != back && dealWith(dir)
    end
    if sym in ['S', '|', 'J', 'L'] && row > 1 
        dir = CartesianIndex(-1, 0)
        (cur+dir) != back && dealWith(dir)
    end
    if sym in ['S', '|', 'F', '7'] && row < nrow
        dir = CartesianIndex(+1, 0)
        (cur+dir) != back && dealWith(dir)
    end
end

while !isempty(q)
    expand()
end

## part 2
