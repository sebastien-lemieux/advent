shape = 
BitArray([0 0 0 0 0 0 0
          0 0 0 0 0 0 0
          0 0 0 0 0 0 0
          0 0 1 1 1 1 0;;;
          0 0 0 0 0 0 0
          0 0 0 1 0 0 0
          0 0 1 1 1 0 0
          0 0 0 1 0 0 0;;;
          0 0 0 0 0 0 0
          0 0 0 0 1 0 0
          0 0 0 0 1 0 0
          0 0 1 1 1 0 0;;;
          0 0 1 0 0 0 0
          0 0 1 0 0 0 0
          0 0 1 0 0 0 0
          0 0 1 0 0 0 0;;;
          0 0 0 0 0 0 0
          0 0 0 0 0 0 0
          0 0 1 1 0 0 0
          0 0 1 1 0 0 0])


function prep(tunnel)
    height, _ = size(tunnel)
    ntunnel = falses(height + 7, 7)
    ntunnel[8:end, :] .= tunnel
    return ntunnel
end

function clean(tunnel)
    height, _ = size(tunnel)
    for i=1:height
        any(tunnel[i, 1:7]) && return tunnel[i:end,1:7]
    end
    return tunnel
end

collision(tunnel, shape, row) = any(tunnel[row:(row+3), :] .& shape)

function shift(shape, c)
    nshape = falses(4, 7)
    if c == '<'
        any(shape[:,1]) && return shape
        nshape[:,1:6] .= shape[:,2:7]
    else
        any(shape[:,7]) && return shape
        nshape[:,2:7] .= shape[:,1:6]
    end
    return nshape
end

# shift(shape[:, :, 2], '>')
mod(x, n) = (x - 1) % n + 1

jet = readline(open("input.txt"))
# jet = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"

tunnel = BitArray([1 1 1 1 1 1 1])

heights = [Vector{Int64}() for _=1:5, _=1:length(jet)]
blocks = [Vector{Int64}() for _=1:5, _=1:length(jet)]
# wait for stable height diff

height_by = 0
target = 1000000000000

it = 1
bl = 1
while bl <= target
    si = mod(bl, 5)
    ci = mod(it, length(jet))
    s = shape[:, :, mod(bl, 5)]
    tunnel = prep(tunnel)
    height, _ = size(tunnel)
    push!(heights[si, ci], height)
    push!(blocks[si, ci], bl)
    if length(heights[si, ci]) > 3 && height_by == 0
        println("$(heights[si, ci])  $(blocks[si, ci])")
        b = blocks[si, ci][end-1:end]
        h = heights[si, ci][end-1:end]
        b_span = b[2] - b[1]
        h_span = h[2] - h[1]
        r = (target - b[2]) ÷ b_span
        println("Repeats = $r  b_span = $b_span")
        bl += r * b_span
        println("bl = $bl")
        height_by = r * h_span
    end

    for i=1:height
        c = jet[mod(it, length(jet))]
        ns = shift(s, c)
        if collision(tunnel, ns, i) # Lateral collision
            ns = s
        end
        # println(c)
        it += 1
        if collision(tunnel, ns, i+1)
            tunnel[(i):(i+3),1:7] .|= ns
            break
        end
        s = ns
    end
    tunnel = clean(tunnel)
    bl += 1
end
height, _ = size(tunnel)
height - 1 + height_by

# Part 2: 1526744186042
