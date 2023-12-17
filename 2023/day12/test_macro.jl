
macro memoize(mem_symbol, def)
    func_args = nothing
    func_start = false
    function memoize_aux(expr)
        new_expr = expr
        # println("BEFORE:  $expr ||| ")
        if isa(expr, Expr)
            # println("head: $(expr.head), args: $(expr.args)")
            if expr.head == :block && !func_start
                func_start = true
                args = Any[:(haskey($mem_symbol, $func_args) && return $mem_symbol[$func_args])]
                for item in expr.args
                    push!(args, memoize_aux(item))
                end
                new_expr = Expr(:block, args...)
            elseif expr.head == :call # Assumes the first call carries the arguments for the key
                # println("***********CALL: $(expr.args[2:end])")
                isnothing(func_args) && (func_args = Expr(:tuple, expr.args[2:end]...)) ## capture des arguments
                # println(func_args)
            elseif expr.head == :return
                # println("***********got it!!!  $(expr.args)")
                new_expr = Expr(:block, 
                            Expr(:global, :($mem_symbol)),
                            Expr(:(=), :tmp_res, expr.args...),
                            Expr(:call, :setindex!, :($mem_symbol), :tmp_res, func_args),
                            Expr(:return, :tmp_res))
            else
                args = []
                for item in expr.args
                    push!(args, memoize_aux(item))
                end
                new_expr = Expr(expr.head, args...)
            end
        end
        # println("AFTER:  $new_expr")
        # println()
        return new_expr
    end

    expr = memoize_aux(def)
    println(expr) ## Just to verify...
    return eval(expr)
end

# mem = Dict()

# @memoize(mem, fact(n) = if n == 1
#     return 1
# else
#     println("compute $n")
#     return n * fact(n-1)
# end)

# fact(6)

# @memoize(mem, function fib(n)
#     if n < 3
#         return 1
#     else
#         println("compute $n")
#         return fib(n-1) + fib(n-2)
#     end
# end)
# mem = Dict()

# fib(6)