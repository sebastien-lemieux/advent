
function readFile(fn)
    res = Vector{Int}()

    open(fn) do f
        while !eof(f)
            x = parse.(Int, readline(f))
            push!(res, x)
        end
    end

    return res
end

function dicoSearch(v, x, i)
    n = length(v)
    a = i + 1
    b = n
    while b > a
        mid = (a + b - 1) ÷ 2
        v[mid] == x && return mid
        if v[mid] > x
            b = mid - 1
        else
            a = mid + 1
        end
    end
    return 0 # not found
end

## Read the files

l = sort(readFile("input.txt"))
n = length(l)

## Part 1 - got fancy with binary search [O(n * log n)]

for i = 1:(n-1)
    target = 2020 - l[i]
    j = dicoSearch(l, target, i)
    if j != 0
        println(l[i], ",", l[j], " = ", l[i] + l[j], " mult = ", l[i] * l[j])
        break
    end
end

## Part 2 - Just in case there is a part 3!

d = 3 # Nb of numbers to add
i = Vector(1:d)

while sum(l[i]) != 2020
    k = d
    i[k] += 1
    while i[k] > n
        i[k] = 1
        k -= 1
        i[k] += 1
    end
end

print(sum(l[i]))
print(prod(l[i]))

# for i = 1:(n-1)
#     for j = (i+1):n
#         if l[i] + l[j] == 2020
#             println(l[i], ",", l[j], " = ", l[i] + l[j])
#         end
#     end
# end
