include("../../sl_common.jl")

import Base: parse
using DataStructures

abstract type Compo end

const low = false
const high = true
const off = false
const on = true

struct Connexion
    name::String
    dest::Vector{String}
end

struct Broadcaster <: Compo
    connexion::Connexion
end

mutable struct FlipFlop <: Compo
    connexion::Connexion
    state::Bool
end

mutable struct Conjunction <: Compo
    connexion::Connexion
    states::Dict{String, Bool}
end

name(c::Compo) = c.connexion.name
dest(c::Compo) = c.connexion.dest

# str = "%fh -> nt, xz"
# str = "&vv -> dm, bl, sb, nb, qd, bh"

function parse(::Type{Compo}, str::String)::Compo
    id, dest = split(str, " -> ")
    vd = split(dest, ", ")
    println(id)
    if id == "broadcaster"
        return Broadcaster(Connexion(id, vd))
    elseif id[1] == '%'
        return FlipFlop(Connexion(id[2:end], vd), off)
    else # &
        return Conjunction(Connexion(id[2:end], vd), Dict{String, Bool}())
    end
end

struct Pulse
    from::String
    to::String
    signal::Bool
end

lowCount = 0
highCount = 0
rxCount = 0

function send!(pq::Deque{Pulse}, p::Pulse)
    p.to ∈ watch && all(saveStates(circuit[p.to])) && println("Sending($gi) to $(p.to) - $(saveStates(circuit[p.to]))")
    p.signal ? (global highCount += 1) : (global lowCount += 1)
    !p.signal && p.to == "rx" && (global rxCount += 1)
    !haskey(circuit, p.to) && return

    s = logic!(p.from, circuit[p.to], p.signal)

    s !== nothing && for to in dest(circuit[p.to])
        p_out = Pulse(p.to, to, s)
        # println("  Queuing: $p_out")
        push!(pq, p_out)
    end
end

function logic!(from::String, to::FlipFlop, s::Bool)
    if s == low
        # println("$(to.state) -> $(!to.state)")
        to.state = !to.state
        return to.state
    end
end
function logic!(from::String, to::Conjunction, s::Bool)
    to.states[from] = s
    all(values(to.states)) && return low
    return high
end
logic!(from::String, to::Broadcaster, s::Bool) = s

# circuit = deepcopy(orig)

function pushButton()
    pq = Deque{Pulse}()
    push!(pq, Pulse("", "broadcaster", low))
    touching = String[]
    while !isempty(pq)
        p = popfirst!(pq)
        push!(touching, p.to)
        # println("sending $p")
        send!(pq, p)
    end
    return touching
end

saveStates(c::Broadcaster)::Vector{Bool} = []
saveStates(c::FlipFlop)::Vector{Bool} = [c.state]
saveStates(c::Conjunction)::Vector{Bool} = collect(values(c.states))

function saveStates()
    states = Bool[]
    for c in values(circuit)
        # println("Saving: $(saveStates(c))")
        states = vcat(states, saveStates(c))
    end
    return states
end

tmp = readFile(line -> parse(Compo, line), "input.txt", Vector{Compo})
circuit = Dict([(name(c), c) for c in tmp])
for c in values(circuit)
    for d in dest(c)
        if haskey(circuit, d)
            dst = circuit[d]
            if isa(dst, Conjunction)
                dst.states[name(c)] = low
            end
        end
    end
end

saved = Dict{Tuple{String, Vector{Bool}}, Int}()

# highCount = 0
# lowCount = 0
# rxCount = 0

watch = ["vv", "nt", "vn", "zq"]
gi = 1
@time for i in 1:10000
    gi = i
    pushButton()
end
z = (highCount, lowCount)

z[1] * z[2]

## part 2

# Premier hit pour les "grosses" Conjunction: vv, nt, vn, zq
lcm(3733, 3797, 3877, 3917)