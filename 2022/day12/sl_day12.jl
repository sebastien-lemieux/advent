using DataStructures

include("../../sl_common.jl")

tmp = readFile(line -> Vector{Char}(line), "input.txt", Vector{Vector{Char}})
mat = reduce(hcat, tmp)

struct Step
    pos::CartesianIndex{2}
    height::Char
    dist::Int
end

isaccessible(s, d) = (d == 'E') ? (s.height >= 'y') : (s.height >= (d - 1))
dirs = [CartesianIndex(-1, 0),
        CartesianIndex(+1, 0),
        CartesianIndex(0, -1),
        CartesianIndex(0, +1),
]

function visit(pos::CartesianIndex{2}, from::Step)
    if pos[1] >= 1 && pos[1] <= size(mat)[1] &&
       pos[2] >= 1 && pos[2] <= size(mat)[2] &&
       !visited[pos] && isaccessible(from, mat[pos])
       mat[pos] == 'E' && begin
            println("bing $(pos), $(mat[pos]), $(from)")
            return true, from.dist + 1
       end 
       enqueue!(cur, Step(pos, mat[pos], from.dist + 1))
       visited[pos] = true
    end
    return false, 0
end

start_pos = findfirst(mat .== 'S')
cur = Queue{Step}()
enqueue!(cur, Step(start_pos, 'a', 0))
visited = falses(size(mat))
visited[start_pos] = true

while !isempty(cur)
    tmp = dequeue!(cur)
    # println(tmp)
    for d in dirs
        # println(d)
        done, dist = visit(tmp.pos + d, tmp)
        if done
            println(dist)
            break
        end
    end
    # println(cur)
end

# Part 1: 449

