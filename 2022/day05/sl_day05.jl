include("../../sl_common.jl")

function load_stacks(f)
    stacks = [Vector{Char}() for i=1:9]
    while(true)
        s = readline(f)
        crates = [s[i*4-2] for i=1:9]
        println(crates)
        crates[1] == '1' && break
        for i=1:9
            if crates[i] != ' '
                push!(stacks[i], crates[i])
            end
        end
    end
    reverse!.(stacks)
    readline(f)
    return stacks
end

function move(stacks, nb, src, dst)
    for i = 1:nb
        push!(stacks[dst], pop!(stacks[src]))
    end
end

function execute_orders(stacks, p)
    while(!eof(f))
        line = parse.(Int, split(readline(f), " ")[[2,4,6]])
        println(line)
        p(stacks, line...)
    end
    return join([last(stacks[i]) for i=1:9])
end

f = open("input.txt")
stacks = load_stacks(f)
execute_orders(stacks, move) # SPFMVDTZT

# Part 2

function move2(stacks, nb, src, dst)
    tmp = Vector{Int}()
    for i = 1:nb
        push!(tmp, pop!(stacks[src]))
    end
    for i = 1:nb
        push!(stacks[dst], pop!(tmp))
    end
end

f = open("input.txt")
stacks = load_stacks(f)
execute_orders(stacks, move2) # ZFSJBPRFP
