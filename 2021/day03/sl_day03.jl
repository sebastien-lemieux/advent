include("../../sl_common.jl")

conv(s) = parse.(Int, collect(s))

all_nb = hcat(conv.(readlines("sl_input.txt"))...)'
# all_nb = hcat(conv.(readlines("sl_test.txt"))...)'
n = size(all_nb)[1]

gamma = mapslices(sum, all_nb; dims=1) .> (n / 2)
epsilon = .~gamma

conv_dec(bin) = foldl((a, b) -> 2 * a + b, bin; init = 0)

conv_dec(gamma) * conv_dec(epsilon) ## 2250414

## Part 2 (rewritten part 1 to keep matrix and use mapslices)

function filter(nb, i, op)
    n = size(nb)[1]
    crit = op(sum(nb[:,i]), (n / 2))
    nb[nb[:,i] .== crit, :]
end

function filter(nb, op)
    for i in 1:size(nb)[2]
        nb = filter(nb, i, op)
        if size(nb)[1] == 1
            return nb
        end
    end
end

gen = filter(all_nb, >=)
scr = filter(all_nb, <)

conv_dec(gen) * conv_dec(scr) ## 6085575

# high: 6128145