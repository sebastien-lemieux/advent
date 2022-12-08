f = open("input.txt")

pwd = Vector{String}()
size = zeros(Int, 1)
sizes = Vector{Int}() # saved sizes

function cdpp()
    push!(sizes, pop!(size))
    pop!(pwd)
    size[end] += sizes[end]
end


while !eof(f)
    line = split(readline(f), " ")
    # println(line)
    if line[1] == "\$"
        if line[2] == "cd"
            if line[3][1] == '/'
                empty!(pwd)
            elseif line[3] == ".."
                cdpp()
            else
                push!(pwd, line[3])
                push!(size, 0)
            end
            # println("/" * join(pwd, "/"))
        end
    elseif line[1] == "dir"
        # do something with it!
    else
        size[end] += parse(Int, line[1])
    end
    # println(size)
end

while !isempty(pwd)
    cdpp()
end

looking_for = size[end] - 40_000_000

for s in sort(sizes)
    if s >= looking_for
        println(s)
        break
    end
end

# Part 1: 1432936
# Part 2: 272298