include("../sl_common.jl")

lines = readFile("input.txt") do line
    replace(line, " " => "")
end

function to_rpn(line)
    rpn = Vector{Char}() ## RPN-formatted sequence
    op = Vector{Char}()  ## operator stack

    for c in line
        if isdigit(c) push!(rpn, c)
        elseif c == '*'
            ## For part 2:
            while !isempty(op) && last(op) == '+'
                push!(rpn, pop!(op))
            end
            ## For part 1:
            # while !isempty(stack) && (last(stack) == '+' || last(stack) == '*')
            #     push!(rpn, pop!(stack))
            # end
            push!(op, c)
        elseif c == '+'
            ## For part 1:
            # while !isempty(stack) && (last(stack) == '+' || last(stack) == '*')
            #     push!(rpn, pop!(stack))
            # end
            push!(op, c)
        elseif c == '('
            push!(op, c)
        elseif c == ')'
            while !isempty(op) && last(op) != '('
                push!(rpn, pop!(op))
            end
            pop!(op)
        end
    end
    while !isempty(op)
        push!(rpn, pop!(op))
    end

    return rpn ## Operator stack should be empty
end

function eval_rpn(rpn)
    stack = Vector{Int}()
    for c in rpn
        if isdigit(c) push!(stack, int(c))
        elseif c == '+' push!(stack, pop!(stack) + pop!(stack))
        elseif c == '*' push!(stack, pop!(stack) * pop!(stack))
        end
    end
    return stack[1]
end

the_sum = 0
for line in lines
    the_sum += eval_rpn(to_rpn(line))
end

println(the_sum) ## 323802071857594
