# input = "389125467" # demo
input = "418976235"

cups = parse.(Int, collect(input))

function move(cups)
    decr(x) = (x+7)%9+1
    current = cups[1]
    target = decr(current)
    while (i = findfirst(c -> c == target, cups)) < 5
        target = decr(target)
    end
    return vcat(cups[5:i], cups[2:4], cups[i+1:end], cups[1])
end

function report(cups)
    one = findfirst(c -> c == 1, cups)
    return join(vcat(cups[one+1:end], cups[1:one-1]))
end

for i = 1:100
    cups = move(cups)
end

# cups
report(cups) ## 96342875

## part 2 -------------------------------------------------------------------------

mutable struct Node
    data::Int
    prev::Node
    next::Node
    Node(data) = new(data)
    Node(data, prev, next) = new(data, prev, next)
end

function link!(a::Node, b::Node)
    a.next = b
    b.prev = a
end

mutable struct Cups ## Circular double-linked list
    current::Node
    index::Array{Node,1}
    max::Int
end

function Cups(ar)
    array = Node.(ar)
    index = Array{Node,1}(undef, length(array))
    for i in 1:length(array)
        index[ar[i]] = array[i]
        if i == 1 link!(array[end], array[i])
        else link!(array[i-1], array[i]) end
    end
    return Cups(array[1], index, max(ar...))
end

Base.show(io::IO, n::Node) = print(io, "$(n.data)")
Base.:+(n::Node, i::Int) = (i==0) ? n : n.next + (i - 1)
Base.copy(n::Node) = Node(n.data, n.prev, n.next)
function Base.show(io::IO, c::Cups)
    print(io, "($(c.current)), ")
    # ptr = c.current
    # while (ptr = ptr.next) != c.current
    #     print(io, "$(ptr), ")
    # end
end

decr(c::Cups, x::Int) = (x+(c.max - 2))%c.max+1

function splice!(a::Node, b::Node, c::Node)
    bn = b.next
    link!(b, c.next)
    link!(c, a.next)
    link!(a, bn)
end



function move!(cups)
    current = cups.current
    insert = current + 3
    nb = 3
    target = decr(cups, current.data)
    ptr = current
    while nb > 0
        nb -= 1
        ptr = ptr.next
        if target == ptr.data
            target = decr(cups, target)
            ptr = current
            nb = 3
        end
    end
    dest = cups.index[target]
    cups.current = current.next
    splice!(current, insert, dest)
end

input = "418976235"
cups = [x for x=1:1_000_000]
cups[1:9] = parse.(Int, collect(input))
cups = Cups(cups)

@time for i = 1:10_000_000 ## 0.4 sec
    move!(cups)
end

n = cups.index[1].next
nn = n.next

println("$(n.data * nn.data)") ## 563362809504
