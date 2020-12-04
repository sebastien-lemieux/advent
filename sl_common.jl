
## Common functions...

between(x, low, high) = x ≥ low && x ≤ high
int(str) = parse(Int, str)

function readFile(fn, transf = identity)
    allRes = Vector()
    open(fn) do f
        while !eof(f)
            push!(allRes, transf(readline(f)))
        end
    end
    return allRes
end
