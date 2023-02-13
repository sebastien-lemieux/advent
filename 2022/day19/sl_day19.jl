using StaticArrays

struct State
    robot::MVector{4, Int}
    res::MVector{4, Int}
end

produce(s::State) = State(copy(s.robot), s.res .+ s.robot)

const Blueprint = SMatrix{4, 4, Int}
b = Blueprint([4 0 0 0; 2 0 0 0; 3 14 0 0; 2 0 7 0])
can_build(s, b, rt) = all(s.res .≥ b[rt, :])
function build(s, b, rt)
    ns = State(s.robot, s.res .- b[rt, :])
    ns.robot[rt] += 1
    return ns
end

function build_next(s, b, minute, rt, max_min)
    minute == max_min && return s, max_min
    if can_build(s, b, rt)
        ns = produce(s)
        ns = build(ns, b, rt)
        return ns, minute + 1
    else
        ns = produce(s)
        return build_next(ns, b, minute + 1, rt, max_min)
    end
end

function search_order(s, b, minute, max_g, max_min)
    for i=1:4
        ns, nm = build_next(s, b, minute, i, max_min)
        if nm == max_min
            if ns.res[4] > max_g
                # println("$(ns.res[4])")
                max_g = ns.res[4]
            end
            return max_g
        end
        max_g = search_order(ns, b, nm, max_g, max_min)
    end
    return max_g
end

# search_order(current, bps[2], 1, 0, 32)

include("../../sl_common.jl")
bps = readFile("input.txt") do line
    m = match(r"Blueprint .*: Each ore robot costs (.*) ore. Each clay robot costs (.*) ore. Each obsidian robot costs (.*) ore and (.*) clay. Each geode robot costs (.*) ore and (.*) obsidian.", line)
    n = parse.(Int, m.captures)
    Blueprint([n[1] 0 0 0; n[2] 0 0 0; n[3] n[4] 0 0; n[5] 0 n[6] 0])
end

tot = 0
for i=1:length(bps)
    res = search_order(State([1, 0, 0, 0], [0, 0, 0, 0]), bps[i], 1, 0, 25)
    tot += i * res
    println("$i = $(res)")
end
tot # Part 1: 1177

@time search_order(State([1, 0, 0, 0], [0, 0, 0, 0]), bps[1], 1, 0, 33) # 36 -> 44
@time search_order(State([1, 0, 0, 0], [0, 0, 0, 0]), bps[2], 1, 0, 33) # 38 -> 46
@time search_order(State([1, 0, 0, 0], [0, 0, 0, 0]), bps[3], 1, 0, 33) # 26 -> 31

44 * 46 * 31 # 62744, runs for 30h on three cores
