include("../../sl_common.jl")

abstract type LinkedList{T} end

mutable struct Nil{T} <: LinkedList{T}
end

mutable struct Node{T} <: LinkedList{T}
    el::T
    prev::LinkedList{T}
    next::LinkedList{T}
end

# a = Node(23, Nil{Int}(), Nil{Int}())
# b = Node(24, a, Nil{Int}())

function circular(v)
    t = eltype(v)
    vec = Vector{LinkedList{t}}()
    first = Node(v[1], Nil{t}(), Nil{t}())
    push!(vec, first)
    last = first
    for i=2:length(v)
        last.next = Node(v[i], last, Nil{t}())
        last = last.next
        push!(vec, last)
    end
    first.prev = last
    last.next = first
    return first, vec
end

function Base.show(io::IO, l::Node{T}) where T
    first = l
    print(io, "$(l.el)")
    l = l.next
    while l != first
        print(io, ", $(l.el)")
        l = l.next
    end
end

function move(x::Node{Int}, m) ## deal with neg!
    x.prev.next = x.next
    x.next.prev = x.prev
    cur = x.next
    for i=1:abs(x.el % m)
        cur = (x.el > 0) ? cur.next : cur.prev
    end
    x.next = cur
    x.prev = cur.prev
    x.next.prev = x
    x.prev.next = x
end

a, v = circular([1, 2, -3, 3, -2, 0, 4]);

for i in v
    move(i)
end

a

f = readFile("input.txt", Vector{Int}) do line
    parse(Int, line)
end

n = length(f)
f = f .* 811589153
a, v = circular(f);
for it = 1:10
    for i in v
        move(i, n-1)
    end
end

while a.el != 0
    a = a.next
end

sum = 0
for it = 1:3
    for i=1:1000
        a = a.next
    end
    sum += a.el
end
sum ## Part 1: 2622
## Part 2: 1538773034088

