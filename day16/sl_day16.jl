include("../sl_common.jl")

struct Rule
    name::String
    ok::BitArray{1}
end

import Base.parse
function parse(::Type{Rule}, line::String)
    (name, range) = split(line, ": ")
    range = split(range, " or ")
    ok = falses(1000)
    foreach(range) do str
        (a, b) = map(int, split(str, "-"))
        ok[a+1:b+1] .= true
    end
    return Rule(name, ok)
end
function parse(r::Type{Rule}, name::String, vec::Vector{Int})
    ok = falses(1000)
    ok[vec .+ 1] .= true
    return Rule(name, ok)
end

# tmp = parse(Rule, "departure date: 42-370 or 383-961")

import Base.|, Base.length
|(a::Rule, b::Rule) = Rule(a.name, a.ok .| b.ok)
length(a::Rule) = length(a.ok)


struct Ticket num::BitArray{1} end

import Base.parse
function parse(::Type{Ticket}, line::Vector{Int})
    ok = falses(1000)
    ok[line .+ 1] .= true
    return Ticket(ok)
end
parse(t::Type{Ticket}, line::String) = parse(t, int.(split(line, ",")))


invalid(t::Ticket, all_rules::Rule) = (0:999)[.~all_rules.ok .& t.num]
valid(t::Ticket, all_rules::Rule) = isempty(invalid(t, all_rules))


mat = open("input.txt") do f

    rules = Vector{Rule}()
    all = Rule("All", falses(1000))
    while (str = readline(f)) != ""
        push!(rules, parse(Rule, str))
        all = all | last(rules)
    end

    # println(all)
    #
    readline(f) ## your ticket:
    ticket =int.(split(readline(f), ","))
    n = length(ticket)
    println("Ticket: $ticket")

    readline(f) ## empty
    readline(f) ## nearby ticket:

## part 1

    # tickets = [parse(Ticket, str) for str in readlines(f)]
    # println(length(tickets))
    # a = [sum(invalid(t, all)) for t in tickets]
    # b = [valid(t, all) for t in tickets]
    # # println(length(a), a)
    # println(length(b), b)
    # println(a[.~b])
    # c = [sum(invalid(t, all)) > 0 for t in tickets]
    # println(length(c), " sum ", sum(c .& b))
    # p1_sum = sum([sum(invalid(t, all)) > 0 for t in tickets]) ## 27850
    # println(p1_sum)

## part 2

    lines = [int.(split(line, ",")) for line in readlines(f)]
    mat = [lines[i][j] for i=1:length(lines), j=1:length(lines[1])]
    valid_tickets = mapslices(t -> valid(parse(Ticket, t), all), mat, dims=2)[:,1]
    mat = mat[valid_tickets,:]
    # println(size(mat))
    # print([min(mat...), max(mat...)])

    # println(rules)
    # println(sort(mat[:,10]))

    compat = mapslices(mat, dims=1) do col
        # println(size(col))
        field = parse(Rule, "unknown field", col)
        # display(col)
        # println((1:1000)[field.ok] .- 1)
        tmp = [(!any(.~r.ok .& field.ok)) for r in rules]
        println(tmp)
        return tmp
    end
    compat = compat'
    display(compat)
    display(compat[1,14])
    println(rules[14])

    # tmp_rule = parse(Rule, "xxx", mat[:,15])
    # println(!any(.~rules[9].ok .& tmp_rule.ok))
    # println(compat[9, 15])

    # compat = compat'
    # println(compat[7,:])
    # display(compat[sortperm(mapslices(sum, compat, dims=2)[:,1]),:])

    o = sortperm(mapslices(sum, compat, dims=2)[:,1])
    ro = zeros(Int, n)
    ro[o] = 1:n
    # println(o)
    # println(ro)
    compat = compat[o,:]
    # display(compat)

    compat[2:n,:] .-= compat[1:n-1,:]
    compat = compat[ro,:]
    display(compat)
    field_i = compat * (1:length(rules))
    println("rule identifier: $field_i")
    field_names = [rules[r].name for r in field_i]
    println(field_names)
    dep_fields = occursin.(r"^departure", field_names)
    # println(o[dep_fields])
    # println(ticket[o[dep_fields]])
    println(prod(ticket[dep_fields]))
    ticket[dep_fields]

    println("valid")
    for (i, r) in enumerate(rules[field_i])
        println("$(i) $(field_i[i]) $(r.name)")
        field = parse(Rule, "unknown field", mat[:,i])
        # println((1:1000)[field.ok] .- 1)
        println(!any(.~r.ok .& field.ok))
        println(sort(mat[:,i]))
        println(mat[:,i])
        (!any(.~r.ok .& field.ok)) || break
        # println(r.ok)
    end

end

# 1560158232121
# 1882697295917
# 4833831622679
# 11018121060439
# 491924517533

mat
