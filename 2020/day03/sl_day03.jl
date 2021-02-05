include("../sl_common.jl")

field = readFile("input.txt", s -> collect(Char, s))
# print(field)

function countTree(field, r, d)
    field = deepcopy(field) ## Preserve the original!
    nbTree = 0
    j = 1 # column
    i = 1 # row (for skip)

    for str in field
        if ((i - 1) % d) == 0  ## skip lines based on (d)own
            if str[j] == '#'
                nbTree += 1
                str[j] = 'O'
            else
                str[j] = '\\'
            end
            j = (j + (r - 1)) % length(str) + 1
        end
        # println("[$(String(str))] $(j) $(nbTree)") ## debug
        i += 1
    end

    return nbTree
end

# countTree(field, 1, 2)

traj = [(1, 1), (3, 1), (5, 1), (7, 1),(1, 2)]
nt = map(((r,d),) -> countTree(field, r, d), traj)

prod(nt)
