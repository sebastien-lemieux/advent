include("../../sl_common.jl")

Base.parse(::Type{UnitRange}, s::AbstractString) = UnitRange(parse.(Int, split(s, "-"))...)

count = 0
readFile("input.txt") do line
    global count
    range = parse.(UnitRange, split(line, ","))
    mstart = max(range[1].start, range[2].start)
    mstop = min(range[1].stop, range[2].stop)
    if (range[1].start == mstart && range[1].stop == mstop) ||
       (range[2].start == mstart && range[2].stop == mstop)
       count += 1
    end
end;
count  # 518

# Part 2

overlap(a::UnitRange, b::UnitRange) = !(a.start > b.stop || b.start > a.stop)

count = 0
readFile("input.txt") do line
    global count
    range = parse.(UnitRange, split(line, ","))
    count += overlap(range...)
end;
count  # 909
