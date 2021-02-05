prog = parse.(Int, split(readline("input.txt"), ","))

function exec!(prog, pc)
    prog[pc] == 99 && return 0
    if prog[pc] == 1  op = +
    elseif prog[pc] == 2  op = *
    else
        println("weird!")
        return -1
    end
    prog[prog[pc + 3] + 1] = op(prog[prog[pc + 1] + 1], prog[prog[pc + 2] + 1])
    return pc + 4
end

prog[1 + 1] = 12
prog[2 + 1] = 2

pc = 1
while ((pc = exec!(prog, pc)) > 0)
end

println(prog[0 + 1]) ## 4690667

## Part 2

function test_prog(prog, noun, verb)
    prog_c = copy(prog)
    prog_c[1 + 1] = noun
    prog_c[2 + 1] = verb

    pc = 1
    while ((pc = exec!(prog_c, pc)) > 0)
    end

    return prog_c[1]
end

prog = parse.(Int, split(readline("input.txt"), ","))
target = 19690720
for noun = 0:99, verb = 0:99
    if test_prog(prog, noun, verb) == target
        println("noun = $noun, verb = $verb, answer = $(100 * noun + verb)")
    end
end

## 6255
