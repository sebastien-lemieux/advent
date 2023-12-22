include("../../sl_common.jl")

pf = readGrid(identity, "input.txt")

nrow, ncol = size(pf)

total = 0
println("---")
for j=1:ncol
    load = nrow
    println("col = $j ------------------------")
    for i=1:nrow
        println(pf[i,j])
        if pf[i, j] == 'O'
            println(load)
            total += load
            load -= 1
        elseif pf[i, j] == '.'
            # nothing
        elseif pf[i, j] == '#'
            load = nrow - i
        end
    end
    println("Total: $total")
end
total