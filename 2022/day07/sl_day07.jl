# struct Dir
#     parent::Dir
#     name::String
#     sub::Vector{Dir}
#     size::Int
# end

f = open("input.txt")

pwd = Vector{String}()
size = zeros(Int, 1)
sizes = Vector{Int}() # saved sizes
# the_sum = 0

while !eof(f)
    line = split(readline(f), " ")
    println(line)
    if line[1] == "\$"
        if line[2] == "cd"
            if line[3][1] == '/'
                empty!(pwd)
            elseif line[3] == ".."
                push!(sizes, pop!(size))
                # For part 1
                # if sizes[end] <= 100000
                #     println("Got: $(pwd)")
                #     the_sum += sizes[end]
                # end
                pop!(pwd)
                size[end] += sizes[end]
            else
                push!(pwd, line[3])
                push!(size, 0)
            end
            println("/" * join(pwd, "/"))
        elseif line[2] == "ls"
            # skip
        end
    elseif line[1] == "dir"
        # do something with it!
    else
        size[end] += parse(Int, line[1])
    end
    println(size)
end

while !isempty(pwd)
    push!(sizes, pop!(size))
    # For part 1
    # if sizes[end] <= 100000
    #     println("Got: $(pwd)")
    #     the_sum += sizes[end]
    # end
    pop!(pwd)
    size[end] += sizes[end]
end

# the_sum
