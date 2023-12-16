include("../../sl_common.jl")

rec_v = readFile("input.txt", Vector{Tuple{String, Vector{Int}}}) do line
    rec, brok = split(line)
    return rec, parse.(Int, split(brok, ","))
end

function bt(rec, pos, len_v)
    # println("$rec[$pos]: $len_v")
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
            nb += bt(rec[flv+2:end], flv+2, len_v[2:end])
        end
    end
    rec[1] in ".?" && (nb += bt(rec[2:end], pos+1, len_v))
    return nb
end

[bt(rec, 1, len_v) for (rec, len_v) in rec_v] |> sum

