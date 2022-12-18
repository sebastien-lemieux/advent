struct Signal
    sx::Int; sy::Int
    bx::Int; by::Int
end
Signal(sx::Int, sy::Int) = Signal(sx, sy, 0, 0)

Δb(s::Signal) = abs(s.bx - s.sx) + abs(s.by - s.sy)
Δs(a::Signal, b::Signal) = abs(a.sx - b.sx) + abs(a.sy - b.sy)
freq(a::Signal) = a.sx * 4_000_000 + a.sy

f = open("test_input.txt")
sig = Vector{Signal}()
while !eof(f)
    line = readline(f)
    push!(sig, Signal(parse.(Int, match(r"Sensor at x=(.*), y=(.*): closest beacon is at x=(.*), y=(.*)", line))...))
end

function borders(s::Signal)
    g = Δb(s) + 1
    [([1 1], g + s.sx + s.sy), ([1 1], -g + s.sx + s.sy), ([-1 1], g - s.sx + s.sy), ([-1 1], -g - s.sx + s.sy)]
end

M = zeros(Int, 0, 2)
R = zeros(Int, 0, 1)

for i=1:length(sig), j=(i+1):length(sig)
    bi = borders(sig[i])
    bj = borders(sig[j])
    local gap = Δs(sig[i], sig[j]) - (Δb(sig[i]) + Δb(sig[j]))

    gap == 2 && for ni=1:4, nj=1:4
        if bi[ni][2] == bj[nj][2]
            # gap == 2 && println("$i $j $gap")
            println("$i $j $gap")
            M = vcat(M, bi[ni][1])
            R = vcat(R, [bi[ni][2]])
            break
        end
    end
end

freq(Signal(Int.(M\R)...)) ## Part 2: 13743542639657