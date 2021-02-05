include("../sl_common.jl")

function splitInstr(str)
    tmp = split(str, " ")
    return (tmp[1], int(tmp[2]))
end

lines = readFile("input.txt", splitInstr, Vector{Tuple{String, Int}})

## part 1

done = falses(length(lines))
pc = 1
acc = 0

while !done[pc] ## Loop detected
    (instr, offset) = lines[pc]
    done[pc] = true
    # println("$(pc) $(acc)")

    if instr == "jmp"  pc += offset
    elseif instr == "acc"
        acc += offset
        pc += 1
    else  pc += 1  end

end

println("accumulator = $acc")

## part 2

struct LoopDetected <: Exception
    acc::Int
end

function exec(done, pc, acc, subst = false)
    pc > length(lines) && return acc  ## we're done
    (instr, offset) = lines[pc]
    done[pc] == true && throw(LoopDetected(acc))
    done[pc] = true

    if instr == "jmp"
        try return exec(copy(done), pc + offset, acc, subst)
        catch e
            if isa(e, LoopDetected) && subst == false
                return exec(copy(done), pc + 1, acc, true)
            else throw(e) end
        end
    elseif instr == "acc" return exec(copy(done), pc + 1, acc + offset, subst)
    else try return exec(copy(done), pc + 1, acc, subst)
        catch e
            if isa(e, LoopDetected) && subst == false
                return exec(copy(done), pc + offset, acc, true)
            else throw(e) end
        end
    end
end

done = falses(length(lines))
exec(done, 1, 0)
