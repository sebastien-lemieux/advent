
f = open("input.txt")

all_rows = Vector{Vector{Int}}()
while !eof(f)
    push!(all_rows, [parse(Int, c) for c in readline(f)])
end

mat = cat(all_rows...; dims=2)
n = size(mat)[1]

function sweep!(f, mat, visible)
    n = size(mat)[1]
    thresh = zeros(Int, n)
    for i=1:n
        ind = f(i)
        visible[ind...] .|= mat[ind...] .>= thresh
        thresh = max.(thresh, mat[ind...] .+ 1)
        println(thresh)
    end
end

visible = zeros(Bool, size(mat));
sweep!(i -> (i,:), mat, visible)
sweep!(i -> (n-i+1,:), mat, visible)
sweep!(i -> (:,i), mat, visible)
sweep!(i -> (:,n-i+1), mat, visible)

visible |> sum # 1684


## Part 2

function one_direction!(ind, dist)
    line = mat[ind...]
    mask = trues(n) # continue?
    d = @view dist[ind...]

    for i=1:n
        higher = line[1:end-i] .>= line[(i+1):end]
        d[1:end-i] += mask[1:end-i] .* higher
        mask[1:end-i] .&= line[1:end-i] .> line[(i+1):end]
    end
end

dist = zeros(Int, (size(mat)..., 4));
for i=1:n
    one_direction!((i, 1:n), @view dist[:,:,1])
    one_direction!((i, reverse(1:n)), @view dist[:,:,2])
    one_direction!((1:n, i), @view dist[:,:,3])
    one_direction!((reverse(1:n), i), @view dist[:,:,4])
end

maximum(prod(dist; dims=3))
