
## Misc -------------------------------

incr(d, x) = d[x] = get(d, x, 0) + 1
Base.parse(::Type{UnitRange}, s::AbstractString) = UnitRange(parse.(Int, split(s, "-"))...)

## Position and directions ------------

const Pos = CartesianIndex{2}
const Dir = Pos
const up = Pos(-1, 0)
const down = Pos(1, 0)
const left = Pos(0, -1)
const right = Pos(0, 1)
const dirDict = Dict{AbstractString, Dir}("U" => up, "D" => down, "L" => left, "R" => right)
Base.parse(::Type{Dir}, str::AbstractString) = dirDict[str]
Base.:/(p::Pos, i::Int) = Pos(p[1]÷i, p[2]÷i)
left_turn(p::Pos) = Pos(-p[2], p[1])
right_turn(p::Pos) = Pos(p[2], -p[1])

Base.parse(::Type{CartesianIndex}, s::AbstractString) = CartesianIndex(parse.(Int, split(s, ","))...)
Base.sign(p::Pos) = Pos(sign.(Tuple(p)))

iswithin(p::Pos, size) = (1 ≤ p[1] ≤ size[1]) && (1 ≤ p[2] ≤ size[2])

## Line parsing -----------------------

function readFile(transf::Function, fn::String, resType = Array{Any,1})
    allRes = resType()
    open(fn) do f
        while !eof(f)
            push!(allRes, transf(readline(f)))
        end
    end
    return allRes
end

readFile(fn::String, resType = Array{Any,1}) = readFile(identity, fn, resType)

function readFile(v_transf::Vector{T}, fn::String) where T <: Function
    allRes = Any[]
    open(fn) do f
        i = 1
        res = Any[]
        while !eof(f)
            line = readline(f)
            transf = v_transf[i]
            if line == ""
                i += 1
                push!(allRes, res)
                res = Any[]
            else
                push!(res, transf(line))
            end
        end
        push!(allRes, res)
    end
    return allRes
end

## Grids ------------------------------

function readGrid(transf, f::IOStream)
    str = Vector{Char}[]
    while (line = readline(f)) != ""
        push!(str, collect(line))
        eof(f) && break
    end
    return transf.(reduce(hcat, str)) |> permutedims
end

readGrid(transf, filename::String) = open(f -> readGrid(transf, f), filename)
readGrid(filename::String) = readGrid(identity, filename)

function readGrids(transf, filename)
    open(filename) do f
        res = nothing
        while !eof(f)
            tmp = readGrid(transf, f)
            res === nothing && (res = typeof(tmp)[])
            push!(res, tmp)
        end
        return res
    end
end

inBounds(grid, p) = all([1 ≤ p[i] ≤ theMax for (i, theMax) in enumerate(size(farm))])

function Base.show(io::IOContext, ::MIME"text/plain", mat::Matrix{T}) where T
    println(io, "Matrix of $T, $(size(mat))")
    for i in 1:size(mat, 1)
        println(io, mat[i,:] |> join)
    end
end

## String index -----------------------

struct StrIndex
    str2id::Dict{String, Int32}
    id2str::Vector{String}

    StrIndex(vs::Vector{String}) = new(Dict(vs[i] => i for i = 1:length(vs)), vs) # must be uniqued!
end

## indexing
Base.getindex(idx::StrIndex, s::String) = idx.str2id[s]
Base.getindex(idx::StrIndex, i::Integer) = idx.id2str[i]
Base.getindex(idx::StrIndex, v::AbstractVector{String}) = [idx[s] for s in v]
Base.getindex(idx::StrIndex, v::AbstractVector{<:Integer}) = [idx[i] for i in v]
Base.getindex(idx::StrIndex, v::AbstractVector{<:Bool}) = idx.id2str[v]
Base.length(idx::StrIndex) = length(idx.id2str)

## Memoization ------------------------

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