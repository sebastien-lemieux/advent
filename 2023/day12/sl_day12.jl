include("../../sl_common.jl")

rec_v = readFile("input.txt", Vector{Tuple{String, Vector{Int}}}) do line
    rec, brok = split(line)
    rec, parse.(Int, split(brok, ","))
end

function bt(rec, len_v)
    # println("$rec: $len_v")
    if isempty(len_v)
        isempty(rec) && return 1
        any(occursin.(collect(rec), "#")) && return 0
        return 1
    end
    isempty(rec) && return 0
    flv = first(len_v)
    nb = 0
    if length(rec) >= flv && all(occursin.(collect(rec[1:flv]), "#?"))
        if  length(rec) == flv || rec[flv+1] in "?."
            nb += bt(rec[flv+2:end], len_v[2:end])
        end
    end
    rec[1] in ".?" && (nb += bt(rec[2:end], len_v))
    return nb
end

[bt(rec, len_v) for (rec, len_v) in rec_v] |> sum

## Part 2

unfold(rec, len_v) = join(repeat([rec], 5), "?"), repeat(len_v, 5)

include("test_macro.jl")
@memoize(mem, function bt(rec, len_v)
    # println("$rec: $len_v")
    if isempty(len_v)
        isempty(rec) && return 1
        any(occursin.(collect(rec), "#")) && return 0
        return 1
    end
    isempty(rec) && return 0
    flv = first(len_v)
    nb = 0
    if length(rec) >= flv && all(occursin.(collect(rec[1:flv]), "#?"))
        if  length(rec) == flv || rec[flv+1] in "?."
            nb += bt(rec[flv+2:end], len_v[2:end])
        end
    end
    rec[1] in ".?" && (nb += bt(rec[2:end], len_v))
    return nb
end
)



mem = Dict()

[bt(unfold(rec, len_v)...) for (rec, len_v) in rec_v] |> sum

