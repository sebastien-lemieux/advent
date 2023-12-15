include("../../sl_common.jl")

m = hcat(readFile("input.txt", Vector{Vector{Char}}) do line
    collect(line)
end...) |> permutedims

d = fill(-1, size(m))

start = findfirst(==('S'), m)
d[start] = 0

nrow, ncol = size(m)

using DataStructures

q = Queue{Tuple{CartesianIndex{2}, CartesianIndex{2}}}()
enqueue!(q, (start, CartesianIndex(0, 0)))

function connect(from, to, dir)
    right = "S-FL"
    left = "S-J7"
    up = "S|JL"
    down = "S|F7"
    dir == CartesianIndex(-1, 0) && from in up && to in down && return true
    dir == CartesianIndex(+1, 0) && from in down && to in up && return true
    dir == CartesianIndex(0, -1) && from in left && to in right && return true
    dir == CartesianIndex(0, +1) && from in right && to in left && return true
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
    if sym in ['S', '-', 'F', 'L'] && col <= ncol
        dir = CartesianIndex(0, +1)
        (cur+dir) != back && dealWith(dir)
    end
    if sym in ['S', '|', 'J', 'L'] && row > 1 
        dir = CartesianIndex(-1, 0)
        (cur+dir) != back && dealWith(dir)
    end
    if sym in ['S', '|', 'F', '7'] && row <= nrow
        dir = CartesianIndex(+1, 0)
        (cur+dir) != back && dealWith(dir)
    end
end

while !isempty(q)
    expand()
end

## part 2

left = CartesianIndex(0, -1)
right = CartesianIndex(0, +1)
up = CartesianIndex(-1, 0)
down = CartesianIndex(+1, 0)

# function find_path(pos, path=[])
#     if (m[pos] == 'S') && (done[pos] == true)
#         return path
#     elseif done[pos] == false
#         done[pos] = true
#         new_path = copy(path)
#         push!(new_path, pos)
#         res = []
#         tmp = []
#         pos[2] > 1 && connect(m[pos], m[pos+left], left) && (tmp = find_path(pos+left, new_path))
#         length(tmp) > length(res) && (res = tmp)
#         pos[2] < ncol && connect(m[pos], m[pos+right], right) && (tmp = find_path(pos+right, new_path))
#         length(tmp) > length(res) && (res = tmp)
#         pos[1] > 1 && connect(m[pos], m[pos+up], up) && (tmp = find_path(pos+up, new_path))
#         length(tmp) > length(res) && (res = tmp)
#         pos[1] < nrow && connect(m[pos], m[pos+down], down) && (tmp = find_path(pos+down, new_path))
#         length(tmp) > length(res) && (res = tmp)
#         return res
#     end
#     return []
# end

function find_path_iterative(start_pos)
    stack = [(start_pos, [])]
    longest_path = []

    while !isempty(stack)
        pos, path = pop!(stack)
        
        if (m[pos] == 'S') && (done[pos] == true)
            if length(path) > length(longest_path)
                longest_path = path
            end
        elseif done[pos] == false
            done[pos] = true
            new_path = copy(path)
            push!(new_path, pos)

            if pos[2] > 1 && connect(m[pos], m[pos+left], left)
                push!(stack, (pos+left, new_path))
            end
            if pos[2] < ncol && connect(m[pos], m[pos+right], right)
                push!(stack, (pos+right, new_path))
            end
            if pos[1] > 1 && connect(m[pos], m[pos+up], up)
                push!(stack, (pos+up, new_path))
            end
            if pos[1] < nrow && connect(m[pos], m[pos+down], down)
                push!(stack, (pos+down, new_path))
            end
        end
    end

    return longest_path
end

done = falses(size(m))
path = find_path_iterative(start)

# orig = copy(d)
# d = copy(orig)
d[d .>= 0] .= 0

function flood(pos, i)
    total = 0
    if pos[2] >= 1 && pos[2] <= ncol && pos[1] >= 1 && pos[1] <= nrow && d[pos] == -1
        println("inside: $pos")
        total += 1
        d[pos] = i
        total += flood(pos + left, i)
        total += flood(pos + right, i)
        total += flood(pos + up, i)
        total += flood(pos + down, i)
    end
    return total
end

turn_right(dir) = CartesianIndex(dir[2], -dir[1])
turn_left(dir) = CartesianIndex(-dir[2], dir[1])

lst = nothing
lst_dir = nothing
side_in = nothing
side_out = nothing
for pos in path
    if lst !== nothing
        dir = pos - lst
        if lst_dir === nothing
            dir == up && (side_in = left; side_out = right) 
            dir == down && (side_in = right; side_out = left) 
            dir == right && (side_in = up; side_out = down) 
            dir == left && (side_in = down; side_out = up) 
        else
            cp = lst_dir[1] * dir[2] - lst_dir[2] * dir[1]
            cp < 0 && (f = turn_right)
            cp > 0 && (f = turn_left)
            cp == 0 && (f = identity)
            side_in = f(side_in)
            side_out = f(side_out)
        end
        # Flood the whole turn
        flood(pos+side_in, 1)
        flood(pos+side_out, 2)
        flood(lst+side_in, 1)
        flood(lst+side_out, 2)
        lst_dir = dir
    end
    lst = pos
end

# 667 too high
# 423 too low