
## Common functions...

between(x, low, high) = x ≥ low && x ≤ high
int(str) = parse(Int, str)

function readFile(transf, fn::String, resType = Array{Any,1})
    allRes = resType()
    open(fn) do f
        while !eof(f)
            push!(allRes, transf(readline(f)))
        end
    end
    return allRes
end

readFile(fn::String, resType = Array{Any,1}) = readFile(identity, fn, resType)
