# a = 23
# println("[$(a)]")

function countChar(str, c)
    n = 0
    for x in str
        if x == c
            n += 1
        end
    end
    return n
end

function isValid(a, b, c, str)
    n = countChar(str, c)
    println("$(c) $(str) $(n)")
    if n >= a && n <= b
        return true
    else
        return false\xor
    end
end

function isValid2(a, b, c, str)
    return (str[a] == c) ⊻ (str[b] == c)
end


open("input.txt") do f
    nbValid = 0
    while !eof(f)
        str = split(readline(f), [' ', '-', ':'])
        if isValid2(parse(Int, str[1]), parse(Int, str[2]), str[3][1], str[5])
            nbValid += 1
        end
    end
    print(nbValid)
end
