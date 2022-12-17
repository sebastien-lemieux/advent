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

range = 0:4_000_000
not_here = OffsetVector([Set{Int}() for _=range], range)
bs_here = OffsetVector([Set{Int}() for _=range], range)

# row = 2_000_000
f = open("input.txt")
@time while !eof(f)
    line = readline(f)
    sx, sy, bx, by = parse.(Int, match(r"Sensor at x=(.*), y=(.*): closest beacon is at x=(.*), y=(.*)", line))
    @show sx, sy, bx, by
    for row in range
        row % 1000 == 0 && println(row)
        update_row!(not_here[row], bs_here[row], sx, sy, bx, by, row)
    end
end
left = [setdiff(range, x) for x in not_here]
y = findfirst(isempty.(left) .== false)
x = first(left[y])
x * 4_000_000 + y

# setdiff(not_here, bs_here) ## Part 1: 4748135

