function find_marker(fn, buf_size)
    f = open("input.txt")

    buf = Vector{Char}()
    pos = 0

    while(!eof(f))
        c = read(f, Char)
        # println(c)
        pos += 1

        p = findfirst(x -> x==c, buf)
        isa(p, Int) && (buf = buf[(p+1):end])
        
        push!(buf, c)
        length(buf) > buf_size && popfirst!(buf)
        # println(buf)

        length(buf) == buf_size && return pos
    end
end

find_marker("input.txt", 4)  # 1282
find_marker("input.txt", 14) # 3513