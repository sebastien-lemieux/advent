using OffsetArrays

function update_row!(not_here::Set{Int}, bs_here::Set{Int}, sx, sy, bx, by, row)
    row_dist = abs(row - sy)
    bdist = abs(bx - sx) + abs(by - sy)
    Δ = bdist - row_dist
    @show Δ
    union!(not_here, (sx-Δ):(sx+Δ))
    # sy == row && push!(bs_here, sx)
    # by == row && push!(bs_here, bx)
end

# not_here = OffsetVector([Set{Int}() for _=range], range)
# bs_here = OffsetVector([Set{Int}() for _=range], range)

struct Signal
    sx::Int
    sy::Int
    bx::Int
    by::Int
end

function get_range(s::Signal, row::Int)
    row_dist = abs(row - s.sy)
    bdist = abs(s.bx - s.sx) + abs(s.by - s.sy)
    Δ = bdist - row_dist
    # @show Δ
    return (s.sx-Δ):(s.sx+Δ)
end

# function clamp(a::UnitRange, b::UnitRange)
#     start = max(a.start, b.start)
#     stop = min(a.stop, b.stop)

# end

# range = 0:20
range = 0:4_000_000
f = open("input.txt")
sig = Vector{Signal}()
@time while !eof(f)
    line = readline(f)
    push!(sig, Signal(parse.(Int, match(r"Sensor at x=(.*), y=(.*): closest beacon is at x=(.*), y=(.*)", line))...))
end

function fuse(a::UnitRange, b::UnitRange)
    a > b && return fuse(b, a)
    return (a.stop+1 ≥ b.start) ? (true, min(a.start,b.start):max(a.stop,b.stop)) : (false, (a.stop+1):(b.start-1))
end

function fuse!(v::Vector{UnitRange{Int}})
    last_j = length(v)
    i = 1; j = 2
    while i ≤ last_j
        print('.')
        does_fuse, res = fuse(v[i], v[j])
        if does_fuse
            print('|')
            v[i] = res
            v[j] = v[last_j]
            last_j -= 1
            j = i + 1
        else
            j += 1
        end
        if j > last_j
            i += 1
            j = i + 1
        end
    end
    println()
    return v[1:last_j]
end
 
fuse!([13:17, 1:5, 4:9, 4:12, 20:25])


function test_row(row, sig, range)
    # row % 1000 == 0 && println(row)
    ranges = filter(x -> !isempty(x), [get_range(s, row) for s in sig])
    # println(length(ranges))

    # ranges = fuse!(ranges)
    # sort!(ranges, alg=MergeSort)
    # ranges = sort(filter(x -> !isempty(x), [get_range(s, row) for s in sig]))
    # last_max = -1
    # for r in ranges
    #     r.start > last_max && println("$(row) = $(last_max), $(r.start)")
    #     last_max = max(last_max, r.stop)
    # end
    # row % 10000 == 0 && 
    # println(sort(ranges))
end

for row in 1_100_000:4_000_000 #range
    # @time 
    test_row(row, sig, range)
    # break
end




# left = [setdiff(range, x) for x in not_here]
# y = findfirst(isempty.(left) .== false)
# x = first(left[y])
# x * 4_000_000 + y

# setdiff(not_here, bs_here) ## Part 1: 4748135

