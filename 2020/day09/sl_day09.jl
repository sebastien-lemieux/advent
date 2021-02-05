include("../sl_common.jl")

lines = readFile("input.txt", int, Vector{Int})
n = length(lines)

function findFirst(lines)
    for k in 26:n
        found = false
        for i in (k-25):(k-2)
            for j in (i+1):(k-1)
                # println("$k, $i, $j")
                if lines[k] == (lines[i] + lines[j]) found = true end
                found && break
            end
            found && break
        end
        if !found return k end
    end
end

inv = findFirst(lines)

## part 2

target = lines[inv]
for j in (inv-1):-1:2
    curr = lines[j]
    for i in (j-1):-1:1
        curr += lines[i]
        if curr == target
            println("$i $j $curr $target")
            println("$(min(lines[i:j]...) + max(lines[i:j]...))")
        end
    end
end
