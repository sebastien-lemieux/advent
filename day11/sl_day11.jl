include("../sl_common.jl")

lines = readFile("input.txt", collect)
n = length(lines[1])
m = length(lines)

mat = fill('.', (m, n))
for i in 1:m
    for j in 1:n
        mat[i, j] = lines[i][j]
    end
end

function countOcc(mat, i, j, c)
    res = 0
    for ii in max(i-1,1):min(i+1,m)
        for jj in max(j-1,1):min(j+1,n)
            if i == ii && j == jj continue end
            if mat[ii, jj] == c res += 1 end
        end
    end
    return res
end

function update!(mat)
    orig = copy(mat)
    change = false
    for i in 1:m
        for j in 1:n
            # if mat[i, j] == . return nmat end
            if orig[i, j] == 'L' && countOcc(orig, i, j, '#') == 0
                mat[i, j] = '#'
                change = true
            elseif orig[i, j] == '#' && countOcc(orig, i, j, '#') >= 4
                mat[i, j] = 'L'
                change = true
            end
        end
    end
    return change
end

while update!(mat) end
sum(mat .== '#')

## part 2

function countOcc2(mat, i, j, c)
    res = 0
    dir = [(-1, -1), (-1, 0), (-1, +1),
           (0, -1),           (0, +1),
           (+1, -1), (+1, 0), (+1, +1)]
    for d in dir
        p = (i, j) .+ d
        while between(p[1], 1, m) && between(p[2], 1, n)
            if mat[p...] == '.'
                p = p .+ d
                continue
            end
            if mat[p...] == c
                # println(p)
                res += 1
            end
            break
        end

    end
    return res
end

function update2!(mat)
    orig = copy(mat)
    change = false
    for i in 1:m
        for j in 1:n
            # if mat[i, j] == . return nmat end
            if orig[i, j] == 'L' && countOcc2(orig, i, j, '#') == 0
                mat[i, j] = '#'
                change = true
            elseif orig[i, j] == '#' && countOcc2(orig, i, j, '#') >= 5
                mat[i, j] = 'L'
                change = true
            end
        end
    end
    return change
end

while update2!(mat) end
sum(mat .== '#')
